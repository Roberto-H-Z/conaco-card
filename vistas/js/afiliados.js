document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('modalAfiliado');
    const form = document.getElementById('formAfiliado');
    const modalEstado = document.getElementById('modalEstado');
    const formEstado = document.getElementById('formEstado');
    const modalInformacion = document.getElementById('modalInformacion');
    const toast = document.getElementById('notificacion');
    const botonAnterior = document.getElementById('btnAnteriorAfiliado');
    const botonPrincipal = document.getElementById('btnGuardarAfiliado');
    const pasos = [...form.querySelectorAll('.canaco-form-nav [data-section]')];
    const crearUsuarioAcceso = document.getElementById('crear_usuario_acceso');
    const camposUsuarioAcceso = document.getElementById('camposUsuarioAcceso');
    let cambioEstado = null;
    const abrir = e => window.canacoMotion.open(e);
    const cerrar = e => window.canacoMotion.close(e);
    const aviso = (m, t = 'success') => { toast.textContent = m; toast.className = 'canaco-toast is-' + t; toast.hidden = false; requestAnimationFrame(() => toast.classList.add('is-visible')); setTimeout(() => { toast.classList.remove('is-visible'); setTimeout(() => toast.hidden = true, 180); }, 4000); };
    pasos.forEach((paso, indice) => { const titulo = paso.textContent.replace(/^\d+\.\s*/, '').trim(); paso.textContent = ''; const numero = document.createElement('span'); numero.className = 'canaco-step-number'; numero.textContent = String(indice + 1); const etiqueta = document.createElement('span'); etiqueta.className = 'canaco-step-title'; etiqueta.textContent = titulo; paso.append(numero, etiqueta); });
    const indicePaso = seccion => pasos.findIndex(x => x.dataset.section === seccion);
    const seccionActiva = () => pasos.find(x => x.classList.contains('is-active'))?.dataset.section || 'general';
    const actualizarAcciones = seccion => { const indice = indicePaso(seccion); const final = indice === pasos.length - 1; botonAnterior.hidden = indice === 0; botonPrincipal.querySelector('[data-button-label]').textContent = final ? (form.elements.idAfiliado.value ? 'Guardar cambios' : 'Guardar afiliado') : 'Siguiente'; botonPrincipal.querySelector('[data-next-icon]').hidden = final; };
    const activar = seccion => { const indice = indicePaso(seccion); form.querySelectorAll('[data-section-panel]').forEach(x => x.classList.toggle('hidden', x.dataset.sectionPanel !== seccion)); pasos.forEach((x, i) => { x.classList.toggle('is-active', i === indice); x.classList.toggle('is-complete', i < indice); x.setAttribute('aria-current', i === indice ? 'step' : 'false'); }); actualizarAcciones(seccion); if (modal.classList.contains('is-open')) window.canacoMotion.content(form.querySelector('[data-section-panel="' + seccion + '"]')); };
    const limpiarErrores = () => { form.querySelectorAll('[data-error]').forEach(x => x.textContent = ''); form.querySelectorAll('[aria-invalid="true"]').forEach(x => x.removeAttribute('aria-invalid')); };
    const actualizarUsuarioAcceso = () => {
        const esNuevo = !form.elements.idAfiliado.value;
        crearUsuarioAcceso.disabled = !esNuevo;
        if (!esNuevo) crearUsuarioAcceso.checked = false;
        const activo = esNuevo && crearUsuarioAcceso.checked;
        camposUsuarioAcceso.hidden = !activo;
        ['usuario_nombre', 'usuario_password', 'usuario_password_confirmacion'].forEach(campo => {
            form.elements[campo].disabled = !activo;
            form.elements[campo].required = activo;
        });
    };
    actualizarUsuarioAcceso();
    const errores = datos => { Object.entries(datos || {}).forEach(([campo, mensaje]) => { const x = form.elements.namedItem(campo) || form.querySelector('[name="' + campo + '[]"]'); const y = form.querySelector('[data-error="' + campo + '"]'); if (x) x.setAttribute('aria-invalid', 'true'); if (y) y.textContent = mensaje; }); const primero = form.querySelector('[aria-invalid="true"]'); if (primero) { activar(primero.closest('[data-section-panel]')?.dataset.sectionPanel || 'general'); if (primero.type === 'hidden' && primero.name === 'google_place_id') placeAutocomplete?.focus(); else primero.focus(); } };
    const validarPaso = seccion => { const requeridos = { general: { idCamara: 'Selecciona una cámara.', rfc: 'Captura el RFC.', nombre_comercial: 'Captura el nombre comercial.', correo_general: 'Captura un correo válido.', descripcion: 'Captura la descripción.' }, contacto: { encargado: 'Captura el nombre del encargado.', telefono: 'Captura el teléfono.', idEstado: 'Selecciona un estado.', idMunicipio: 'Selecciona un municipio.', idLocalidad: 'Selecciona una ciudad o localidad.', google_place_id: 'Selecciona un domicilio de las sugerencias de Google Maps.' }, digital: {} }; const datos = {}; Object.entries(requeridos[seccion] || {}).forEach(([campo, mensaje]) => { const entrada = form.elements[campo]; if (!entrada?.value?.trim() || !entrada.checkValidity()) datos[campo] = mensaje; }); if (seccion === 'general' && crearUsuarioAcceso.checked) { if (!form.elements.usuario_nombre.value.trim()) datos.usuario_nombre = 'Captura el nombre de la persona que tendrá acceso.'; if (!form.elements.usuario_password.checkValidity()) datos.usuario_password = 'Usa mínimo 10 caracteres, incluyendo letras y números.'; if (form.elements.usuario_password.value !== form.elements.usuario_password_confirmacion.value) datos.usuario_password_confirmacion = 'Las contraseñas no coinciden.'; } if (seccion === 'digital') ['facebook', 'instagram', 'tiktok', 'sitio_web'].forEach(campo => { const entrada = form.elements[campo]; if (entrada.value && !entrada.checkValidity()) datos[campo] = 'Captura una URL válida, incluyendo https://.'; }); if (Object.keys(datos).length) { errores(datos); return false; } return true; };
    pasos.forEach(x => x.addEventListener('click', () => { const actual = indicePaso(seccionActiva()); const destino = indicePaso(x.dataset.section); if (destino <= actual) activar(x.dataset.section); }));
    botonAnterior.addEventListener('click', () => { const indice = indicePaso(seccionActiva()); if (indice > 0) activar(pasos[indice - 1].dataset.section); });
    const cargar = async (select, ruta, parametros, valor) => {
        select.disabled = true; select.innerHTML = '<option value="">Cargando…</option>';
        const r = await canacoAjax(ruta, parametros, 'GET');
        const clave = select.id === 'idMunicipio' ? 'idMunicipio' : 'idLocalidad';
        const etiqueta = select.id === 'idMunicipio' ? 'municipio' : 'ciudad / localidad';
        select.innerHTML = '<option value="">Selecciona un ' + etiqueta + '</option>' + r.data.map(x => '<option value="' + x[clave] + '">' + escapar(x.nombre) + '</option>').join('');
        select.disabled = r.data.length === 0; if (valor) select.value = String(valor);
    };
    const resetUbicacion = () => { form.elements.idMunicipio.innerHTML = '<option value="">Primero selecciona un estado</option>'; form.elements.idMunicipio.disabled = true; form.elements.idLocalidad.innerHTML = '<option value="">Primero selecciona un municipio</option>'; form.elements.idLocalidad.disabled = true; };
    form.elements.idEstado.addEventListener('change', async () => { resetUbicacion(); if (!form.elements.idEstado.value) return; try { await cargar(form.elements.idMunicipio, 'afiliados/municipios', { estado: form.elements.idEstado.value }); } catch (e) { aviso('No fue posible cargar los municipios.', 'error'); } });
    form.elements.idMunicipio.addEventListener('change', async () => { form.elements.idLocalidad.innerHTML = '<option value="">Primero selecciona un municipio</option>'; form.elements.idLocalidad.disabled = true; if (!form.elements.idMunicipio.value) return; try { await cargar(form.elements.idLocalidad, 'afiliados/localidades', { municipio: form.elements.idMunicipio.value }); } catch (e) { aviso('No fue posible cargar las localidades.', 'error'); } });
    const direccionInput = document.getElementById('direccion_busqueda');
    const direccionEstado = document.getElementById('googleMapsEstado');
    const placeAutocomplete = document.getElementById('direccionGoogle');
    const listaSugerencias = document.getElementById('googlePlacesSuggestions');
    const limpiarDatosGoogle = () => {
        ['numero_exterior','numero_interior','colonia','codigo_postal','google_place_id','latitud','longitud'].forEach(campo => { form.elements[campo].value = ''; });
    };
    const normalizarTexto = valor => (valor || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim();
    const buscarOpcion = (select, texto) => [...select.options].find(opcion => {
        const a = normalizarTexto(opcion.textContent); const b = normalizarTexto(texto);
        return b && (a === b || a.includes(b) || b.includes(a));
    });
    const componente = (lista, tipo) => lista.find(item => (item.types || []).includes(tipo))?.longText || '';
    const aplicarLugar = async place => {
        await place.fetchFields({ fields: ['id', 'formattedAddress', 'location', 'addressComponents'] });
        const componentes = place.addressComponents || [];
        const ruta = componente(componentes, 'route');
        const numero = componente(componentes, 'street_number');
        const colonia = componente(componentes, 'sublocality_level_1') || componente(componentes, 'neighborhood');
        const cp = componente(componentes, 'postal_code');
        const estado = componente(componentes, 'administrative_area_level_1');
        const municipio = componente(componentes, 'administrative_area_level_2');
        const localidad = componente(componentes, 'locality') || componente(componentes, 'sublocality');
        direccionInput.value = place.formattedAddress || [ruta, numero].filter(Boolean).join(' ');
        placeAutocomplete.value = direccionInput.value;
        form.elements.calle.value = ruta || direccionInput.value;
        form.elements.numero_exterior.value = numero;
        form.elements.colonia.value = colonia;
        form.elements.codigo_postal.value = cp.replace(/\D/g, '').slice(0, 5);
        form.elements.google_place_id.value = place.id || '';
        form.elements.latitud.value = place.location?.lat?.() ?? '';
        form.elements.longitud.value = place.location?.lng?.() ?? '';
        form.elements.google_place_id.removeAttribute('aria-invalid');
        const errorGoogle = form.querySelector('[data-error="google_place_id"]');
        if (errorGoogle) errorGoogle.textContent = '';

        const opcionEstado = buscarOpcion(form.elements.idEstado, estado);
        if (opcionEstado) {
            form.elements.idEstado.value = opcionEstado.value; resetUbicacion();
            await cargar(form.elements.idMunicipio, 'afiliados/municipios', { estado: opcionEstado.value });
            const opcionMunicipio = buscarOpcion(form.elements.idMunicipio, municipio || localidad);
            if (opcionMunicipio) {
                form.elements.idMunicipio.value = opcionMunicipio.value;
                await cargar(form.elements.idLocalidad, 'afiliados/localidades', { municipio: opcionMunicipio.value });
                const opcionLocalidad = buscarOpcion(form.elements.idLocalidad, localidad || municipio);
                if (opcionLocalidad) form.elements.idLocalidad.value = opcionLocalidad.value;
            }
        }
        direccionEstado.textContent = form.elements.idLocalidad.value ? 'Domicilio localizado y datos geográficos completados.' : 'Domicilio localizado. Selecciona la ciudad o localidad correspondiente.';
    };
    const iniciarGooglePlaces = () => {
        const contenedor = document.querySelector('[data-google-maps-key]');
        const key = contenedor?.dataset.googleMapsKey || '';
        if (!key) { direccionEstado.textContent = 'Google Maps no está configurado. No es posible registrar domicilios.'; direccionEstado.classList.add('text-danger'); return; }
        window.canacoGoogleMapsReady = async () => {
            try {
                const { AutocompleteSessionToken, AutocompleteSuggestion } = await google.maps.importLibrary('places');
                let token = new AutocompleteSessionToken();
                let temporizador = 0;
                let solicitud = 0;
                let predicciones = [];
                let indiceActivo = -1;

                const ocultarSugerencias = () => {
                    listaSugerencias.hidden = true;
                    listaSugerencias.replaceChildren();
                    placeAutocomplete.setAttribute('aria-expanded', 'false');
                    placeAutocomplete.removeAttribute('aria-activedescendant');
                    predicciones = [];
                    indiceActivo = -1;
                };
                const marcarActiva = indice => {
                    const botones = [...listaSugerencias.querySelectorAll('button')];
                    if (!botones.length) return;
                    indiceActivo = (indice + botones.length) % botones.length;
                    botones.forEach((boton, i) => boton.classList.toggle('is-active', i === indiceActivo));
                    placeAutocomplete.setAttribute('aria-activedescendant', botones[indiceActivo].id);
                };
                const seleccionar = async prediccion => {
                    ocultarSugerencias();
                    direccionEstado.textContent = 'Consultando los datos del domicilio…';
                    try {
                        await aplicarLugar(prediccion.toPlace());
                        token = new AutocompleteSessionToken();
                    } catch (_) {
                        direccionEstado.textContent = 'No fue posible obtener los detalles. Intenta otra dirección.';
                        direccionEstado.classList.add('text-danger');
                    }
                };
                const renderizar = sugerencias => {
                    predicciones = sugerencias.map(item => item.placePrediction).filter(Boolean);
                    listaSugerencias.replaceChildren();
                    predicciones.forEach((prediccion, indice) => {
                        const item = document.createElement('li');
                        item.setAttribute('role', 'option');
                        const boton = document.createElement('button');
                        boton.type = 'button';
                        boton.id = 'googlePlaceOption' + indice;
                        boton.textContent = prediccion.text.toString();
                        boton.addEventListener('mousedown', evento => evento.preventDefault());
                        boton.addEventListener('click', () => seleccionar(prediccion));
                        item.append(boton);
                        listaSugerencias.append(item);
                    });
                    listaSugerencias.hidden = predicciones.length === 0;
                    placeAutocomplete.setAttribute('aria-expanded', String(predicciones.length > 0));
                    direccionEstado.textContent = predicciones.length ? 'Selecciona una de las direcciones encontradas.' : 'Google no encontró coincidencias. Escribe calle, número, ciudad y estado.';
                };
                const buscar = async () => {
                    const texto = placeAutocomplete.value.trim();
                    const idSolicitud = ++solicitud;
                    if (texto.length < 3) { ocultarSugerencias(); return; }
                    direccionEstado.textContent = 'Buscando direcciones…';
                    try {
                        const { suggestions } = await AutocompleteSuggestion.fetchAutocompleteSuggestions({ input: texto, includedRegionCodes: ['mx'], language: 'es-MX', region: 'mx', sessionToken: token });
                        if (idSolicitud === solicitud) renderizar(suggestions);
                    } catch (_) {
                        if (idSolicitud === solicitud) {
                            ocultarSugerencias();
                            direccionEstado.textContent = 'Google Maps no pudo consultar direcciones. Intenta nuevamente.';
                            direccionEstado.classList.add('text-danger');
                        }
                    }
                };
                placeAutocomplete.addEventListener('input', () => {
                    direccionInput.value = placeAutocomplete.value.trim();
                    limpiarDatosGoogle();
                    direccionEstado.classList.remove('text-danger');
                    direccionEstado.textContent = 'Espera las sugerencias y selecciona una dirección.';
                    clearTimeout(temporizador);
                    temporizador = setTimeout(buscar, 280);
                });
                placeAutocomplete.addEventListener('keydown', evento => {
                    if (evento.key === 'ArrowDown' && predicciones.length) { evento.preventDefault(); marcarActiva(indiceActivo + 1); }
                    else if (evento.key === 'ArrowUp' && predicciones.length) { evento.preventDefault(); marcarActiva(indiceActivo - 1); }
                    else if (evento.key === 'Enter' && indiceActivo >= 0) { evento.preventDefault(); seleccionar(predicciones[indiceActivo]); }
                    else if (evento.key === 'Escape') ocultarSugerencias();
                });
                placeAutocomplete.addEventListener('blur', () => setTimeout(ocultarSugerencias, 150));
                direccionEstado.textContent = 'Escribe y selecciona una dirección de las sugerencias de Google.';
            } catch (_) { direccionEstado.textContent = 'No fue posible iniciar Google Maps. Revisa la clave y sus restricciones.'; direccionEstado.classList.add('text-danger'); }
        };
        const script = document.createElement('script');
        script.src = 'https://maps.googleapis.com/maps/api/js?key=' + encodeURIComponent(key) + '&loading=async&libraries=places&language=es&region=MX&callback=canacoGoogleMapsReady';
        script.async = true; script.defer = true;
        script.onerror = () => { direccionEstado.textContent = 'No fue posible cargar Google Maps. Revisa la conexión y la configuración de la API.'; direccionEstado.classList.add('text-danger'); };
        document.head.append(script);
    };
    iniciarGooglePlaces();
    const nuevo = () => { form.reset(); actualizarUsuarioAcceso(); limpiarErrores(); resetUbicacion(); direccionInput.value = ''; placeAutocomplete.value = ''; listaSugerencias.hidden = true; listaSugerencias.replaceChildren(); activar('general'); document.getElementById('archivosActuales').innerHTML = ''; document.getElementById('modalTitulo').textContent = 'Registrar afiliado'; abrir(modal); };
    crearUsuarioAcceso.addEventListener('change', actualizarUsuarioAcceso);
    document.querySelectorAll('#btnNuevoAfiliado').forEach(boton => boton.addEventListener('click', nuevo));
    modal.querySelectorAll('[data-modal-close]').forEach(x => x.addEventListener('click', () => cerrar(modal)));
    const canal = (lista, tipo) => lista.find(x => x.tipo === tipo)?.url || '';
    const telefono = (lista, tipo) => lista.find(x => x.tipo === tipo)?.numero_original || '';
    const llenar = async d => {
        form.reset(); limpiarErrores(); resetUbicacion(); activar('general');
        ['idAfiliado','idCamara','rfc','nombre_comercial','razon_social','descripcion','correo_general'].forEach(c => { if (form.elements[c]) form.elements[c].value = d[c] ?? ''; }); actualizarUsuarioAcceso();
        const c = d.contacto || {}; form.elements.encargado.value = c.nombre || ''; form.elements.cargo_encargado.value = c.cargo || ''; form.elements.telefono.value = telefono(d.telefonos || [], 'TELEFONO'); form.elements.whatsapp.value = telefono(d.telefonos || [], 'WHATSAPP');
        form.elements.facebook.value = canal(d.canales || [], 'FACEBOOK'); form.elements.instagram.value = canal(d.canales || [], 'INSTAGRAM'); form.elements.tiktok.value = canal(d.canales || [], 'TIKTOK'); form.elements.sitio_web.value = canal(d.canales || [], 'SITIO_WEB');
        const m = d.matriz || {}; ['calle','numero_exterior','numero_interior','colonia','codigo_postal','referencias','latitud','longitud','google_place_id'].forEach(campo => { if (form.elements[campo]) form.elements[campo].value = m[campo] ?? ''; });
        direccionInput.value = [m.calle, m.numero_exterior, m.numero_interior, m.colonia, m.codigo_postal, m.localidad_nombre, m.municipio_nombre, m.estado_nombre].filter(Boolean).join(', '); placeAutocomplete.value = direccionInput.value;
        if (m.idEstado) { form.elements.idEstado.value = m.idEstado; await cargar(form.elements.idMunicipio, 'afiliados/municipios', { estado: m.idEstado }, m.idMunicipio); await cargar(form.elements.idLocalidad, 'afiliados/localidades', { municipio: m.idMunicipio }, m.idLocalidad); }
        const cats = new Set((d.categorias || []).map(x => String(x.idCategoria))); form.querySelectorAll('[name="categorias[]"]').forEach(x => x.checked = cats.has(x.value)); form.elements.palabras_clave.value = (d.palabras_clave || []).map(x => x.palabra).join(', ');
        const archivos = d.archivos || []; document.getElementById('archivosActuales').innerHTML = archivos.length ? '<strong>Archivos actuales</strong><ul>' + archivos.map(x => '<li>' + (x.tipo === 'LOGOTIPO' ? 'Logotipo' : 'Galería') + ': ' + escapar(x.nombre_original) + '</li>').join('') + '</ul>' : '<span class="text-muted-foreground">No hay imágenes registradas.</span>';
    };
    document.querySelectorAll('.btn-editar').forEach(b => b.addEventListener('click', async () => { b.disabled = true; try { const r = await canacoAjax('afiliados/obtener', { id: b.dataset.id }, 'GET'); await llenar(r.data); document.getElementById('modalTitulo').textContent = 'Editar afiliado'; actualizarAcciones('general'); abrir(modal); } catch (e) { aviso(e.message, 'error'); } finally { b.disabled = false; } }));
    document.querySelectorAll('[data-info-toggle]').forEach(boton => boton.addEventListener('click', () => { const panel = document.getElementById(boton.getAttribute('aria-controls')); const abierto = boton.getAttribute('aria-expanded') === 'true'; boton.setAttribute('aria-expanded', String(!abierto)); panel.hidden = abierto; }));
    const dato = (etiqueta, valor) => '<div><dt>' + escapar(etiqueta) + '</dt><dd>' + escapar(valor || 'No registrado') + '</dd></div>';
    const renderInformacion = d => {
        const m = d.matriz || {}; const c = d.contacto || {};
        const tels = d.telefonos || []; const canales = d.canales || [];
        const direccion = [m.calle,m.numero_exterior,m.numero_interior,m.colonia,m.codigo_postal,m.localidad_nombre,m.municipio_nombre,m.estado_nombre].filter(Boolean).join(', ');
        const categorias = (d.categorias || []).map(x => x.nombre).filter(Boolean).join(', ');
        const palabras = (d.palabras_clave || []).map(x => x.palabra).filter(Boolean).join(', ');
        const archivos = d.archivos || [];
        return '<div class="canaco-quick-summary"><div class="canaco-quick-heading"><span class="canaco-avatar">' + escapar((d.nombre_comercial || '?').slice(0,1).toUpperCase()) + '</span><div><h4>' + escapar(d.nombre_comercial) + '</h4><p>' + escapar(d.razon_social || 'Sin razón social') + '</p></div></div><dl class="canaco-quick-grid">' + dato('RFC',d.rfc) + dato('Cámara',d.camara_nombre) + dato('Correo',d.correo_general) + dato('Encargado',c.nombre) + dato('Cargo',c.cargo) + dato('Teléfono',telefono(tels,'TELEFONO')) + dato('WhatsApp',telefono(tels,'WHATSAPP')) + dato('Domicilio',direccion) + dato('Referencias',m.referencias) + dato('Categorías',categorias) + dato('Palabras clave',palabras) + dato('Facebook',canal(canales,'FACEBOOK')) + dato('Instagram',canal(canales,'INSTAGRAM')) + dato('TikTok',canal(canales,'TIKTOK')) + dato('Sitio web',canal(canales,'SITIO_WEB')) + dato('Galería',archivos.filter(x=>x.tipo==='GALERIA').length + ' imagen(es)') + dato('Estado',Number(d.activo)===1?'Activo':'Inactivo') + '</dl><div class="canaco-quick-description"><strong>Descripción pública</strong><p>' + escapar(d.descripcion || 'No registrada') + '</p></div></div>';
    };
    document.querySelectorAll('.btn-ver').forEach(b => b.addEventListener('click', async () => { const contenido = document.getElementById('informacionContenido'); contenido.innerHTML = '<div class="canaco-quick-loading">Cargando información…</div>'; abrir(modalInformacion); b.disabled = true; try { const r = await canacoAjax('afiliados/obtener',{id:b.dataset.id},'GET'); contenido.innerHTML = renderInformacion(r.data); if (modalInformacion.classList.contains('is-open')) window.canacoMotion.content(contenido); } catch(e) { cerrar(modalInformacion); aviso(e.message,'error'); } finally { b.disabled=false; } }));
    modalInformacion.querySelectorAll('[data-info-close]').forEach(x => x.addEventListener('click', () => cerrar(modalInformacion)));
    document.querySelectorAll('.btn-enviar-acceso').forEach(b => b.addEventListener('click', async () => { if (!window.confirm('Se generará una contraseña temporal nueva para ' + b.dataset.nombre + ' y la contraseña anterior dejará de funcionar. ¿Deseas enviarla por correo?')) return; b.disabled=true; try { const r=await canacoAjax('afiliados/enviar-acceso',{idAfiliado:b.dataset.id},'POST'); aviso(r.message); } catch(e) { aviso(e.message,'error'); } finally { b.disabled=false; } }));
    form.addEventListener('submit', async e => { e.preventDefault(); limpiarErrores(); const actual = seccionActiva(); const indice = indicePaso(actual); if (indice < pasos.length - 1) { if (validarPaso(actual)) activar(pasos[indice + 1].dataset.section); return; } const b = botonPrincipal; const label = b.querySelector('[data-button-label]'); const original = label.textContent; b.disabled = true; label.textContent = 'Guardando…'; try { const r = await canacoAjax('afiliados/guardar', new FormData(form), 'POST'); sessionStorage.setItem('canaco_mensaje', r.message); window.location.assign(document.body.dataset.baseUrl + 'afiliados'); } catch (e) { errores(e.errors); aviso(e.message, 'error'); } finally { b.disabled = false; label.textContent = original; } });
    document.querySelectorAll('.btn-estado').forEach(b => b.addEventListener('click', () => { cambioEstado = { idAfiliado: b.dataset.id, activo: b.dataset.activo === '1' }; const a = cambioEstado.activo ? 'activar' : 'desactivar'; document.getElementById('estadoTitulo').textContent = a[0].toUpperCase() + a.slice(1) + ' afiliado'; document.getElementById('estadoDescripcion').textContent = 'Vas a ' + a + ' a ' + b.dataset.nombre + '.'; document.getElementById('grupoMotivo').hidden = cambioEstado.activo; document.getElementById('motivoEstado').value = ''; document.getElementById('btnConfirmarEstado').textContent = cambioEstado.activo ? 'Activar' : 'Desactivar'; abrir(modalEstado); }));
    modalEstado.querySelectorAll('[data-status-close]').forEach(x => x.addEventListener('click', () => cerrar(modalEstado)));
    formEstado.addEventListener('submit', async e => { e.preventDefault(); if (!cambioEstado) return; const b = document.getElementById('btnConfirmarEstado'); b.disabled = true; try { const r = await canacoAjax('afiliados/cambiar-estado', { ...cambioEstado, motivo: document.getElementById('motivoEstado').value }, 'POST'); sessionStorage.setItem('canaco_mensaje', r.message); window.location.reload(); } catch (e) { aviso(e.message, 'error'); b.disabled = false; } });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') { if (!modalInformacion.hidden) cerrar(modalInformacion); else if (!modalEstado.hidden) cerrar(modalEstado); else if (!modal.hidden) cerrar(modal); } });
    const pendiente = sessionStorage.getItem('canaco_mensaje'); if (pendiente) { sessionStorage.removeItem('canaco_mensaje'); aviso(pendiente); }
});
function escapar(v) { const x = document.createElement('div'); x.textContent = v || ''; return x.innerHTML; }
