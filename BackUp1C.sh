#!/bin/bash
umount smb
echo "" > 1c
echo "" > 1c_out
BUH_PC[1]="192.168.110.112:ad1:администратор%pass"
BUH_PC[2]="192.168.110.113:ad1:администратор%pass"
BUH_PC[3]="192.168.101.56:ad4:root%pass"
BUH_PC[4]="192.168.115.55:ad1:администратор%pass"
#BUH_PC[5]="192.168.110.237:ad3:администратор%488078996!Nhfcn"

for i in $(seq 1 4); do
    ip=`echo ${BUH_PC[$i]}|awk -F":" '{print $1}'`
    pass=`echo ${BUH_PC[$i]}|awk -F":" '{print $2}'`
    passmount=`echo ${BUH_PC[$i]}|awk -F":" '{print $3}'`
    pi=`ping $ip -c 1 -w 1|grep "100% packet loss"`

    if [ "$pi" ]
    then 
    echo "============"$ip "ВЫКЛ==============" >> 1c_out
    
    else

    smbclient -L $ip -A $pass|grep '$              Disk'| awk '{print ($1)}'|while read res; do 
    mount.cifs -o user=$passmount //$ip/$res smb rw,utf8
    echo "================================"$ip $res"====================================" >> 1c_out

    dirback="/mnt/_SHARE_/BackUpBUH/"`date +%F`
    mkdir $dirback

	IFS=$'\012'; find /root/smb/ -name "1Cv8.1CD" |sed 's/ /\\ /g'|while read line
	 do d=`echo "$line"| sed 's/1Cv8.1CD//'; cd ..`
	 dir1c=`echo $d |grep -v -E "1Cv8FTxt|1Cv8Log"`
	 
	 mkdir -p $dirback"_"$ip"_"$dir1c ; cp -R $dir1c $dirback"_"$ip"_"$dir1c
	 done

#		find /root/smb/ -name "1Cv8.1CD" -print |sed 's/ /\\ /g'|while read line; do d=`echo "$line"| sed 's/1Cv8.1CD//'; cd ../`; > 1c; done
	find /root/smb/ -name "1Cv8.1CD" -print | sed 's/1Cv8.1CD//' >> 1c_out
#		IFS=$'\012'; for addr in `cat 1c_out`; do echo $addr; du -h -d 0 $addr > 1c; done
    mv 1c_out 1c_out_"$ip"_`date +%d"_"%b`
    umount smb 
    done

# 			    if [ i = 3 ]
		
# 				then
# 			smbclient -L $ip -U $passmount|grep '$              Disk'| awk '{print ($1)}'|while read res; do
# 				mount.cifs -o user=$passmount //$ip/$res smb rw,utf8
# 				echo "================================"$ip $res"====================================" >> 1c_out
		
# 			#	echo "========"$ip"==========" >> 1c_out
# 					IFS=$'\012'; find /root/smb/ -name "1Cv8.1CD" |sed 's/ /\\ /g'|while read line; do d=`echo "$line"| sed 's/1Cv8.1CD//'; cd ..`; du -h -d 1 $d |grep -v -E "1Cv8FTxt|1Cv8Log" >> 1c_out; done
# 			#		find /root/smb/ -name "1Cv8.1CD" -print |sed 's/ /\\ /g'|while read line; do d=`echo "$line"| sed 's/1Cv8.1CD//'; cd ../`; > 1c; done
# 					find /root/smb/ -name "1Cv8.1CD" -print | sed 's/1Cv8.1CD//' >> 1c_out
# 			#		IFS=$'\012'; for addr in `cat 1c_out`; do echo $addr; du -h -d 0 $addr > 1c; done
# 				mv 1c_out 1c_out_"$ip"_`date +%d"_"%b`
# 				umount smb 
# 			    done
# fi
fi
