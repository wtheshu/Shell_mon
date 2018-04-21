#!/bin/bash
# 这是一个监控磁盘的脚本

rm -f ../log/disk.tmp
for used in `df -h | awk -F'[ %]+' '{print $5}' | grep -v Use`
do
  if [ $used -gt 90 ] && [ $send -eq "1" ]
  then
    echo "$addr `date +"%F %T"` disk useage is $used" >> ../log/disk.tmp
  fi
  
  if [ -f ../log/disk.tmp ]
  then
	echo "==========================="
    df -h >> ../log/disk.tmp
    /bin/bash ../mail/mail.sh $addr\_disk $used ../log/disk.tmp
    echo "`date +"%F %T"` disk useage is not OK"
  else
    echo "`date +"%F %T"` disk useage is OK"
  fi
done


