# Deploy — Guita Familia

## Dónde vive esto realmente

La app en uso está en **Firebase Hosting**, proyecto `finanzas-familia-f2765`:

- URL: https://finanzas-familia-f2765.web.app
- Login: Google, solo `willy.esposito@gmail.com` y `ya.riveiro19@gmail.com` (ver `ALLOWED_EMAILS` en `index.html`)
- Datos: Firestore, colección `familia` (docs `estado`, `gastos`, `snapshots`), en tiempo real entre los dos teléfonos

`index.html` en la raíz de este repo es el **código fuente exacto de esa app** (single-file, sin build step). Este repo no está conectado a Firebase por ningún pipeline — no existe un deploy automático al pushear. Cada actualización se sube a mano.

Los archivos `gastos_willy.html` y `gastos_yani.html` son prototipos viejos, ya reemplazados por `index.html`. Quedan solo de referencia.

Este repo ya tiene `firebase.json` y `.firebaserc` configurados apuntando al proyecto `finanzas-familia-f2765`, con `"public": "public"` — Hosting solo sirve lo que esté en la carpeta `public/` (que no se versiona, se genera antes de cada deploy). **No usar `"public": "."`**: ver la nota de seguridad más abajo.

## Cómo deployar una actualización

Con este repo clonado (o ya estando en él, como acá):

```bash
mkdir -p public && cp index.html public/index.html
npx firebase-tools deploy --only hosting
```

(`npx firebase-tools` no requiere instalación global; si preferís instalarla una vez, `npm install -g firebase-tools` y después `firebase deploy --only hosting`.)

La primera vez en un dispositivo nuevo hace falta loguearse:
```bash
firebase login                # abre el navegador
# o, si no hay navegador local disponible (Cloud Shell, servidor):
firebase login --no-localhost
```

### Desde el celular (Google Cloud Shell)

1. Abrir **shell.cloud.google.com** en el navegador del celu, entrar con `willy.esposito@gmail.com`.
2. Clonar este repo o subir `index.html` + `firebase.json` + `.firebaserc` (menú **⋮ → Upload**).
3. Correr los comandos de arriba.

### Pedirle a Claude que lo haga

Claude Code (esta sesión o una nueva) puede correr el deploy directo desde su propio entorno, sin que nadie toque una compu, si se le da un **token de CI de Firebase**:

1. Desde cualquier lugar con la CLI (compu o Cloud Shell): `firebase login:ci`
2. Copiar el token que imprime (un string largo).
3. Pasárselo a Claude en el chat y pedirle "deployá con este token: `<token>`".
4. Después de deployar, revocarlo (`firebase logout --token <token>`) o simplemente no reusarlo — no queda guardado en ningún archivo de este repo.

## Nota de seguridad (leer antes de tocar `firebase.json`)

En el primer deploy de agosto 2026 se usó por error `"public": "."` con una lista de `ignore`, confiando en que el patrón `**/.*` excluyera `.git/`. No lo excluyó: Firebase Hosting subió el `.git` completo (historial, objetos, refs) al sitio público por unos minutos, hasta el siguiente deploy que lo corrigió. Se verificó que `.git/config` y `.git/HEAD` volvieron a dar 404 después del segundo deploy.

Por eso ahora `"public"` apunta a una carpeta dedicada (`public/`) que solo contiene lo que se copia ahí a propósito, en vez de confiar en excluir todo lo demás desde la raíz del repo. Si en el futuro hace falta deployar más de un archivo, agregarlos explícitamente a `public/`, no volver a `"public": "."`.

## Qué cambió en la última actualización (agosto 2026)

Rediseño de "Anotar un gasto" con identidad de persona compartida (badge sólido Willy / contorno Yani), numpad como panel superpuesto, y las 4 pantallas del handoff de diseño: carga (2a), lista y resumen del mes (3a), detalle de un gasto (4a) y aviso de gasto fijo duplicado (4b). El resto del dashboard (Fijos, Día a día, Tarjetas, Cronograma, Avisos, Ajustes) no se tocó.
