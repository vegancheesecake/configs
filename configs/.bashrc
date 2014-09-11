#
# ~/.bashrc
#
source /etc/profile
source /etc/profile.d/bash-completion.sh
PATH=${PATH}:${HOME}/bin
EDITOR=/usr/bin/vim
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \w]\$ '

. ~/.bash_aliases

dclrs() {
	trap "" INT
	dynamic-colors init
	inotifywait -qq -e close /home/user/.dynamic-colors/control 2> /dev/null
	}

case "$TERM" in
xterm*|rxvt*)
	while true; do
			dclrs
	done &
	;;
*)
	if [[ -z ${DISPLAY} && $(tty) == "/dev/tty1" ]]; then
	        exec startx
	fi
	;;
esac

complete -cf sudo

#автозапуск всякой херни, не зависящей от иксов
pidof pulseaudio > /dev/null || pulseaudio 
pidof mpd > /dev/null || mpd
pidof mpdscribble > /dev/null || mpdscribble
pidof gpg-agent > /dev/null || /usr/bin/gpg-agent --daemon --use-standard-socket > /dev/null
