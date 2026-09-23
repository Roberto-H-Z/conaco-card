<?php
declare(strict_types=1);

/** Inicio privado del afiliado. El ID solicitado siempre se comprueba contra su usuario. */
final class ControladorInicio
{
    public function index(): array
    {
        $usuario = obtenerUsuarioSesion();
        if ($usuario === null || $usuario['rol'] !== 'AFILIADO') {
            http_response_code(403);
            return ['error' => 'Esta sección está disponible para afiliados.'];
        }

        try {
            $modelo = new ModeloEstadisticas();
            $empresas = $modelo->empresasDelUsuario($usuario['id']);
        } catch (PDOException $e) {
            registrarLog('Empresas de inicio: '.$e->getMessage(), 'ERROR');
            http_response_code(503);
            return ['error' => 'No pudimos cargar tu empresa. Intenta de nuevo en unos momentos.'];
        }
        $solicitado = $_GET['afiliado'] ?? null;
        if ($solicitado !== null && (!is_string($solicitado) || !ctype_digit($solicitado))) {
            http_response_code(400);
            return ['error' => 'Selecciona una empresa válida.'];
        }
        $id = $solicitado === null ? (int) ($empresas[0]['idAfiliado'] ?? 0) : (int) $solicitado;
        $empresa = null;
        foreach ($empresas as $candidata) {
            if ((int) $candidata['idAfiliado'] === $id) $empresa = $candidata;
        }
        if ($empresa === null) {
            http_response_code(403);
            return ['error' => 'No tienes acceso a las estadísticas de esa empresa.'];
        }

        try {
            return ['empresas' => $empresas, 'empresa' => $empresa, 'resumen' => $modelo->resumen($id),
                'serie' => $modelo->serieDiaria($id), 'busquedas' => $modelo->busquedasFrecuentes($id),
                'promociones' => $modelo->promociones($id), 'perfil' => $modelo->perfil($id),
                'periodo' => $modelo->periodo()];
        } catch (PDOException $e) {
            registrarLog('Estadísticas de inicio: '.$e->getMessage(), 'ERROR');
            http_response_code(503);
            return ['error' => 'No pudimos cargar tus estadísticas. Intenta de nuevo en unos momentos.'];
        }
    }
}
