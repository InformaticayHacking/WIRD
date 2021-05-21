<?php
if (count($_FILES) <= 0 || empty($_FILES["video"])) {
    exit("No hay archivos");
}
$rutaVideoSubido = $_FILES["video"]["tmp_name"];
$nuevoNombre = "capturado.webm";
$rutaDeGuardado = __DIR__ . "/" . $nuevoNombre;
move_uploaded_file($_FILES["video"]["tmp_name"], $rutaDeGuardado);
echo $nuevoNombre;
