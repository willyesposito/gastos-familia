# Deploy — Guita Familia

## Dónde vive esto realmente

La app en uso está en **Firebase Hosting**, proyecto `finanzas-familia-f2765`:

- URL: https://finanzas-familia-f2765.web.app
- Login: Google, solo `willy.esposito@gmail.com` y `ya.riveiro19@gmail.com` (ver `ALLOWED_EMAILS` en `index.html`)
- Datos: Firestore, colección `familia` (docs `estado`, `gastos`, `snapshots`), en tiempo real entre los dos teléfonos

`index.html` en la raíz de este repo es el **código fuente exacto de esa app** (single-file, sin build step). Este repo no está conectado a Firebase por ningún pipeline — no existe un deploy automático al pushear. Cada actualización se sube a mano.

Los archivos `gastos_willy.html` y `gastos_yani.html` son prototipos viejos, ya reemplazados por `index.html`. Quedan solo de referencia.

## Cómo deployar una actualización

### Opción A — desde una computadora

Requiere Node.js instalado.

**Si ya tenés en esa compu la carpeta desde donde deployaste antes:**
1. Reemplazá su `index.html` por el de este repo.
2. `firebase deploy --only hosting` desde esa carpeta.

**Si es una compu nueva / no tenés esa carpeta:**
```bash
npm install -g firebase-tools
firebase login                       # una sola vez, abre el navegador

mkdir guita-deploy && cd guita-deploy
# copiar el index.html de este repo acá

cat > .firebaserc << 'EOF'
{"projects":{"default":"finanzas-familia-f2765"}}
EOF

cat > firebase.json << 'EOF'
{"hosting":{"public":".","ignore":["firebase.json",".firebaserc","node_modules"]}}
EOF

firebase deploy --only hosting
```

### Opción B — desde el celular (Google Cloud Shell)

1. Abrir **shell.cloud.google.com** en el navegador del celu, entrar con `willy.esposito@gmail.com`.
2. Menú **⋮ → Upload** → subir el `index.html`.
3. Mismos comandos que arriba (`npm install -g firebase-tools`, `firebase login --no-localhost`, armar `guita-deploy/`, `firebase deploy --only hosting`).

### Opción C — pedirle a Claude que lo haga

Claude Code (esta sesión o una nueva) puede correr el deploy directo desde su propio entorno, sin que nadie toque una compu, si se le da un **token de CI de Firebase**:

1. Desde cualquier lugar con la CLI (compu o Cloud Shell): `firebase login:ci`
2. Copiar el token que imprime (un string largo).
3. Pasárselo a Claude en el chat y pedirle "deployá con este token: `<token>`".
4. Es de un solo uso recomendado: después de deployar, revocarlo con `firebase logout --token <token>` o regenerar uno nuevo la próxima vez. No dejarlo guardado en ningún archivo de este repo.

## Qué cambió en la última actualización (agosto 2026)

Rediseño de "Anotar un gasto" con identidad de persona compartida (badge sólido Willy / contorno Yani), numpad como panel superpuesto, y las 4 pantallas del handoff de diseño: carga (2a), lista y resumen del mes (3a), detalle de un gasto (4a) y aviso de gasto fijo duplicado (4b). El resto del dashboard (Fijos, Día a día, Tarjetas, Cronograma, Avisos, Ajustes) no se tocó.
