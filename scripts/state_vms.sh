#!/bin/sh
VMID=$(/usr/bin/vim-cmd vmsvc/getallvms | grep ^[0-9] | awk '{print $1}')
# Просматриваем все виртуалки в цикле
for i in $VMID
do
# Получаем их состояние (turned on, off, whatever)
VMNAME=$(/usr/bin/vim-cmd vmsvc/get.summary $i | egrep 'name' | awk '{FS="\""} {print$2}')
STATE=$(/usr/bin/vim-cmd vmsvc/power.getstate $i | tail -1 | awk '{print $2}')
echo "$i $VMNAME: $STATE"
done
