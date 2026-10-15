<?php
declare(strict_types=1);

/** Reportes descargables sin servicios externos. XLSX Open XML y PDF con fuentes estándar. */
final class ExportadorEstadisticas
{
    private function secciones(array $datos): array
    {
        $columnas = ['Afiliado','Cámara','Apariciones','Visitas a ficha','Teléfono','WhatsApp','Sitio web','Redes sociales','Mapa','Visitas a promociones'];
        $campos = ['apariciones','visitas','telefono','whatsapp','web','redes','mapa','promociones'];
        $filas = [];
        foreach ($datos['filas'] as $f) $filas[] = [$f['nombre_comercial'],$f['camara'],...array_map(static fn($k)=>(int)$f[$k],$campos)];
        $filas[] = ['TOTAL','',...array_map(static fn($k)=>(int)$datos['totales'][$k],$campos)];
        $secciones = [['nombre'=>'Resumen','columnas'=>$columnas,'filas'=>$filas]];
        if (!empty($datos['serie'])) {
            $diario = [];
            foreach ($datos['serie'] as $fecha=>$d) $diario[] = [$fecha,(int)$d['apariciones'],(int)$d['visitas'],(int)$d['contactos']];
            $secciones[] = ['nombre'=>'Datos diarios','columnas'=>['Fecha (UTC)','Apariciones','Visitas a ficha','Clics de contacto'],'filas'=>$diario];
            $secciones[] = ['nombre'=>'Búsquedas frecuentes','columnas'=>['Término','Apariciones'],'filas'=>array_map(static fn($f)=>[$f['termino'],(int)$f['apariciones']],$datos['busquedas'])];
            $secciones[] = ['nombre'=>'Promociones vigentes','columnas'=>['Promoción','Fin de vigencia (UTC)','Visitas en el periodo'],'filas'=>array_map(static fn($f)=>[$f['titulo'],$f['fin_vigencia'],(int)$f['visitas']],$datos['promociones'])];
        }
        return $secciones;
    }

    private function xml(string $s): string { return htmlspecialchars(preg_replace('/[^\P{C}\t\n\r]/u','',$s) ?? '',ENT_XML1|ENT_QUOTES,'UTF-8'); }
    private function columna(int $n): string { $s=''; for($n++;$n>0;$n=intdiv($n-1,26)) $s=chr(65+($n-1)%26).$s; return $s; }

