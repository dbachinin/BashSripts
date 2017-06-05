#!/bin/sh
########################Переменные#################################################
VMNAMEFBU=rds
PUT=/vmfs/volumes/d37ea5e1-3d5ef890
PATHBUT=/vmfs/volumes/d37ea5e1-3d5ef890/BackUpVMS/`date +%d-%m-%G`
PATHBUN=/vmfs/volumes/02bd7f89-ec097b21/BackUpVMS/`date +%d-%m-%G`
mkdir $PATHBUT
mkdir $PATHBUN
##########################Удаление старых бэкапов Thecus#################################
spacebackup=`du -sm $PATHBUT/../ | awk '{print$1}'`
if [ $spacebackup -gt 3145728 ]
   then
       cd $PATHBUT/../
        while [ `du -sm $PATHBUT/../ | awk '{print$1}'` -gt "3145728" ]
        do
        ls -t $PATHBUT/../ | tail -n1 | xargs rm -rf '{}'
    done
fi
##########################Удаление старых бэкапов Nexenta#################################
spacebackup=`du -sm $PATHBUN/../ | awk '{print$1}'`
if [ $spacebackup -gt 4194304 ]
   then
       cd $PATHBUN/../
        while [ `du -sm $PATHBUN/../ | awk '{print$1}'` -gt "4194304" ]
        do
        ls -t $PATHBUN/../ | tail -n1 | xargs rm -rf '{}'
    done
fi
########################Поиск включённых виртуалок#################################
VMID=$(/usr/bin/vim-cmd vmsvc/getallvms | grep ^[0-9] | awk '{print $1}')
# Просматриваем все виртуалки в цикле
for vm in $VMID
do
# Получаем их состояние (turned on, off, whatever)
STATE=$(/usr/bin/vim-cmd vmsvc/power.getstate $vm | tail -1 | awk '{print $2}')
VMNAME=$(/usr/bin/vim-cmd vmsvc/get.summary $vm | egrep 'name' | awk '{FS="\""} {print$2}')
VMNAMESR=$(/usr/bin/vim-cmd vmsvc/get.summary $vm | egrep 'name' | awk '{FS="-"} {print$3}')
PATHDS=$(/usr/bin/vim-cmd vmsvc/get.datastores $vm | egrep 'url' | awk '{print $2}')
if [ "$VMNAMEFBU" = "$VMNAMESR" ]
then
if [ "$STATE" = "on" ]
then
if [ "$PATHDS" = "$PUT" ]
then PATHBU=$PATHBUN
else PATHBU=$PATHBUT
fi
##########################Создание новых бэкапов###################################
vim-cmd vmsvc/power.shutdown $vm
while [ "$STATE" = "on" ]
do
STATE=$(/usr/bin/vim-cmd vmsvc/power.getstate $vm | tail -1 | awk '{print $2}')
done
echo $VMNAME >> $PATHBU/../log
echo "Начало копирования: `date +%X--%d-%m-%G`" >> $PATHBU/../log
mkdir $PATHBU/$VMNAME
cp -r $PATHDS/VMS/$VMNAME/*.vmx $PATHBU/$VMNAME
vmkfstools -i $PATHDS/VMS/$VMNAME/"$VMNAME".vmdk $PATHBU/$VMNAME/"$VMNAME".vmdk
echo "Завершение копирования: `date +%X--%d-%m-%G`" >> $PATHBU/../log
vim-cmd vmsvc/power.on $vm
fi
fi
done
#########################Удаление пустых каталогов#################################
ThS=/vmfs/volumes/d37ea5e1-3d5ef890/BackUpVMS/*
NxS=/vmfs/volumes/02bd7f89-ec097b21/BackUpVMS/*
###################################################################################
rmdir --ignore-fail-on-non-empty $ThS
rmdir --ignore-fail-on-non-empty $NxS
exit 0
