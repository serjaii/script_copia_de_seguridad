# script_copia_de_seguridad
[ ASO ] Creación de un sistema de backup basado en systemd.
1. Crea un sistema de copia de seguridad, donde en primer lugar se confeccionará un script mediante rsync. Se deberán respaldar al menos los siguientes directorios:
/etc, /var, /home, /root, /usr/local, /opt, /srv, /boot/grub/grub.cfg (o todo /boot), /etc/apt/sources.list*
Mediante dpkg --get-selections, obtendremos la paquetería instalada en el sistema.
2. Crea un script que permita restaurar el sistema al estado en que estaba en el momento de crear la copia de seguridad.
3. Crea una unidad de servicio, donde que invoque al script de copia de seguridad.
4. El servicio de backup será programado por una unidad de tipo timer, que controlará que la copia de seguridad se realiza cada día a la 1:00 AM.
5. Elabora una estrategia de copia de seguridad, que contemple, la copia diaria, semanal y mensual.
