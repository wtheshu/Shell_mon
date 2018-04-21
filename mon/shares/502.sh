#!/bin/bash
# 这个脚本主要是监控访问日志里面是否有502状态码，值适合nginx的访问日志

# 先把一分钟前的时分获取到，目的是为了在访问日志中把前一分钟的日志全部过滤出来
d=`date -d "-1 min" +"%H:%M"`

# 用grep '502'把前一分钟包含502状态码的日志过滤并且统计行数，其中502前面有个空格，这是为了更精准匹配
log=`grep 'logfile=' $confFile | awk -F '=' '{print $2}' | sed 's/ //g'`
c_502=`grep :$d: $log | grep ' 502' | wc -l`

# 如果502日志数量超过10条
if [ $c_502 -gt 10 ] && [ $send = "1" ]
then
  #<==首先是记录服务器IP 以及502条数到一个临时文件中
  echo "$ipAddr $d 502 count is $c_502" > ../log/502.tmp
  #<==执行发送邮件的脚本
  /bin/bash ../mail/mail.sh $ipAddr\_502 $c_502 ../log/502.tmp
fi

# 不管502的日志条数是否超过10,都要记录一下脚本的执行时间和502日志的条数到日志里
echo "`date +"%F %T"` 502 $c_502"


