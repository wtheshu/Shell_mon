#!/bin/bash

# 获取1分钟内的系统负载整数
load=`uptime | awk -F 'average:' '{print $2}' | cut -d',' -f1 | sed 's/ //g' | cut -d. -f1`
#也可以用下面这条命
# uptime | awk '{print $(NF-2)}' | cut -d. -f1)}'

# 当负载高于某个值，并且配置文件已经打开发邮件的开关，则会执行下面的操作
averageValue=`cat /proc/cpuinfo | grep 'processor' | wc -l`
if [ $load -gt $averageValue ] && [ $send -eq "1" ]
then
  echo "$ipAddr `date +"%F %T"` load is $load" > ../log/load.tmp
  #<==当负载高时把时间和具体的负载情况记录到一个临时文件中以便发邮件使用
  /bin/bash ../mail/mail.sh $ipAddr\_load $load ../log/load.tmp
fi

# 不管负载如何，我们都要记录到日志里
echo "`date +"%F %T"` load is $load"


