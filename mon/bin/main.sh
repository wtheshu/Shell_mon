#!/bin/bash
# Written by theshu.
# Mail: theshu@theshu.wang

# 正确的日志输出到mon.log，错误日志输出到err.log
exec 1>> ../log/mon.log 2>> ../log/err.log

# 判断是否在bin目录里，不然后面的监控脚本、邮件和日志会找不到
dir=`pwd`
lastDir=`echo $dir | awk -F'/' '{print $NF}'`
if [ $lastDir = "bin" -o $lastDir = "bin/" ]
then
  confFile="../conf/mon.conf"
else
  echo "Work directory is not bin!"
  exit 1
fi

# 获取本机IP地址，在发告警的时候得靠IP地址来区分开机器
export ipAddr=`/sbin/ifconfig | grep -A1 'flags' | grep 'netmask' | awk '{print $2}' | grep -v 127`
# 是否发送邮件的开关，0为不发送，1为发送
export send=`grep "send" $confFile | cut -d'=' -f2 | sed 's/ //g'`


# NO.1 监控系统负载
set_load_average=`grep "set_load_average" $confFile | cut -d'=' -f2 | sed 's/ //g'`
[ $set_load_average -eq "1" ] && {
	/bin/bash ../shares/load.sh
}


# NO.2 监控502
set_502=`grep "set_502" $confFile | cut -d'=' -f2 | sed 's/ //g'`
[ $set_502 -eq "1" ] && {
	/bin/bash ../shares/502.sh
}

# NO.3 监控磁盘使用情况
set_disk=`grep "set_disk" $confFile | cut -d'=' -f2 | sed 's/ //g'`
[ $set_disk -eq "1" ] && {
	/bin/bash ../shares/disk.sh
}


