#!/bin/bash
# Script de restauración de sistema con rsync
# Autor: Sergio Jiménez
# Fecha: 11-10-2025


LOG="/var/log/restore.log"

log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG"
}

if [ "$(whoami)" != "root" ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi


if [ -z "$1" ]; then
    echo "Se debe pasar el fichero de restauración como argumento"
    exit 1
fi

ORIGEN="$1"

if [ ! -d "$ORIGEN" ]; then
    log "ERROR: El directorio $ORIGEN no existe."
    exit 1
fi

read -p "¿Seguro que deseas restaurar el sistema desde $ORIGEN? (s/N): " RESP
[[ "$RESP" =~ ^[sS]$ ]] || exit 0

RSYNC_OPTS="-aAXHv --delete --numeric-ids --info=progress2"

for DIR in etc var home root usr/local opt srv boot; do
    if [ -d "$ORIGEN/$DIR" ]; then
        log "→ Restaurando /$DIR..."
        rsync $RSYNC_OPTS "$ORIGEN/$DIR/" "/$DIR/" >> "$LOG" 2>&1
    fi
done

cp -a "$ORIGEN/boot-grub.cfg" /boot/grub/grub.cfg 2>/dev/null
cp -a "$ORIGEN"/sources.list* /etc/apt/ 2>/dev/null

log "Restauración completada. Se recomienda reiniciar el sistema."
exit 0
