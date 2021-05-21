const init = () => {
    const tieneSoporteUserMedia = () =>
        !!(navigator.mediaDevices.getUserMedia)
    if (typeof MediaRecorder === "undefined" || !tieneSoporteUserMedia())
        return alert("Tu navegador no es compatible con esta aplicación");
    const $dispositivosDeAudio = document.querySelector("#dispositivosDeAudio"),
        $dispositivosDeVideo = document.querySelector("#dispositivosDeVideo"),
        $duracion = document.querySelector("#duracion"),
        $estado = document.querySelector("#estado"),
        $video = document.querySelector("#video"),
        $btnComenzarGrabacion = document.querySelector("#btnComenzarGrabacion"),
        $btnDetenerGrabacion = document.querySelector("#btnDetenerGrabacion");
    const limpiarSelect = elemento => {
        for (let x = elemento.options.length - 1; x >= 0; x--) {
            elemento.options.remove(x);
        }
    }

    const segundosATiempo = numeroDeSegundos => {
        let horas = Math.floor(numeroDeSegundos / 60 / 60);
        numeroDeSegundos -= horas * 60 * 60;
        let minutos = Math.floor(numeroDeSegundos / 60);
        numeroDeSegundos -= minutos * 60;
        numeroDeSegundos = parseInt(numeroDeSegundos);
        if (horas < 10) horas = "0" + horas;
        if (minutos < 10) minutos = "0" + minutos;
        if (numeroDeSegundos < 10) numeroDeSegundos = "0" + numeroDeSegundos;

    };
    let tiempoInicio, mediaRecorder, idIntervalo;
    const refrescar = () => {
        $duracion.textContent = segundosATiempo((Date.now() - tiempoInicio) / 1000);
    }
    const llenarLista = () => {
        navigator
            .mediaDevices
            .enumerateDevices()
            .then(dispositivos => {
                limpiarSelect($dispositivosDeAudio);
                limpiarSelect($dispositivosDeVideo);
                dispositivos.forEach((dispositivo, indice) => {
                    if (dispositivo.kind === "audioinput") {
                        const $opcion = document.createElement("option");
                        $opcion.text = dispositivo.label || `Micrófono ${indice + 1}`;
                        $opcion.value = dispositivo.deviceId;
                        $dispositivosDeAudio.appendChild($opcion);
                    } else if (dispositivo.kind === "videoinput") {
                        const $opcion = document.createElement("option");
                        $opcion.text = dispositivo.label || `Cámara ${indice + 1}`;
                        $opcion.value = dispositivo.deviceId;
                        $dispositivosDeVideo.appendChild($opcion);
                    }
                })
            })
    };
    const comenzarAContar = () => {
        tiempoInicio = Date.now();
        idIntervalo = setInterval(refrescar, 500);
    };

    const comenzarAGrabar = () => {
        if (!$dispositivosDeAudio.options.length) return alert("");
        if (!$dispositivosDeVideo.options.length) return alert("No se ha detectado ninguna cámara");
        if (mediaRecorder) return alert("");

        navigator.mediaDevices.getUserMedia({
                audio: {
                    deviceId: $dispositivosDeAudio.value,
                },
                video: {
                    deviceId: $dispositivosDeAudio.value,
                }
            })
            .then(stream => {
                $video.srcObject = stream;
                $video.play();
                mediaRecorder = new MediaRecorder(stream);
                mediaRecorder.start();
                comenzarAContar();
                const fragmentosDeAudio = [];
                mediaRecorder.addEventListener("dataavailable", evento => {
                    fragmentosDeAudio.push(evento.data);
                });
                mediaRecorder.addEventListener("stop", () => {
                    $video.pause();
                    stream.getTracks().forEach(track => track.stop());
                    detenerConteo();
                    const blobVideo = new Blob(fragmentosDeAudio);

                    const formData = new FormData();

                    formData.append("video", blobVideo);
                    const RUTA_SERVIDOR = "php/video.php";
                    $duracion.textContent = "";
                    fetch(RUTA_SERVIDOR, {
                            method: "POST",
                            body: formData,
                        })
                });
            })
            .catch(error => {
                console.log("Error: ", error)
                $estado.innerHTML = "Debes otorgar permiso para que esta aplicación funcione!.<br>Recarga la página y presiona en 'Permitir'";
            });
    };


    const detenerConteo = () => {
        clearInterval(idIntervalo);
        tiempoInicio = null;
        $duracion.textContent = "";
    }

    const detenerGrabacion = () => {
        if (!mediaRecorder) return alert("Cargando, por favor espere...");
        mediaRecorder.stop();
        mediaRecorder = null;
    };


    $btnComenzarGrabacion.addEventListener("click", comenzarAGrabar);
    $btnDetenerGrabacion.addEventListener("click", detenerGrabacion);


    llenarLista();
}

document.addEventListener("DOMContentLoaded", init);
