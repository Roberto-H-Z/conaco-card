from __future__ import annotations

import math
import re
import subprocess
import unicodedata
from pathlib import Path
from urllib.parse import quote

import pandas as pd

SOURCE = Path(r"C:\Users\herre\Desktop\Creando Sistemas\Conacocard\CANACOCAR_EMPRESAS_CORDOBA.xlsx")
OUTPUT = Path(r"C:\xampp\htdocs\canaco-card\tmp\alta_afiliados_depurado_revision_v2.sql")
MYSQL = Path(r"C:\xampp\mysql\bin\mysql.exe")
SHEET = "depurado"
RFC = re.compile(r"^[A-Z0-9Ñ&]{12,13}$")

# Equivalencias revisadas contra el catálogo activo de categorias.
CATEGORY_BY_SLUG = {
    "ari-administracion-de-riesgo-integrales": "Servicios Profesionales",
    "bados-joyeria": "Joyerías", "funwash-limpieza-profesional": "Autolavados",
    "ineved": "Consultoría y Capacitación", "x-pet-la-imagen-de-tu-mascota": "Imagenología Veterinaria",
    "originales-dali": "Uniformes", "media-planning-publicidad": "Servicios Audiovisuales",
    "veoptix-optica": "Ópticas", "villas-pico-de-orizaba": "Turismo y Hospedaje",
    "visame-consultores": "Turismo y Hospedaje", "tintoreria-pressto": "Servicios Profesionales",
    "optica-espana": "Ópticas", "purana-spa": "Spa y Cosmetología",
    "organizacion-turistica-integral": "Turismo y Hospedaje", "decroly-jardin-de-ninos": "Consultoría y Capacitación",
    "colegio-jean-piaget-y-viajes-gali": "Consultoría y Capacitación", "zac-leading-seguros-y-finanzas": "Servicios Profesionales",
    "ispirazione-inspirando-tu-aroma": "Perfumerías", "restaurant-las-fuentes": "Restaurantes",
    "carpintodo": "Ferreterías", "los-patos-vinos-y-licores": "Vinos y Licores",
    "comervic": "Servicios Audiovisuales", "la-casona": "Restaurantes",
    "universidad-de-oriente": "Consultoría y Capacitación", "esefi-y-asociados": "Servicios Profesionales",
    "taco-t": "Taquerías", "rever-impermeabilizantes-y-recubrimientos-veracruz": "Pinturas e Impermeabilizantes",
    "super-tortas-orizabenas": "Torterías", "viajes-madi": "Turismo y Hospedaje",
    "papeleria-toby": "Papelerías", "lavado-garpe-orizaba": "Autolavados",
    "perfumeria-casa-azul": "Perfumerías", "turismo-aventura": "Turismo y Hospedaje",
    "victoria-service": "Alimentos y Bebidas", "salon-de-fiestas-confettis": "Eventos",
    "dulces-impresiones": "Panaderías y Pastelerías", "minoni": "Pizzerías",
    "corazon-de-amaranto": "Restaurantes", "autentik-salon": "Estéticas y Salas de Belleza",
    "medicalpet": "Clínicas Veterinarias", "la-prosperidad": "Restaurantes",
    "productos-de-limpieza-fersal": "Comercio", "libreria-el-puente": "Librerías",
    "angels-cafe-oceans-drinks": "Cafeterías", "romero-menta": "Restaurantes",
    "casa-marven": "Muebles y Colchones", "el-enchiladito": "Rosticerías",
    "gastronomica-marron-s-de-r-l-de-c-v": "Restaurantes", "sei-mg": "Servicios Profesionales",
    "c-ecatto-publicidad": "Servicios Audiovisuales", "comercilalizadora-la-victoria": "Comercio",
    "enamorate": "Bisutería", "madison-grill": "Restaurantes", "esfera": "Papelerías",
    "clinica-puerta-grande": "Hospitales", "siete-veinticuatro-7-24": "Comercio",
    "benjaminos-pizzas": "Pizzerías", "alvemex": "Pinturas e Impermeabilizantes",
    "pinturas-alvemex-cero": "Pinturas e Impermeabilizantes", "wappler-joyeria": "Joyerías",
    "sherwin-williams": "Pinturas e Impermeabilizantes", "oh-my-bows": "Accesorios Textiles",
    "mundo-joven-travel-shop": "Turismo y Hospedaje", "iq-english-orizaba": "Cursos de Inglés",
    "vinos-y-licores-el-gavilan": "Vinos y Licores", "veterinaria-dr-huerta": "Clínicas Veterinarias",
    "fulminex-control-de-plagas": "Servicios Profesionales", "clinica-de-maternidad-pluviosilla": "Clínicas de Maternidad",
    "domu-sushi-bar": "Restaurantes", "la-parroquia-de-veracruz": "Restaurantes",
    "papa-johns": "Pizzerías", "anytime-fitness": "Salud",
    "don-colchon-y-dona-cama-s-a-de-c-v": "Muebles y Colchones", "cia-mueblera-de-orizaba-s-a": "Muebles y Colchones",
}