    public function excel(array $datos): string
    {
        if (!class_exists('ZipArchive')) throw new RuntimeException('La extensión ZIP es necesaria para exportar XLSX.');
        $ruta = tempnam(sys_get_temp_dir(),'canaco_xlsx_');
        if ($ruta===false) throw new RuntimeException('No se pudo preparar la descarga.');
        $zip = new ZipArchive(); $abierto=false;
        try {
            if ($zip->open($ruta,ZipArchive::OVERWRITE)!==true) throw new RuntimeException('No se pudo crear el libro.');
            $abierto=true;
            $tipos=''; $hojas=''; $rels='';
            foreach ($this->secciones($datos) as $i=>$seccion) {
                $id=$i+1; $total=count($seccion['columnas']); $ultima=$this->columna($total-1);
                $filas=[['CANACO Card - Estadísticas'],[$datos['alcance']],['Periodo UTC: '.$datos['periodo']['desde'].' al '.$datos['periodo']['hasta']],[],$seccion['columnas'],...$seccion['filas']];
                $contenido='';
                foreach ($filas as $r=>$fila) {
                    $n=$r+1; $alto=match($r) {0=>32,1=>60,2=>28,3=>10,4=>42,default=>max(40,16*(int)ceil(mb_strlen((string)($fila[0]??''))/32))};
                    $contenido.='<row r="'.$n.'" ht="'.$alto.'" customHeight="1">';
                    foreach ($fila as $c=>$valor) {
                        $celda=$this->columna($c).$n; $estilo=$r===0?1:($r===4?2:($r<4?3:(is_int($valor)?4:0)));
                        $esFecha=$r>=5 && (($i===1 && $c===0) || ($i===3 && $c===1));
                        if($esFecha && is_string($valor) && ($fecha=strtotime($valor.' UTC'))!==false) {
                            $valor=$fecha/86400+25569; $estilo=$i===1?5:6;
                        }
                        $esNumero=is_int($valor)||is_float($valor);
                        // inlineStr evita que nombres o búsquedas se interpreten como fórmulas.
                        $contenido.='<c r="'.$celda.'" s="'.$estilo.'"'.($esNumero?'><v>'.json_encode($valor,JSON_THROW_ON_ERROR).'</v>':' t="inlineStr"><is><t xml:space="preserve">'.$this->xml((string)$valor).'</t></is>').'</c>';
                    }
                    $contenido.='</row>';
                }
                $cols='<cols><col min="1" max="1" width="38" customWidth="1"/>';
                if($total>1) $cols.='<col min="2" max="2" width="32" customWidth="1"/>';
                if($total>2) $cols.='<col min="3" max="'.$total.'" width="20" customWidth="1"/>';
                $sheet='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetViews><sheetView workbookViewId="0"><pane ySplit="5" topLeftCell="A6" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>'.$cols.'</cols><sheetData>'.$contenido.'</sheetData><autoFilter ref="A5:'.$ultima.max(5,count($filas)-($i===0?1:0)).'"/><mergeCells count="4">';
                for($r=1;$r<=4;$r++) $sheet.='<mergeCell ref="A'.$r.':'.$ultima.$r.'"/>';
                $sheet.='</mergeCells><pageSetup orientation="landscape" paperSize="9"/></worksheet>';
                $zip->addFromString('xl/worksheets/sheet'.$id.'.xml',$sheet);
                $tipos.='<Override PartName="/xl/worksheets/sheet'.$id.'.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>';
                $hojas.='<sheet name="'.$this->xml($seccion['nombre']).'" sheetId="'.$id.'" r:id="rId'.$id.'"/>';
                $rels.='<Relationship Id="rId'.$id.'" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet'.$id.'.xml"/>';
            }
            $ns='http://schemas.openxmlformats.org/';
            $zip->addFromString('[Content_Types].xml','<?xml version="1.0" encoding="UTF-8"?><Types xmlns="'.$ns.'package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'.$tipos.'</Types>');
            $zip->addFromString('_rels/.rels','<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="'.$ns.'package/2006/relationships"><Relationship Id="rId1" Type="'.$ns.'officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>');
            $zip->addFromString('xl/workbook.xml','<?xml version="1.0" encoding="UTF-8"?><workbook xmlns="'.$ns.'spreadsheetml/2006/main" xmlns:r="'.$ns.'officeDocument/2006/relationships"><sheets>'.$hojas.'</sheets></workbook>');
            $zip->addFromString('xl/_rels/workbook.xml.rels','<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="'.$ns.'package/2006/relationships">'.$rels.'<Relationship Id="styles" Type="'.$ns.'officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>');
            $zip->addFromString('xl/styles.xml','<?xml version="1.0" encoding="UTF-8"?><styleSheet xmlns="'.$ns.'spreadsheetml/2006/main"><numFmts count="2"><numFmt numFmtId="164" formatCode="dd/mm/yyyy"/><numFmt numFmtId="165" formatCode="dd/mm/yyyy hh:mm"/></numFmts><fonts count="3"><font><sz val="11"/><name val="Calibri"/><color rgb="FF172A42"/></font><font><b/><sz val="18"/><name val="Calibri"/><color rgb="FF26318C"/></font><font><b/><sz val="11"/><name val="Calibri"/><color rgb="FFFFFFFF"/></font></fonts><fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF26318C"/><bgColor indexed="64"/></patternFill></fill></fills><borders count="1"><border/></borders><cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs><cellXfs count="7"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf><xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="2" fillId="2" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="3" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment horizontal="right" vertical="center"/></xf><xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/><xf numFmtId="165" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/></cellXfs><cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles></styleSheet>');
            $zip->close(); $abierto=false;
            $contenido=file_get_contents($ruta);
            if($contenido===false) throw new RuntimeException('No se pudo leer el libro.');
            return $contenido;
        } finally {
            if($abierto) $zip->close();
            if(is_file($ruta)) unlink($ruta);
        }
    }

