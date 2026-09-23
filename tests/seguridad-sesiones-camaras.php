<?php
declare(strict_types=1);

/** Prueba local contra MySQL: todos los cambios de prueba se revierten. */
require __DIR__ . '/../config/config.php';
require CONFIG_PATH . 'autoload.php';
require HELPERS_PATH . 'auth.helper.php';
require HELPERS_PATH . 'validation.helper.php';

function comprobar(bool $condicion, string $mensaje): void
{
    if (!$condicion) throw new RuntimeException($mensaje);
}

$db = Conexion::conectar();
$db->beginTransaction();
$resultados = [];
try {
    $camaras = array_map('intval', $db->query('SELECT idCamara FROM camaras WHERE activo=1 ORDER BY idCamara LIMIT 2')->fetchAll(PDO::FETCH_COLUMN));
    comprobar(count($camaras) === 2, 'Se requieren dos cámaras activas para esta prueba.');
    $stmt = $db->prepare('SELECT idAfiliado FROM afiliados WHERE idCamara=:camara LIMIT 1');
    $stmt->execute(['camara' => $camaras[0]]);
    $idAfiliado = (int) $stmt->fetchColumn();
    comprobar($idAfiliado > 0, 'Se requiere un afiliado en la primera cámara.');

    $correo = 'prueba-seguridad-' . bin2hex(random_bytes(6)) . '@example.test';
    $hash = password_hash('PruebaSegura123', PASSWORD_DEFAULT);
    $db->prepare('INSERT INTO usuarios (idRol,nombre,correo,password_hash,activo) VALUES (3,?,?,?,1)')
       ->execute(['Prueba de seguridad', $correo, $hash]);
    $idUsuario = (int) $db->lastInsertId();
    $db->prepare('INSERT INTO usuarios_afiliados (idUsuario,idAfiliado,es_principal) VALUES (?,?,1)')
       ->execute([$idUsuario, $idAfiliado]);
    comprobar(ModeloUsuarios::registrarIngreso($idUsuario, $hash), 'El ingreso con el hash vigente debe registrarse.');
    comprobar(!ModeloUsuarios::registrarIngreso($idUsuario, 'hash-obsoleto'), 'Un hash obsoleto no debe registrar el ingreso.');
    $nuevoHash = password_hash('PruebaSegura123', PASSWORD_DEFAULT);
    comprobar(ModeloUsuarios::registrarIngreso($idUsuario, $hash, $nuevoHash), 'El ingreso debe poder renovar el hash.');
    comprobar((string) $db->query('SELECT password_hash FROM usuarios WHERE idUsuario=' . $idUsuario)->fetchColumn() === $nuevoHash, 'El nuevo hash debe persistirse.');
    $resultados[] = 'Login: hash vigente y renovación comprobados';

    $iniciar = static function () use ($correo): void {
        if (session_status() !== PHP_SESSION_ACTIVE) session_start();
        $usuario = ModeloUsuarios::buscarParaAutenticacion($correo);
        comprobar($usuario !== null, 'No se encontró el usuario de prueba.');
        iniciarSesionUsuario($usuario);
        comprobar(validarSesionActual(), 'La sesión recién iniciada debe ser válida.');
    };

    $ahora = 40_000;
    comprobar(sesionDentroDeLimites(['login_timestamp' => $ahora - 28_799, 'ultima_actividad_at' => $ahora - 899], $ahora), 'Los límites deben admitir el instante anterior al vencimiento.');
    comprobar(!sesionDentroDeLimites(['login_timestamp' => $ahora - 1_000, 'ultima_actividad_at' => $ahora - 900], $ahora), 'La sesión debe vencer a los 15 minutos de inactividad.');
    comprobar(!sesionDentroDeLimites(['login_timestamp' => $ahora - 28_800, 'ultima_actividad_at' => $ahora - 1], $ahora), 'La sesión debe vencer a las 8 horas aunque exista actividad.');
    comprobar(!sesionDentroDeLimites(['login_timestamp' => $ahora - 1], $ahora), 'Una sesión anterior sin registro de actividad debe cerrarse.');

    $iniciar();
    $_SESSION['login_timestamp'] = time() - 120;
    $_SESSION['ultima_actividad_at'] = time() - 60;
    $actividadAnterior = $_SESSION['ultima_actividad_at'];
    comprobar(validarSesionActual() && $_SESSION['ultima_actividad_at'] === $actividadAnterior, 'Comprobar la sesión no debe renovar su actividad.');
    $resultados[] = 'Peticiones automáticas: comprobación sin renovación';
    $_SESSION['ultima_actividad_at'] = time() - SESSION_IDLE_TIMEOUT;
    comprobar(!validarSesionActual(), 'La petición posterior al plazo de inactividad debe cerrar la sesión.');
    $resultados[] = 'Inactividad: sesión cerrada a los 15 minutos';

    $iniciar();
    $_SESSION['login_timestamp'] = time() - SESSION_ABSOLUTE_TIMEOUT;
    comprobar(!validarSesionActual(), 'La petición posterior al plazo absoluto debe cerrar la sesión.');
    $resultados[] = 'Duración máxima: sesión cerrada a las 8 horas';

    $iniciar();
    $_SESSION['ultima_actividad_at'] = time() - 30;
    $_SESSION['csrf_token_time'] = time() - 30;
    registrarActividadSesion();
    comprobar($_SESSION['ultima_actividad_at'] >= time() - 1 && $_SESSION['csrf_token_time'] === $_SESSION['ultima_actividad_at'], 'La actividad debe renovar también la vigencia del CSRF.');
    comprobar(validarSesionActual(), 'La actividad reciente debe mantener la sesión válida.');
    $resultados[] = 'Actividad: plazo de inactividad y CSRF renovados';

    ModeloUsuarios::actualizarPasswordAcceso($db, $idUsuario, password_hash('NuevaPruebaSegura123', PASSWORD_DEFAULT));
    comprobar(!validarSesionActual(), 'El cambio de contraseña debe revocar la sesión.');
    $resultados[] = 'Contraseña: sesión revocada';

    $iniciar();
    comprobar(ModeloUsuarios::cambiarEstadoAdministracion($idUsuario, false), 'La desactivación de prueba debe realizarse.');
    comprobar(!validarSesionActual(), 'La desactivación debe revocar la sesión.');
    $resultados[] = 'Desactivación: sesión revocada';

    comprobar(ModeloUsuarios::cambiarEstadoAdministracion($idUsuario, true), 'La reactivación de prueba debe realizarse.');
    $iniciar();
    $db->prepare('UPDATE usuarios SET idRol=2 WHERE idUsuario=?')->execute([$idUsuario]);
    comprobar(!validarSesionActual(), 'El cambio de rol debe revocar la sesión.');
    $resultados[] = 'Rol: sesión revocada';

    $db->prepare('INSERT INTO usuarios_camaras (idUsuario,idCamara) VALUES (?,?)')->execute([$idUsuario, $camaras[0]]);
    $iniciar();
    $db->prepare('UPDATE usuarios_camaras SET idCamara=? WHERE idUsuario=?')->execute([$camaras[1], $idUsuario]);
    comprobar(!validarSesionActual(), 'El cambio de cámara asignada debe revocar la sesión.');
    $resultados[] = 'Cámara asignada: sesión revocada';

    $db->prepare('DELETE FROM usuarios_camaras WHERE idUsuario=?')->execute([$idUsuario]);
    $db->prepare('UPDATE usuarios SET idRol=3 WHERE idUsuario=?')->execute([$idUsuario]);
    $iniciar();
    $db->prepare('DELETE FROM usuarios_afiliados WHERE idUsuario=?')->execute([$idUsuario]);
    comprobar(!validarSesionActual(), 'El retiro de un afiliado debe revocar la sesión.');
    $resultados[] = 'Asignación: sesión revocada';

    $afiliado = ModeloAfiliados::obtenerPorId($idAfiliado);
    comprobar($afiliado !== null, 'No se encontró el afiliado de prueba.');
    $matriz = $afiliado['matriz'] ?? [];
    $contacto = $afiliado['contacto'] ?? [];
    $telefono = static fn(string $tipo): string => (string) (array_values(array_filter($afiliado['telefonos'], static fn(array $x): bool => $x['tipo'] === $tipo))[0]['numero_original'] ?? '');
    $canal = static fn(string $tipo): string => (string) (array_values(array_filter($afiliado['canales'], static fn(array $x): bool => $x['tipo'] === $tipo))[0]['url'] ?? '');
    $datos = [
        'idAfiliado' => $idAfiliado, 'idCamara' => $camaras[1],
        'rfc' => $afiliado['rfc'], 'razon_social' => $afiliado['razon_social'],
        'nombre_comercial' => $afiliado['nombre_comercial'], 'slug' => $afiliado['slug'],
        'descripcion' => $afiliado['descripcion'], 'correo_general' => $afiliado['correo_general'],
        'idUsuario' => $idUsuario, 'encargado' => $contacto['nombre'] ?? '',
        'cargo_encargado' => $contacto['cargo'] ?? '', 'telefono' => $telefono('TELEFONO'),
        'whatsapp' => $telefono('WHATSAPP'), 'idLocalidad' => $matriz['idLocalidad'] ?? null,
        'calle' => $matriz['calle'] ?? '', 'numero_exterior' => $matriz['numero_exterior'] ?? '',
        'numero_interior' => $matriz['numero_interior'] ?? '', 'colonia' => $matriz['colonia'] ?? '',
        'codigo_postal' => $matriz['codigo_postal'] ?? '', 'referencias' => $matriz['referencias'] ?? '',
        'latitud' => $matriz['latitud'] ?? '', 'longitud' => $matriz['longitud'] ?? '',
        'google_place_id' => $matriz['google_place_id'] ?? '',
        'facebook' => $canal('FACEBOOK'), 'instagram' => $canal('INSTAGRAM'),
        'tiktok' => $canal('TIKTOK'), 'sitio_web' => $canal('SITIO_WEB'),
        'categorias' => array_map('intval', array_column($afiliado['categorias'], 'idCategoria')),
        'palabras' => array_column($afiliado['palabras_clave'], 'palabra'),
    ];
    ModeloAfiliados::guardarCompleto($db, $datos, false);
    comprobar(ModeloAfiliados::camaraDeAfiliado($idAfiliado) === $camaras[0], 'La edición ordinaria no debe cambiar la cámara.');
    $resultados[] = 'Afiliado: cambio de cámara impedido';

    ModeloAfiliados::guardarCompleto($db, $datos, true);
    comprobar(ModeloAfiliados::camaraDeAfiliado($idAfiliado) === $camaras[1], 'La edición del Administrador General debe permitir el cambio.');
    $resultados[] = 'Administrador General: cambio de cámara permitido';

    $db->prepare('INSERT INTO usuarios_afiliados (idUsuario,idAfiliado,es_principal) VALUES (?,?,1)')
       ->execute([$idUsuario, $idAfiliado]);
    $iniciar();
    $permiso = $db->query('SELECT idPermiso FROM roles_permisos WHERE idRol=3 LIMIT 1')->fetchColumn();
    comprobar($permiso !== false, 'Se requiere un permiso del rol AFILIADO.');
    $db->prepare('DELETE FROM roles_permisos WHERE idRol=3 AND idPermiso=?')->execute([$permiso]);
    comprobar(!validarSesionActual(), 'El retiro de un permiso del rol debe revocar la sesión.');
    $resultados[] = 'Permisos: sesión revocada';
} finally {
    if ($db->inTransaction()) $db->rollBack();
    if (session_status() === PHP_SESSION_ACTIVE) session_destroy();
}

foreach ($resultados as $resultado) echo "OK $resultado\n";