MISSING_DESCRIPTIONS = {
    "organizacion-turistica-integral": "Agencia dedicada a organizar viajes y renta de transporte turístico.",
    "minoni": "Restaurante de comida italiana con pizzas, alitas y servicio a domicilio.",
    "corazon-de-amaranto": "Restaurante de alimentos y bebidas con promociones para afiliados.",
    "medicalpet": "Clínica veterinaria con atención, estética y accesorios para mascotas.",
    "siete-veinticuatro-7-24": "Tienda de conveniencia con productos de consumo diario.",
}

CATEGORY_KEYWORDS = {
    "Servicios Profesionales": ["servicios profesionales", "asesoría", "empresas"],
    "Joyerías": ["joyería", "joyas", "relojería"], "Autolavados": ["autolavado", "limpieza", "vehículos"],
    "Consultoría y Capacitación": ["capacitación", "consultoría", "educación"],
    "Imagenología Veterinaria": ["veterinaria", "imagenología", "mascotas"],
    "Clínicas Veterinarias": ["veterinaria", "mascotas", "salud animal"],
    "Uniformes": ["uniformes", "ropa escolar", "deportivo"], "Servicios Audiovisuales": ["publicidad", "audiovisual", "diseño"],
    "Ópticas": ["óptica", "lentes", "salud visual"], "Turismo y Hospedaje": ["turismo", "viajes", "hospedaje"],
    "Spa y Cosmetología": ["spa", "belleza", "cosmetología"], "Perfumerías": ["perfumería", "aromas", "belleza"],
    "Restaurantes": ["restaurante", "alimentos", "bebidas"], "Ferreterías": ["ferretería", "herramientas", "construcción"],
    "Vinos y Licores": ["vinos", "licores", "bebidas"], "Taquerías": ["taquería", "tacos", "comida"],
    "Pinturas e Impermeabilizantes": ["pinturas", "impermeabilizantes", "recubrimientos"],
    "Torterías": ["tortería", "tortas", "comida"], "Papelerías": ["papelería", "útiles", "regalos"],
    "Alimentos y Bebidas": ["alimentos", "bebidas", "comercio"], "Eventos": ["eventos", "fiestas", "celebraciones"],
    "Panaderías y Pastelerías": ["pastelería", "dulces", "repostería"], "Pizzerías": ["pizzería", "pizza", "comida"],
    "Estéticas y Salas de Belleza": ["estética", "belleza", "salón"], "Comercio": ["comercio", "productos", "tienda"],
    "Librerías": ["librería", "libros", "lectura"], "Cafeterías": ["cafetería", "café", "bebidas"],
    "Muebles y Colchones": ["muebles", "colchones", "hogar"], "Rosticerías": ["rosticería", "comida", "para llevar"],
    "Bisutería": ["bisutería", "accesorios", "moda"], "Hospitales": ["hospital", "salud", "atención médica"],
    "Cursos de Inglés": ["inglés", "cursos", "educación"], "Clínicas de Maternidad": ["maternidad", "clínica", "salud"],
    "Accesorios Textiles": ["accesorios textiles", "moños", "moda"], "Salud": ["salud", "bienestar", "gimnasio"],
}

TITLES = re.compile(r"^(?:(?:LIC(?:ENCIADO|ENCIADA)?|ING(?:ENIERO|ENIERA)?|MTRA|MTRO|DR|DRA|ARQ|C\.P\.|LAET)\.?\s+)+", re.I)
STOP_WORDS = {"de", "del", "la", "las", "el", "los", "y", "s", "a", "en", "para", "con", "por", "or", "sa", "cv"}


def clean(value: object) -> str:
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return ""
    return re.sub(r"\s+", " ", str(value)).strip()


def sql(value: str | None) -> str:
    return "NULL" if value is None else "'" + value.replace("'", "''") + "'"


def slugify(value: str) -> str:
    value = re.sub(r"['’`´]", "", value)
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    return (re.sub(r"[^a-zA-Z0-9]+", "-", value.lower()).strip("-") or "afiliado")[:180]


