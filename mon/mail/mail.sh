#!/bin/bash

# 执行该脚本的时候，会带有参数，第一个参数用来作为日志文件名
logname=$1

# 定义执行该脚本时的时间戳
t_s=`date +%s`

# 定义t_s2为执行脚本时的前两个小时的时间戳
t_s2=`date -d "2 hours ago" +%s`

# 判断否有相关日志文件，这个日志文件名就是第一个参数
if [ ! -f ../log/$logname ]
then
	echo $t_s2 > ../log/$logname
fi

# 如果日志文件存在，日志里会有多行，t_s2则为日志文件中最后一行的内容
t_s2=`tail -1 ../log/$logname | awk '{print $1}'`

# 把当前时间的时间戳再追加到日志文件中
echo $t_s >> ../log/$logname

# 取两个时间戳的差值，差值有可能是7200,也有可能小于这个值
v=$[$t_s-$t_s2]
echo $v

# 判断差值是否小于3600,也就是两个时间间隔是否大于1小时
if [ $v -gt 3600 ]
then
	#<==如果大于1小时则执行发送邮件的PHP脚本
	php ../mail/mail.php "$1 $2" "$3"
	#<==当发完邮件后，会在../log/$logname.count中写入一个0,这个文件可以是一个临时文件，用作计数器
	echo "0" > ../log/$logname.count
else
	#<==如果间隔小于1小时，首先会去查看计数器里面的数值
	if [ ! -f ../log/$logname.count ]
	then
		#<==时间小于1小时，但是记录计数器文件不存在，则会直接创建该文件，并且写入0
		echo "0" > ../log/$logname.count
	fi

	# 然后把计数器里面的数值加1
	nu=`cat ../log/$logname.count`
	nu2=$[$nu+1]
	echo $nu2 > ../log/$logname.count

	# 一直加到计数器里面的数字为10时，会再次发一封邮件，然后把计数器清零
	# 因为主程序设置为一分钟执行一次，所以增加一个数就是一分钟
	if [ $nu2 -gt 10 ]
	then
		php ../mail/mail.php "trouble continue 10 min $1 $2" "$3"
		echo "0" > ../log/$logname.count
	fi
fi


