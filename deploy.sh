#!/usr/bin/env bash
# Deploy de Guita Familia a Firebase Hosting.
# Uso:  ./deploy.sh
#
# Regenera public/ desde index.html y deploya. Antes chequea que la copia
# local no esté atrasada respecto del remoto, que es la forma más fácil de
# pisar producción con código viejo sin darse cuenta.

set -euo pipefail
cd "$(dirname "$0")"

SITE="https://finanzas-familia-f2765.web.app"

echo "→ Chequeando el estado del repo…"
if ! git fetch origin --quiet 2>/dev/null; then
  echo "⚠  No pude contactar el remoto (¿sin internet?). Sigo con lo que hay local."
else
  BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
  if [ "$BEHIND" -gt 0 ]; then
    echo
    echo "✖ Tu copia local está $BEHIND commit(s) ATRÁS del remoto."
    echo "  Si deployás así, pisás producción con código viejo."
    echo
    echo "  Corré:   git pull"
    echo "  y volvé a intentar."
    exit 1
  fi
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo
  echo "⚠  Tenés cambios sin commitear."
  echo "  Se va a deployar el index.html tal como está en esta carpeta."
  printf "  ¿Seguir igual? [s/N] "
  read -r RESP
  case "$RESP" in
    s|S|si|Si|SI) ;;
    *) echo "  Cancelado."; exit 1 ;;
  esac
fi

echo "→ Regenerando public/ desde index.html…"
rm -rf public
mkdir -p public
cp index.html public/index.html

echo "→ Deployando a Firebase…"
npx --yes firebase-tools deploy --only hosting

echo
echo "✓ Deploy completo: $SITE"
echo "  Verificá que abra bien y que el login siga andando."
