#!/bin/bash
# Script de copia de seguridad con rsync y listado de paquetes
# Autor: Sergio Jiménez
# Fecha: 11-10-2025

# === CONFIGURACIÓN ===
DESTINO="/mnt/backup/$(hostname)-$(date +%F_%H-%M-%S)"
LOG="/var/log/backup.log"

# Crear destino
mkdir -p "$DESTINO"

# === FUNCIONES ===
log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG"
}

# === COPIA DE DIRECTORIOS ===
log "Iniciando copia de seguridad en $DESTINO..."

RSYNC_OPTS="-aAXHv --delete --numeric-ids --info=progress2 --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp --exclude=/run"

for DIR in /etc /var /home /root /usr/local /opt /srv /boot; do
    if [ -d "$DIR" ]; then
        log "→ Copiando $DIR..."
        rsync $RSYNC_OPTS "$DIR" "$DESTINO" >> "$LOG" 2>&1
    fi
done

# Copia específica de grub.cfg y sources.list*
cp -a /boot/grub/grub.cfg "$DESTINO/boot-grub.cfg" 2>/dev/null
cp -a /etc/apt/sources.list* "$DESTINO/" 2>/dev/null

# === LISTADO DE PAQUETES INSTALADOS ===
log "Generando lista de paquetes instalados..."
dpkg --get-selections > "$DESTINO/paquetes_instalados.txt"

# === FINALIZACIÓN ===
log "Copia de seguridad completada correctamente."
exit 0