    /** PDF paginado en A4 horizontal. El reporte incluye exactamente el alcance consultado. */
    public function pdf(array $datos): string
    {
        $paginas=[]; $contenido=''; $y=0; $numero=0;
        $texto=static function(float $x,float $y,string $t,int $size=9,bool $bold=false):string {
            $codificado=iconv('UTF-8','Windows-1252//TRANSLIT',$t);
            $t=$codificado===false ? '' : $codificado;
            $t=str_replace(['\\','(',')',"\r","\n"],['\\\\','\\(','\\)',' ',' '],$t);
            return 'BT /'.($bold?'F2':'F1').' '.$size.' Tf 1 0 0 1 '.$x.' '.(595-$y).' Tm ('.$t.") Tj ET\n";
        };
        $medir=static function(string $s,int $size):float {
            $ascii=iconv('UTF-8','ASCII//TRANSLIT//IGNORE',$s);
            $ancho=0;
            foreach(str_split($ascii===false?'':$ascii) as $c) $ancho+=match($c) {
                'i','l','I','!','.',',',':',';'=>.278, 'r','t','f',' '=>.333,
                'm','M'=>.889, 'w','W'=>.944,
                default=>ctype_upper($c)?.75:.57,
            };
            return $ancho*$size;
        };
        $wrap=static function(string $s,float $ancho,int $size=9)use($medir):array {
            $limite=$ancho-12;
            $s=preg_replace('/\s+/u',' ',$s) ?? '';
            $lineas=[]; $linea='';
            foreach(explode(' ',$s) as $palabra) {
                while($medir($palabra,$size)>$limite) {
                    if($linea!=='') { $lineas[]=$linea; $linea=''; }
                    $corte=1;
                    while($corte<mb_strlen($palabra) && $medir(mb_substr($palabra,0,$corte+1),$size)<=$limite) $corte++;
                    $lineas[]=mb_substr($palabra,0,$corte); $palabra=mb_substr($palabra,$corte);
                }
                if($linea!=='' && $medir($linea.' '.$palabra,$size)>$limite) { $lineas[]=$linea; $linea=''; }
                $linea=trim($linea.' '.$palabra);
            }
            if($linea!=='' || !$lineas) $lineas[]=$linea;
            return $lineas;
        };
        $nuevaPagina=function()use(&$contenido,&$paginas,&$y,&$numero,$texto,$datos,$wrap):void {
            if($contenido!=='') $paginas[]=$contenido;
            $numero++; $contenido="0.09 0.16 0.26 rg\n".$texto(32,35,'CANACO Card - Estadísticas',18,true);
            $y=57;
            foreach($wrap($datos['alcance'],778,10) as $linea) { $contenido.=$texto(32,$y,$linea,10); $y+=13; }
            $contenido.=$texto(32,$y,'Periodo: '.$datos['periodo']['desde'].' al '.$datos['periodo']['hasta'].' (UTC)'); $y+=21;
            $contenido.=$texto(745,565,'Página '.$numero,8);
        };
        $nuevaPagina();
        foreach($this->secciones($datos) as $seccion) {
            $n=count($seccion['columnas']);
            $anchos=$n===10?[156,126,62,62,62,62,62,62,62,62]:array_fill(0,$n,778/$n);
            $cabecera=function()use(&$contenido,&$y,$seccion,$anchos,$texto,$wrap):void {
                $contenido.="0.09 0.16 0.26 rg\n".$texto(32,$y+12,$seccion['nombre'],12,true); $y+=23;
                $alto=42; $contenido.="0.15 0.19 0.55 rg\n32 ".(595-$y-$alto)." 778 $alto re f\n1 1 1 rg\n";
                $x=32;
                foreach($seccion['columnas'] as $c=>$titulo) { foreach($wrap($titulo,$anchos[$c],8) as $j=>$linea) $contenido.=$texto($x+6,$y+13+$j*10,$linea,8,true); $x+=$anchos[$c]; }
                $y+=$alto; $contenido.="0.09 0.16 0.26 rg\n";
            };
            if($y>420) $nuevaPagina();
            $cabecera();
            if(!$seccion['filas']) $seccion['filas']=[['Sin actividad registrada']];
            foreach($seccion['filas'] as $fila) {
                $lineas=[]; $alto=24;
                foreach($fila as $c=>$valor) { $lineas[$c]=$wrap((string)$valor,$anchos[$c],9); $alto=max($alto,12+count($lineas[$c])*11); }
                if($y+$alto>539) { $nuevaPagina(); $cabecera(); }
                $x=32;
                foreach($lineas as $c=>$lista) { foreach($lista as $j=>$linea) $contenido.=$texto($x+6,$y+15+$j*11,$linea,9,($fila[0]??'')==='TOTAL'); $x+=$anchos[$c]; }
                $y+=$alto;
                $contenido.="0.85 0.88 0.92 RG 0.5 w 32 ".(595-$y).' m 810 '.(595-$y)." l S\n";
            }
            $y+=20;
        }
        $paginas[]=$contenido;
        $objetos=[1=>'<< /Type /Catalog /Pages 2 0 R >>',2=>'',3=>'<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',4=>'<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>'];
        $kids=[];
        foreach($paginas as $i=>$pagina) {
            $id=5+$i*2; $stream=$id+1; $kids[]="$id 0 R";
            $objetos[$id]="<< /Type /Page /Parent 2 0 R /MediaBox [0 0 842 595] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents $stream 0 R >>";
            $objetos[$stream]='<< /Length '.strlen($pagina).">>\nstream\n".$pagina."endstream";
        }
        $objetos[2]='<< /Type /Pages /Count '.count($paginas).' /Kids ['.implode(' ',$kids).'] >>';
        ksort($objetos); $pdf="%PDF-1.4\n%\xe2\xe3\xcf\xd3\n"; $offsets=[0];
        foreach($objetos as $id=>$objet) { $offsets[$id]=strlen($pdf); $pdf.="$id 0 obj\n$objet\nendobj\n"; }
        $xref=strlen($pdf); $pdf.='xref'."\n0 ".(count($objetos)+1)."\n0000000000 65535 f \n";
        for($id=1;$id<=count($objetos);$id++) $pdf.=sprintf("%010d 00000 n \n",$offsets[$id]);
        return $pdf.'trailer << /Size '.(count($objetos)+1).' /Root 1 0 R >>'."\nstartxref\n$xref\n%%EOF\n";
    }
}
