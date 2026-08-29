from __future__ import annotations

import math
import re
import unicodedata
from pathlib import Path

import pandas as pd

SOURCE = Path(r"C:\Users\herre\Desktop\Creando Sistemas\Conacocard\CANACOCAR_EMPRESAS_CORDOBA.xlsx")
OUTPUT = Path(r"C:\xampp\htdocs\canaco-card\tmp\alta_afiliados_ori_revision.sql")
RFC_PATTERN = re.compile(r"^[A-Z0-9Ñ&]{12,13}$")
CAMARA_ID = 1  # CANACO Córdoba, única cámara activa en la BD actual.
TARGET_SHEET = "ORI"


def text(value: object) -> str:
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return ""
    return re.sub(r"\s+", " ", str(value)).strip()


def sql(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def slugify(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^a-zA-Z0-9]+", "-", value.lower()).strip("-")
    return (value or "afiliado")[:180]


def descripcion(giro: str) -> str:
    giro = giro.rstrip(".;,")
    if not giro:
        return "Empresa afiliada al directorio comercial CANACO."
    return f"Empresa afiliada dedicada a {giro[:300]}."


rows: list[dict[str, str]] = []
provisionales: list[tuple[str, str, str, str]] = []
rfcs_fiscales_vistos: set[str] = set()

for sheet in [TARGET_SHEET]:
    dataframe = pd.read_excel(SOURCE, sheet_name=sheet)
    for _, raw in dataframe.iterrows():
        empresa = text(raw.get("EMPRESA"))
        if not empresa:
            continue
        rfc = text(raw.get("RFC ")).upper().replace(" ", "")
        referencia = f"{sheet} fila {text(raw.get('No.'))}"
        provisional = not RFC_PATTERN.fullmatch(rfc)
        motivo_provisional = ""
        rfc_origen = rfc or "sin RFC"
        if provisional:
            motivo_provisional = "RFC ausente o con formato inválido"
        elif rfc in rfcs_fiscales_vistos:
            provisional = True
            motivo_provisional = "RFC repetido en otra empresa del mismo Excel"
        else:
            rfcs_fiscales_vistos.add(rfc)
        if provisional:
            provisionales.append((referencia, empresa, rfc_origen, motivo_provisional))
            rfc = f"PENDIENTE{len(provisionales):04d}"
        giro = text(raw.get("GIRO")) or text(raw.get("GIRO "))
        complemento_giro = text(raw.get("Unnamed: 13"))
        if complemento_giro and complemento_giro.lower() not in giro.lower():
            giro = f"{giro}; {complemento_giro}" if giro else complemento_giro
        rows.append({"referencia": referencia, "empresa": empresa, "rfc": rfc, "giro": giro, "provisional": provisional, "motivo_provisional": motivo_provisional})

unique_rows = rows

# Estos slugs ya existen en la BD activa; se reservan para que el SQL sea revisable
# y no choque por nombre comercial aunque el RFC sea nuevo.
reserved_slugs = {
    "negocio-1", "mi-negocio", "abarrotes-n", "zapateria-xa",
    "grupo-sorom-asesores", "by-cafetia", "cevpro", "climers-lab",
}
assigned_slugs = set(reserved_slugs)
for row in unique_rows:
    base = slugify(row["empresa"])
    candidate = base
    suffix = 2
    while candidate in assigned_slugs:
        tail = f"-{suffix}"
        candidate = base[: 180 - len(tail)] + tail
        suffix += 1
    assigned_slugs.add(candidate)
    row["slug"] = candidate

lines = [
    "-- Alta de afiliados generada para REVISIÓN; no ejecutada.",
    f"-- Fuente: {SOURCE.name}",
    f"-- Hoja procesada: {TARGET_SHEET} (Orizaba).",
    f"-- Cámara asignada: idCamara = {CAMARA_ID} (CANACO Córdoba).",
    "-- Solo se insertan columnas obligatorias de afiliados: idCamara, RFC, nombre comercial, slug y descripción.",
    "-- No se insertan promociones, fotos, logo, contactos, sucursales, teléfonos, canales digitales, categorías ni palabras clave.",
    "-- Los demás campos quedan en sus valores por defecto o NULL.",
    f"-- RFC provisionales asignados: {len(provisionales)}; incluyen RFC ausentes/inválidos y RFC repetidos entre empresas distintas.",
    "-- Cada sentencia evita volver a insertar un RFC que ya exista en la BD.",
    "",
    "START TRANSACTION;",
    "",
]

for row in unique_rows:
    lines.append(f"-- {row['referencia']} | Giro: {row['giro'] or 'no indicado'}")
    if row["provisional"]:
        lines.append(f"-- RFC PROVISIONAL: {row['rfc']} ({row['motivo_provisional']}); sustituir por el RFC fiscal antes de operación formal.")
    lines.append(
        "INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) "
        f"SELECT {CAMARA_ID}, {sql(row['rfc'])}, {sql(row['empresa'])}, {sql(row['slug'])}, {sql(descripcion(row['giro']))} "
        f"WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = {sql(row['rfc'])});"
    )

lines.extend(["", "-- Revisa el resultado antes de confirmar.", "-- COMMIT;", "-- Para descartar esta prueba: ROLLBACK;"])
OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")

print(f"Filas únicas preparadas: {len(unique_rows)}")
print(f"RFC provisionales asignados: {len(provisionales)}")
print(f"Salida: {OUTPUT}")
print("RFC de origen sustituidos por provisionales:")
for referencia, empresa, rfc, motivo in provisionales:
    print(f"- {referencia}: {empresa} [{rfc}; {motivo}]")
