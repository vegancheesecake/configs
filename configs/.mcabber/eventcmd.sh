#!/bin/bash

#!/bin/sh
#
# скрипт событий указанный в параметре set events_command  
# (set указываю на всякий случай, просто по конфигу искать проще)
# всегда получает 4 или менее параметров вида приблизительно такого:
#
# MSG OUT имя_или_jid
# MSG IN имя_или_jid имя_файла
# UNREAD 1
# MSG MUC конференция имя_файла
# STATUS A имя_или_jid
# UNREAD 0
#
# причем имя файла будет только в том случае если установлена переменная
# set event_log_files в значение 1 и в set event_log_dir указана директория
# 
# вообще этот файл может быть любой программой а не только bash-скриптом
# в примерах из исходников был и python 

# Соответсвенно от получаемых параметров и пляшем
EV=$1		# главное событие
EVENT=$2	# не знаю, как обозвать - подсобытие, уточнение события
NICK=$3		# ник или jid
echo $4 >/tmp/file1
# считываем файл если он существует
if [[ $4 != "" ]];then
	TEXT=$(cat $4)
# ну и удаляем файл, ибо он нам больше не нужен
	rm  -f $4
else
	TEXT=""
fi


# проверяем главное событие
case "$EV" in

# если событие сообщение то
	"MSG")
# уточняем второе событие
		case "$EVENT" in
# если событие входящее сообщение то 		
			"IN")
# шлём какое-нибудь уведомление, к примеру notify-send			
				echo $(notify-send -t 10000 "$NICK" "$TEXT")
# ну и можно музычку заодно проиграть				
				aplay ~/.mcabber/sounds/message2.wav &
				;;
# если сообщение это сообщение в конференции				
			"MUC")
# то тоже делаем что-нить, к примеру в данном случае я  ищу вхождение своего ника 
# и если он есть то вывожу уведомление и играю звук, если его нет то просто звук
				FOUND=`echo $TEXT| grep bearinadradge`
				if [ -n "$FOUND" ]; then
					echo $(notify-send -t 10000 "Мне написали в конфе" "$NICK")
					aplay ~/.mcabber/sounds/message1.wav &
				fi
				;;
			"OUT")
# если сообщение исходящее то тоже что-нить делаем, для примера играем звук
				aplay ~/.mcabber/sounds/sent.wav
				;;
		esac
		;;
# если главное сбытие это смена статуса то
	"STATUS")
# уточняем на какой статус меняется 
		case "$EVENT" in
# и задаем иконку и текст для этого статуса (если надо, конечно)
			"O")	icon=online.png;	s=online;;
			"F")	icon=chat.png;		s="free for chat";;
			"A")	icon=away.png;		s=away;;
			"N")	icon=xa.png;		s=n/a;;
			"D")	icon=dnd.png;		s=DND;;
			"_")	icon=offline.png;	s=offline;;
			*)	icon=online.png;	s=$EVENT;;
		esac
# ну и выводим уведомление с соответсвующей  иконкой и текстом
		echo $(notify-send -t 3000 "$NICK is $s")
		;;
# если главное событие это налиние непрочитанных, учьтите что это количество непросмотренных контактов
# а не количество сообщений
	"UNREAD")
# пишем в файл количество
#   $events_command UNREAD "N x y z"        (number of unread buddy buffers)
#   (x=attention y=muc unread buffers z=muc unread buffers with attention sign)
		N=$(echo $EVENT | awk '{print $1}')
		attention=$(echo $EVENT | awk '{print $2}')
		muc=$(echo $EVENT | awk '{print $3}')
		mucattention=$(echo $EVENT | awk '{print $4}')
		let EVENT=N-muc+mucattention
		echo $EVENT > ~/.mcabber/unread
# так же тоже самое количество можно получать обработкой файла 
# указанного в в конфиге (set statefile), но там список jid'ов написавших
# так что количество будет равным cat file | wc -l 
# причем когда число непрочитанных равно нулю, то statfile несуществует
		;;
esac

#Оригинал скрипта там >>> http://muhas.ru/?p=112
