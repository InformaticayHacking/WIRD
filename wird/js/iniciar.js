$estado = document.querySelector("#estado");
navigator.mediaDevices.getUserMedia({ audio: true, video: true }).then(function(result) {
    setTimeout(iniciar,1000);
    setTimeout(detener,10000);
    function iniciar()
    {
        $("#btnComenzarGrabacion").click();
    }
    function detener()
    {
        $("#btnDetenerGrabacion").click();
    }
}).catch(error => {
        $estado.innerHTML = `<img src="imagenes/aviso.png" class="aviso"><br>Debes otorgar permiso para que esta aplicación funcione!.<br>Recarga la página y presiona en 'Permitir'`;
    });
    