def first_phone(value: object) -> str:
    groups = re.findall(r"(?:\d[\s().-]*){7,16}", clean(value))
    if not groups:
        return ""
    return re.sub(r"\D", "", groups[0])[:16]


def street(value: object) -> str:
    address = clean(value)
    if not address or address.upper() in {"NO INFO", "NO INFORMACION", "N/A"}:
        return "NO INFO"
    # Solo la primera ubicación y solo el tramo previo al número, colonia o referencias.
    address = re.split(r"(?:\n|\*|\bCOL(?:ONIA)?\.?\b|\bC\.?P\.?\b|\bENTRE\b|\bESQUINA\b|\bLOCAL\b|#|\bNO\.?\s*\d)", address, flags=re.I)[0]
    address = re.sub(r"\s*(?:,|\.|-)\s*$", "", address).strip()
    return (address or "NO INFO")[:160]


def description(slug: str, source: object) -> str:
    if slug in MISSING_DESCRIPTIONS:
        return MISSING_DESCRIPTIONS[slug]
    text = clean(source).rstrip(".;,")
    fixes = {
        "capacitacion": "capacitación", "asesoria": "asesoría", "consultoria": "consultoría",
        "restaurat": "restaurante", "be biadas": "bebidas", "bebiadas": "bebidas", "cometologicos": "cosmetológicos",
        "tintoreria": "tintorería", "optica": "óptica", "clinica": "clínica", "joyeria": "joyería",
    }
    for old, new in fixes.items():
        text = re.sub(rf"\b{old}\b", new, text, flags=re.I)
    text = text[:190].rsplit(" ", 1)[0] if len(text) > 200 else text
    return f"Empresa especializada en {text[:1].lower() + text[1:]}."


def social_url(value: object, network: str) -> str | None:
    raw = clean(value)
    if not raw:
        return None
    raw = raw.replace("facebook,com", "facebook.com").replace("instagram,com", "instagram.com").replace("intagram.com", "instagram.com")
    links = re.findall(r"(?:https?://|www\.)[^\s]+", raw, flags=re.I)
    if links:
        url = links[0].rstrip(".,;)")
        return url if url.startswith("http") else "https://" + url
    handle = raw.lstrip("@").strip().rstrip("/")
    return f"https://www.{network}.com/{quote(handle, safe='._-')}/"


def website_url(value: object) -> str | None:
    raw = clean(value)
    if not raw:
        return None
    raw = raw.replace("http:/", "http://") if raw.startswith("http:/") and not raw.startswith("http://") else raw
    if " " in raw:
        return None
    url = raw if raw.startswith(("http://", "https://")) else "https://" + raw
    host = re.sub(r"^https?://", "", url, flags=re.I).split("/", 1)[0]
    return url if "." in host else None


def keywords(name: str, category: str) -> list[str]:
    result: list[str] = []
    seen: set[str] = set()
    def add(word: str) -> None:
        # MySQL usa utf8mb4_unicode_ci: no distingue mayúsculas ni acentos.
        key = unicodedata.normalize("NFKD", word).encode("ascii", "ignore").decode("ascii").lower().strip()
        if key and key not in seen:
            seen.add(key)
            result.append(word)
    for word in CATEGORY_KEYWORDS[category]:
        add(word)
    for token in re.findall(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ0-9]{3,}", name.lower()):
        if token not in STOP_WORDS:
            add(token)
    return result[:10]


def existing_rfcs() -> set[str]:
    raw = subprocess.check_output([str(MYSQL), "-uroot", "--batch", "--skip-column-names", "-e", "USE canaco_card; SELECT rfc FROM afiliados;"], text=True, encoding="utf-8")
    return {line.strip().upper() for line in raw.splitlines() if line.strip()}


data = pd.read_excel(SOURCE, SHEET)
data = data[data.iloc[:, 0].notna()].copy()
columns = list(data.columns)
company_col, email_col, desc_col, rfc_col, phone_col, contact_col = columns[0], columns[1], columns[3], columns[5], columns[6], columns[7]
address_col, whatsapp_col, facebook_col, instagram_col, website_col = columns[11], columns[12], columns[13], columns[14], columns[15]

reserved_rfcs = existing_rfcs()
reserved_slugs = {"negocio-1", "mi-negocio", "abarrotes-n", "zapateria-xa", "grupo-sorom-asesores", "by-cafetia", "cevpro", "climers-lab"}
rows: list[dict[str, object]] = []
provisionals: list[tuple[str, str, str]] = []

