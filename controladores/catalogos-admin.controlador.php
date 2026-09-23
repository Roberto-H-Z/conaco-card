<?php
declare(strict_types=1);

abstract class ControladorCatalogosAdmin
{
    protected function autorizar(?string $permiso): void { if(!tieneRol('ADMIN_GENERAL')||($permiso!==null&&!tienePermiso($permiso)))$this->json(['status'=>'error','message'=>'Esta gestión está disponible únicamente para el Administrador General.'],403); }
    protected function idGet(string $n='id'): int { $id=filter_input(INPUT_GET,$n,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);if(!$id)$this->json(['status'=>'error','message'=>'Identificador inválido.'],422);return(int)$id; }
    protected function entrada(): array { $x=$_POST?:json_decode((string)file_get_contents('php://input'),true);if(!is_array($x))$this->json(['status'=>'error','message'=>'Solicitud inválida.'],400);return$x; }
    protected function csrf(array $x): void { if(!validarTokenCSRF((string)($_SERVER['HTTP_X_CSRF_TOKEN']??($x['csrf_token']??''))))$this->json(['status'=>'error','message'=>'La sesión del formulario expiró. Recarga la página.'],419); }
    protected function metodo(string $m): void { if(($_SERVER['REQUEST_METHOD']??'GET')!==$m)$this->json(['status'=>'error','message'=>'Método no permitido.'],405); }
    protected function json(array $x,int $status=200): never { http_response_code($status);header('Content-Type: application/json; charset=utf-8');echo json_encode($x,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);exit; }
}
