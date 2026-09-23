<?php
declare(strict_types=1);

/** Recibe clics públicos sin interrumpir la navegación del visitante. */
final class ControladorEventoPublico
{
    public function registrar(): void
    {
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
            http_response_code(405); header('Allow: POST'); return;
        }
        if (estaAutenticado()) { http_response_code(204); return; }
        $token = $_POST['csrf_token'] ?? null;
        if (!is_string($token) || !validarTokenCSRF($token, 28800)) {
            http_response_code(419); echo json_encode(['status'=>'error']); return;
        }
        $id = filter_var($_POST['afiliado'] ?? null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $tipo = $_POST['tipo'] ?? null;
        $permitidos = ['CLIC_TELEFONO','CLIC_WHATSAPP','CLIC_SITIO_WEB','CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL','CLIC_MAPA'];
        if (!is_int($id) || !is_string($tipo) || !in_array($tipo,$permitidos,true)) {
            http_response_code(400); echo json_encode(['status'=>'error']); return;
        }
        $relaciones = [];
        foreach (['promocion','sucursal','canal'] as $clave) {
            $valor = $_POST[$clave] ?? '';
            $relaciones[$clave] = $valor === '' ? null : (is_string($valor) ? filter_var($valor,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]) : false);
            if ($relaciones[$clave] === false) { http_response_code(400); echo json_encode(['status'=>'error']); return; }
        }
        try {
            $ok = (new ModeloEstadisticas())->registrarEvento((int)$id,$tipo,$relaciones['promocion'],$relaciones['sucursal'],$relaciones['canal']);
            http_response_code($ok ? 204 : 400);
        } catch (Throwable $e) {
            registrarLog('Evento público: '.$e->getMessage(),'ERROR');
            http_response_code(503);
        }
    }
}