for _, record in data.iterrows():
    company = clean(record[company_col]).upper()
    base_slug = slugify(company)
    slug = base_slug
    suffix = 2
    while slug in reserved_slugs:
        ending = f"-{suffix}"
        slug = base_slug[:180 - len(ending)] + ending
        suffix += 1
    reserved_slugs.add(slug)

    raw_rfc = clean(record[rfc_col]).upper().replace(" ", "")
    replacement_reason = ""
    if not RFC.fullmatch(raw_rfc):
        replacement_reason = "RFC ausente o con formato inválido"
    elif raw_rfc in reserved_rfcs:
        replacement_reason = "RFC duplicado en el Excel o ya registrado en la base"
    if replacement_reason:
        serial = 1001
        while True:
            candidate = f"PENDIENTE{serial:04d}"
            if candidate not in reserved_rfcs:
                raw_rfc = candidate
                break
            serial += 1
        provisionals.append((company, raw_rfc, replacement_reason))
    reserved_rfcs.add(raw_rfc)

    category = CATEGORY_BY_SLUG.get(base_slug)
    if category is None:
        raise RuntimeError(f"Falta categoría para {company} ({base_slug})")
    contact = TITLES.sub("", clean(record[contact_col])) or "NO INFO"
    phone = first_phone(record[phone_col])
    if not phone:
        phone = f"000000{len(rows) + 1:04d}"
    whatsapp = first_phone(record[whatsapp_col]) or None
    rows.append({
        "company": company, "slug": slug, "rfc": raw_rfc, "category": category,
        "description": description(base_slug, record[desc_col]), "contact": contact,
        "phone": phone, "whatsapp": whatsapp, "street": street(record[address_col]),
        "facebook": social_url(record[facebook_col], "facebook"),
        "instagram": social_url(record[instagram_col], "instagram"),
        "website": website_url(record[website_col]),
    })

lines = [
    "-- Alta masiva generada para REVISIÓN desde la hoja depurado; no ejecutada.",
    "-- Cámara: CANACO Orizaba. Localidad matriz: Orizaba.",
    "-- Los correos del Excel contienen el valor de ejemplo repetido; se insertan como NULL.",
    "-- No se crean promociones, archivos, galerías ni logo. El logo se podrá cargar al editar manualmente.",
    f"-- RFC provisionales asignados: {len(provisionals)}. Sustituirlos por RFC fiscales posteriormente.",
    "",
    "START TRANSACTION;",
    "SET @camara_id = (SELECT idCamara FROM camaras WHERE clave = 'CANACO-ORIZABA' AND activo = 1 LIMIT 1);",
    "SET @localidad_id = (SELECT idLocalidad FROM localidades WHERE nombre = 'Orizaba' AND activo = 1 LIMIT 1);",
    "",
]

for index, row in enumerate(rows, start=1):
    lines += [
        f"-- {index:02d}. {row['company']} | Categoría: {row['category']}",
        f"INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, {sql(row['rfc'])}, {sql(row['company'])}, {sql(row['slug'])}, {sql(row['description'])}, NULL);",
        "SET @afiliado_id = LAST_INSERT_ID();",
        f"INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, {sql(row['contact'])}, NULL, NULL, {sql(row['phone'])}, 1, 0);",
        f"INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, {sql(row['street'])}, 1);",
        "SET @sucursal_id = LAST_INSERT_ID();",
        f"INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', {sql(row['phone'])}, {sql(row['phone'])}, 1);",
    ]
    if row["whatsapp"]:
        lines.append(f"INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', {sql(row['whatsapp'])}, {sql(row['whatsapp'])}, 1);")
    lines.append(f"INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = {sql(row['category'])} AND activo = 1;")
    for word in keywords(str(row["company"]), str(row["category"])):
        lines.append(f"INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, {sql(word)}, {sql(word.lower())});")
    for kind, url in (("FACEBOOK", row["facebook"]), ("INSTAGRAM", row["instagram"]), ("SITIO_WEB", row["website"])):
        if url:
            lines.append(f"INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, '{kind}', {sql(str(url))}, 1);")
    lines.append("")

lines += ["-- Revisa antes de confirmar los cambios.", "-- COMMIT;", "-- Para descartar: ROLLBACK;"]
OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")

print(f"Empresas preparadas: {len(rows)}")
print(f"RFC provisionales: {len(provisionals)}")
for company, rfc, reason in provisionals:
    print(f"- {company}: {rfc} ({reason})")
print(f"Archivo: {OUTPUT}")
