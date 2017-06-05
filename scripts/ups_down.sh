#!/bin/sh
# Получаем ID всех виртуалок
VMID=$(/usr/bin/vim-cmd vmsvc/getallvms | grep ^[0-9] | awk '{print $1}')
# Просматриваем все виртуалки в цикле
for i in $VMID
do
# Получаем их состояние (turned on, off, whatever)
STATE=$(/usr/bin/vim-cmd vmsvc/power.getstate $i | tail -1 | awk '{print $2}')
# Если виртуалка запущена - выключить
if [ $STATE == on ]
then
/usr/bin/vim-cmd vmsvc/power.shutdown $i
fi
done
#Делаем паузу в ожидании, пока виртуалки погаснут
sleep 180
# Теперь выключаем и сам сервер виртуализации.
/sbin/shutdown.sh
/sbin/poweroff
