# cheuer's .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# prompt command
# inspired by https://notabug.org/demure/dotfiles/
export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
	local EXIT=$? 		# capture previous exit code first
	history -a			# write the previous history line to disk
	PS1=""
	
	### Colors to Vars ### {{{
	## Inspired by http://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash
	## Terminal Control Escape Sequences: http://www.termsys.demon.co.uk/vtansi.htm
	## Consider using some of: https://gist.github.com/bcap/5682077#file-terminal-control-sh
	## Can unset with `unset -v {,B,U,I,BI,On_,On_I}{Bla,Red,Gre,Yel,Blu,Pur,Cya,Whi} RCol`
	local RCol='\[\e[0m\]'	# Text Reset

	# Regular					Bold						Underline					High Intensity				BoldHigh Intensity			Background				High Intensity Backgrounds
	local Bla='\[\e[0;30m\]';	local BBla='\[\e[1;30m\]';	local UBla='\[\e[4;30m\]';	local IBla='\[\e[0;90m\]';	local BIBla='\[\e[1;90m\]';	local On_Bla='\e[40m';	local On_IBla='\[\e[0;100m\]';
	local Red='\[\e[0;31m\]';	local BRed='\[\e[1;31m\]';	local URed='\[\e[4;31m\]';	local IRed='\[\e[0;91m\]';	local BIRed='\[\e[1;91m\]';	local On_Red='\e[41m';	local On_IRed='\[\e[0;101m\]';
	local Gre='\[\e[0;32m\]';	local BGre='\[\e[1;32m\]';	local UGre='\[\e[4;32m\]';	local IGre='\[\e[0;92m\]';	local BIGre='\[\e[1;92m\]';	local On_Gre='\e[42m';	local On_IGre='\[\e[0;102m\]';
	local Yel='\[\e[0;33m\]';	local BYel='\[\e[1;33m\]';	local UYel='\[\e[4;33m\]';	local IYel='\[\e[0;93m\]';	local BIYel='\[\e[1;93m\]';	local On_Yel='\e[43m';	local On_IYel='\[\e[0;103m\]';
	local Blu='\[\e[0;34m\]';	local BBlu='\[\e[1;34m\]';	local UBlu='\[\e[4;34m\]';	local IBlu='\[\e[0;94m\]';	local BIBlu='\[\e[1;94m\]';	local On_Blu='\e[44m';	local On_IBlu='\[\e[0;104m\]';
	local Pur='\[\e[0;35m\]';	local BPur='\[\e[1;35m\]';	local UPur='\[\e[4;35m\]';	local IPur='\[\e[0;95m\]';	local BIPur='\[\e[1;95m\]';	local On_Pur='\e[45m';	local On_IPur='\[\e[0;105m\]';
	local Cya='\[\e[0;36m\]';	local BCya='\[\e[1;36m\]';	local UCya='\[\e[4;36m\]';	local ICya='\[\e[0;96m\]';	local BICya='\[\e[1;96m\]';	local On_Cya='\e[46m';	local On_ICya='\[\e[0;106m\]';
	local Whi='\[\e[0;37m\]';	local BWhi='\[\e[1;37m\]';	local UWhi='\[\e[4;37m\]';	local IWhi='\[\e[0;97m\]';	local BIWhi='\[\e[1;97m\]';	local On_Whi='\e[47m';	local On_IWhi='\[\e[0;107m\]';
	### End Color Vars ### }}}
	
	# handy unicode symbols
	local FancyX='\342\234\227'
	local Checkmark='\342\234\223'
	
	# check for SSH shell
	if [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]]; then
		PS1+="\[\e]0;\h:\w\a\]"			# set window title to host:working_dir
	else
		PS1+="\[\e]0;\w\a\]"			# set window title to working_dir
	fi
	
	# show previous command exit status
	if [ $EXIT = 0 ]; then
		PS1+="${BGre}${Checkmark} "
	else
		PS1+="${BRed}${FancyX} ${EXIT} "
	fi
	
	# colorize user@host
	if [ $UID = 0 ]; then
		PS1+="${Red}"
	else
		PS1+="${Gre}"
	fi
	PS1+="\u@\h"						# add user@host
	
	### Check Jobs ### {{{
	local BKGJBS=$(jobs -r | wc -l)
	local TOTJBS=$(jobs | grep -v __prompt_command | wc -l)
	if [ ${TOTJBS} -gt 0 ]; then
		PS1+=" ${RCol}[jobs:"
		if [ ${TOTJBS} -gt 2 ]; then
			PS1+=" ${Red}"
		fi
		PS1+="${BKGJBS}/${TOTJBS}${RCol}]"
	fi
	### End Jobs ### }}}
	
	PS1+="${Yel} \w"					# show working directory
	
	# add git prompt
	if type __git_ps1 > /dev/null 2>&1 ;
	then
		GIT_PS1_SHOWDIRTYSTATE=1
		GIT_PS1_SHOWUNTRACKEDFILES=1 #designated with %
		GIT_PS1_SHOWUPSTREAM="auto"
		GIT_PS1_SHOWCOLORHINTS=true
		PS1+="${RCol} \$(__git_ps1 '(%s)')"
	fi

	PS1+="\n"							# put prompt on next line
	# PS1+="${Pur}\! "					# show history number
	PS1+="${RCol}\$ "
}

# Shell Options
#
# Use case-insensitive filename globbing
shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell
#
# Disable suspend
stty -ixon

# Completion options
#
# case-insensitive completion
bind "set completion-ignore-case on"
#
# show suggestions immediately
bind "set show-all-if-ambiguous on"
#
# show all suggestions
bind "set completion-query-items 0"
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:history' # Ignore the ls command as well

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty --ignore="NTUSER.*" --ignore="ntuser.*"'  # classify files in colour
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias lal='ls -Al'

# custom aliases
alias grep='grep -i --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias tunnel='ssh -fNL'
alias reload='source ~/.bashrc'
alias cls='printf "\033c"'
alias psh='ps -H'
alias ns='nslookup -nosearch -debug'
alias scp='__ssh_agent && scp'
alias ssh='__ssh_agent && ssh'
alias screen='screen -U' # always start screen in UTF-8 mode

# git stuff
alias ga='git add'
alias gc='git commit -v'
alias gca='git commit -av'
alias gcm='git commit -m'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gh='git hist'
alias gs='git status'

# conditional aliases
hash colordiff 2>/dev/null && alias diff=colordiff # use colordiff instead of diff if it exists

# other settings
export EDITOR=/usr/bin/vim
export TMOUT=0
[ -r ~/.ssh-agent ] && source ~/.ssh-agent >/dev/null

# functions
function count_folders() {
	shopt -s nullglob
	for dir in ./*/
	do
		printf '%s\n' "$dir"
		find "$dir" -mindepth 1 -type d -printf x | wc --chars
	done
}

function findedit() {
	$EDITOR $(find -name $1)
}

function colors() {
	cat <<EOF
[0;30;40m   \e[30;40m   [0m [0;1;30;40m  \e[1;30;40m  [0m [0;30;4;40m  \e[30;4;40m  [0m [0;1;30;4;40m \e[1;30;4;40m [0m [0;30;5;40m  \e[30;5;40m  [0m [0;1;30;5;40m \e[1;30;5;40m [0m 
[0;31;40m   \e[31;40m   [0m [0;1;31;40m  \e[1;31;40m  [0m [0;31;4;40m  \e[31;4;40m  [0m [0;1;31;4;40m \e[1;31;4;40m [0m [0;31;5;40m  \e[31;5;40m  [0m [0;1;31;5;40m \e[1;31;5;40m [0m 
[0;32;40m   \e[32;40m   [0m [0;1;32;40m  \e[1;32;40m  [0m [0;32;4;40m  \e[32;4;40m  [0m [0;1;32;4;40m \e[1;32;4;40m [0m [0;32;5;40m  \e[32;5;40m  [0m [0;1;32;5;40m \e[1;32;5;40m [0m 
[0;33;40m   \e[33;40m   [0m [0;1;33;40m  \e[1;33;40m  [0m [0;33;4;40m  \e[33;4;40m  [0m [0;1;33;4;40m \e[1;33;4;40m [0m [0;33;5;40m  \e[33;5;40m  [0m [0;1;33;5;40m \e[1;33;5;40m [0m 
[0;34;40m   \e[34;40m   [0m [0;1;34;40m  \e[1;34;40m  [0m [0;34;4;40m  \e[34;4;40m  [0m [0;1;34;4;40m \e[1;34;4;40m [0m [0;34;5;40m  \e[34;5;40m  [0m [0;1;34;5;40m \e[1;34;5;40m [0m 
[0;35;40m   \e[35;40m   [0m [0;1;35;40m  \e[1;35;40m  [0m [0;35;4;40m  \e[35;4;40m  [0m [0;1;35;4;40m \e[1;35;4;40m [0m [0;35;5;40m  \e[35;5;40m  [0m [0;1;35;5;40m \e[1;35;5;40m [0m 
[0;36;40m   \e[36;40m   [0m [0;1;36;40m  \e[1;36;40m  [0m [0;36;4;40m  \e[36;4;40m  [0m [0;1;36;4;40m \e[1;36;4;40m [0m [0;36;5;40m  \e[36;5;40m  [0m [0;1;36;5;40m \e[1;36;5;40m [0m 
[0;37;40m   \e[37;40m   [0m [0;1;37;40m  \e[1;37;40m  [0m [0;37;4;40m  \e[37;4;40m  [0m [0;1;37;4;40m \e[1;37;4;40m [0m [0;37;5;40m  \e[37;5;40m  [0m [0;1;37;5;40m \e[1;37;5;40m [0m 
[0;30;41m   \e[30;41m   [0m [0;1;30;41m  \e[1;30;41m  [0m [0;30;4;41m  \e[30;4;41m  [0m [0;1;30;4;41m \e[1;30;4;41m [0m [0;30;5;41m  \e[30;5;41m  [0m [0;1;30;5;41m \e[1;30;5;41m [0m 
[0;31;41m   \e[31;41m   [0m [0;1;31;41m  \e[1;31;41m  [0m [0;31;4;41m  \e[31;4;41m  [0m [0;1;31;4;41m \e[1;31;4;41m [0m [0;31;5;41m  \e[31;5;41m  [0m [0;1;31;5;41m \e[1;31;5;41m [0m 
[0;32;41m   \e[32;41m   [0m [0;1;32;41m  \e[1;32;41m  [0m [0;32;4;41m  \e[32;4;41m  [0m [0;1;32;4;41m \e[1;32;4;41m [0m [0;32;5;41m  \e[32;5;41m  [0m [0;1;32;5;41m \e[1;32;5;41m [0m 
[0;33;41m   \e[33;41m   [0m [0;1;33;41m  \e[1;33;41m  [0m [0;33;4;41m  \e[33;4;41m  [0m [0;1;33;4;41m \e[1;33;4;41m [0m [0;33;5;41m  \e[33;5;41m  [0m [0;1;33;5;41m \e[1;33;5;41m [0m 
[0;34;41m   \e[34;41m   [0m [0;1;34;41m  \e[1;34;41m  [0m [0;34;4;41m  \e[34;4;41m  [0m [0;1;34;4;41m \e[1;34;4;41m [0m [0;34;5;41m  \e[34;5;41m  [0m [0;1;34;5;41m \e[1;34;5;41m [0m 
[0;35;41m   \e[35;41m   [0m [0;1;35;41m  \e[1;35;41m  [0m [0;35;4;41m  \e[35;4;41m  [0m [0;1;35;4;41m \e[1;35;4;41m [0m [0;35;5;41m  \e[35;5;41m  [0m [0;1;35;5;41m \e[1;35;5;41m [0m 
[0;36;41m   \e[36;41m   [0m [0;1;36;41m  \e[1;36;41m  [0m [0;36;4;41m  \e[36;4;41m  [0m [0;1;36;4;41m \e[1;36;4;41m [0m [0;36;5;41m  \e[36;5;41m  [0m [0;1;36;5;41m \e[1;36;5;41m [0m 
[0;37;41m   \e[37;41m   [0m [0;1;37;41m  \e[1;37;41m  [0m [0;37;4;41m  \e[37;4;41m  [0m [0;1;37;4;41m \e[1;37;4;41m [0m [0;37;5;41m  \e[37;5;41m  [0m [0;1;37;5;41m \e[1;37;5;41m [0m 
[0;30;42m   \e[30;42m   [0m [0;1;30;42m  \e[1;30;42m  [0m [0;30;4;42m  \e[30;4;42m  [0m [0;1;30;4;42m \e[1;30;4;42m [0m [0;30;5;42m  \e[30;5;42m  [0m [0;1;30;5;42m \e[1;30;5;42m [0m 
[0;31;42m   \e[31;42m   [0m [0;1;31;42m  \e[1;31;42m  [0m [0;31;4;42m  \e[31;4;42m  [0m [0;1;31;4;42m \e[1;31;4;42m [0m [0;31;5;42m  \e[31;5;42m  [0m [0;1;31;5;42m \e[1;31;5;42m [0m 
[0;32;42m   \e[32;42m   [0m [0;1;32;42m  \e[1;32;42m  [0m [0;32;4;42m  \e[32;4;42m  [0m [0;1;32;4;42m \e[1;32;4;42m [0m [0;32;5;42m  \e[32;5;42m  [0m [0;1;32;5;42m \e[1;32;5;42m [0m 
[0;33;42m   \e[33;42m   [0m [0;1;33;42m  \e[1;33;42m  [0m [0;33;4;42m  \e[33;4;42m  [0m [0;1;33;4;42m \e[1;33;4;42m [0m [0;33;5;42m  \e[33;5;42m  [0m [0;1;33;5;42m \e[1;33;5;42m [0m 
[0;34;42m   \e[34;42m   [0m [0;1;34;42m  \e[1;34;42m  [0m [0;34;4;42m  \e[34;4;42m  [0m [0;1;34;4;42m \e[1;34;4;42m [0m [0;34;5;42m  \e[34;5;42m  [0m [0;1;34;5;42m \e[1;34;5;42m [0m 
[0;35;42m   \e[35;42m   [0m [0;1;35;42m  \e[1;35;42m  [0m [0;35;4;42m  \e[35;4;42m  [0m [0;1;35;4;42m \e[1;35;4;42m [0m [0;35;5;42m  \e[35;5;42m  [0m [0;1;35;5;42m \e[1;35;5;42m [0m 
[0;36;42m   \e[36;42m   [0m [0;1;36;42m  \e[1;36;42m  [0m [0;36;4;42m  \e[36;4;42m  [0m [0;1;36;4;42m \e[1;36;4;42m [0m [0;36;5;42m  \e[36;5;42m  [0m [0;1;36;5;42m \e[1;36;5;42m [0m 
[0;37;42m   \e[37;42m   [0m [0;1;37;42m  \e[1;37;42m  [0m [0;37;4;42m  \e[37;4;42m  [0m [0;1;37;4;42m \e[1;37;4;42m [0m [0;37;5;42m  \e[37;5;42m  [0m [0;1;37;5;42m \e[1;37;5;42m [0m 
[0;30;43m   \e[30;43m   [0m [0;1;30;43m  \e[1;30;43m  [0m [0;30;4;43m  \e[30;4;43m  [0m [0;1;30;4;43m \e[1;30;4;43m [0m [0;30;5;43m  \e[30;5;43m  [0m [0;1;30;5;43m \e[1;30;5;43m [0m 
[0;31;43m   \e[31;43m   [0m [0;1;31;43m  \e[1;31;43m  [0m [0;31;4;43m  \e[31;4;43m  [0m [0;1;31;4;43m \e[1;31;4;43m [0m [0;31;5;43m  \e[31;5;43m  [0m [0;1;31;5;43m \e[1;31;5;43m [0m 
[0;32;43m   \e[32;43m   [0m [0;1;32;43m  \e[1;32;43m  [0m [0;32;4;43m  \e[32;4;43m  [0m [0;1;32;4;43m \e[1;32;4;43m [0m [0;32;5;43m  \e[32;5;43m  [0m [0;1;32;5;43m \e[1;32;5;43m [0m 
[0;33;43m   \e[33;43m   [0m [0;1;33;43m  \e[1;33;43m  [0m [0;33;4;43m  \e[33;4;43m  [0m [0;1;33;4;43m \e[1;33;4;43m [0m [0;33;5;43m  \e[33;5;43m  [0m [0;1;33;5;43m \e[1;33;5;43m [0m 
[0;34;43m   \e[34;43m   [0m [0;1;34;43m  \e[1;34;43m  [0m [0;34;4;43m  \e[34;4;43m  [0m [0;1;34;4;43m \e[1;34;4;43m [0m [0;34;5;43m  \e[34;5;43m  [0m [0;1;34;5;43m \e[1;34;5;43m [0m 
[0;35;43m   \e[35;43m   [0m [0;1;35;43m  \e[1;35;43m  [0m [0;35;4;43m  \e[35;4;43m  [0m [0;1;35;4;43m \e[1;35;4;43m [0m [0;35;5;43m  \e[35;5;43m  [0m [0;1;35;5;43m \e[1;35;5;43m [0m 
[0;36;43m   \e[36;43m   [0m [0;1;36;43m  \e[1;36;43m  [0m [0;36;4;43m  \e[36;4;43m  [0m [0;1;36;4;43m \e[1;36;4;43m [0m [0;36;5;43m  \e[36;5;43m  [0m [0;1;36;5;43m \e[1;36;5;43m [0m 
[0;37;43m   \e[37;43m   [0m [0;1;37;43m  \e[1;37;43m  [0m [0;37;4;43m  \e[37;4;43m  [0m [0;1;37;4;43m \e[1;37;4;43m [0m [0;37;5;43m  \e[37;5;43m  [0m [0;1;37;5;43m \e[1;37;5;43m [0m 
[0;30;44m   \e[30;44m   [0m [0;1;30;44m  \e[1;30;44m  [0m [0;30;4;44m  \e[30;4;44m  [0m [0;1;30;4;44m \e[1;30;4;44m [0m [0;30;5;44m  \e[30;5;44m  [0m [0;1;30;5;44m \e[1;30;5;44m [0m 
[0;31;44m   \e[31;44m   [0m [0;1;31;44m  \e[1;31;44m  [0m [0;31;4;44m  \e[31;4;44m  [0m [0;1;31;4;44m \e[1;31;4;44m [0m [0;31;5;44m  \e[31;5;44m  [0m [0;1;31;5;44m \e[1;31;5;44m [0m 
[0;32;44m   \e[32;44m   [0m [0;1;32;44m  \e[1;32;44m  [0m [0;32;4;44m  \e[32;4;44m  [0m [0;1;32;4;44m \e[1;32;4;44m [0m [0;32;5;44m  \e[32;5;44m  [0m [0;1;32;5;44m \e[1;32;5;44m [0m 
[0;33;44m   \e[33;44m   [0m [0;1;33;44m  \e[1;33;44m  [0m [0;33;4;44m  \e[33;4;44m  [0m [0;1;33;4;44m \e[1;33;4;44m [0m [0;33;5;44m  \e[33;5;44m  [0m [0;1;33;5;44m \e[1;33;5;44m [0m 
[0;34;44m   \e[34;44m   [0m [0;1;34;44m  \e[1;34;44m  [0m [0;34;4;44m  \e[34;4;44m  [0m [0;1;34;4;44m \e[1;34;4;44m [0m [0;34;5;44m  \e[34;5;44m  [0m [0;1;34;5;44m \e[1;34;5;44m [0m 
[0;35;44m   \e[35;44m   [0m [0;1;35;44m  \e[1;35;44m  [0m [0;35;4;44m  \e[35;4;44m  [0m [0;1;35;4;44m \e[1;35;4;44m [0m [0;35;5;44m  \e[35;5;44m  [0m [0;1;35;5;44m \e[1;35;5;44m [0m 
[0;36;44m   \e[36;44m   [0m [0;1;36;44m  \e[1;36;44m  [0m [0;36;4;44m  \e[36;4;44m  [0m [0;1;36;4;44m \e[1;36;4;44m [0m [0;36;5;44m  \e[36;5;44m  [0m [0;1;36;5;44m \e[1;36;5;44m [0m 
[0;37;44m   \e[37;44m   [0m [0;1;37;44m  \e[1;37;44m  [0m [0;37;4;44m  \e[37;4;44m  [0m [0;1;37;4;44m \e[1;37;4;44m [0m [0;37;5;44m  \e[37;5;44m  [0m [0;1;37;5;44m \e[1;37;5;44m [0m 
[0;30;45m   \e[30;45m   [0m [0;1;30;45m  \e[1;30;45m  [0m [0;30;4;45m  \e[30;4;45m  [0m [0;1;30;4;45m \e[1;30;4;45m [0m [0;30;5;45m  \e[30;5;45m  [0m [0;1;30;5;45m \e[1;30;5;45m [0m 
[0;31;45m   \e[31;45m   [0m [0;1;31;45m  \e[1;31;45m  [0m [0;31;4;45m  \e[31;4;45m  [0m [0;1;31;4;45m \e[1;31;4;45m [0m [0;31;5;45m  \e[31;5;45m  [0m [0;1;31;5;45m \e[1;31;5;45m [0m 
[0;32;45m   \e[32;45m   [0m [0;1;32;45m  \e[1;32;45m  [0m [0;32;4;45m  \e[32;4;45m  [0m [0;1;32;4;45m \e[1;32;4;45m [0m [0;32;5;45m  \e[32;5;45m  [0m [0;1;32;5;45m \e[1;32;5;45m [0m 
[0;33;45m   \e[33;45m   [0m [0;1;33;45m  \e[1;33;45m  [0m [0;33;4;45m  \e[33;4;45m  [0m [0;1;33;4;45m \e[1;33;4;45m [0m [0;33;5;45m  \e[33;5;45m  [0m [0;1;33;5;45m \e[1;33;5;45m [0m 
[0;34;45m   \e[34;45m   [0m [0;1;34;45m  \e[1;34;45m  [0m [0;34;4;45m  \e[34;4;45m  [0m [0;1;34;4;45m \e[1;34;4;45m [0m [0;34;5;45m  \e[34;5;45m  [0m [0;1;34;5;45m \e[1;34;5;45m [0m 
[0;35;45m   \e[35;45m   [0m [0;1;35;45m  \e[1;35;45m  [0m [0;35;4;45m  \e[35;4;45m  [0m [0;1;35;4;45m \e[1;35;4;45m [0m [0;35;5;45m  \e[35;5;45m  [0m [0;1;35;5;45m \e[1;35;5;45m [0m 
[0;36;45m   \e[36;45m   [0m [0;1;36;45m  \e[1;36;45m  [0m [0;36;4;45m  \e[36;4;45m  [0m [0;1;36;4;45m \e[1;36;4;45m [0m [0;36;5;45m  \e[36;5;45m  [0m [0;1;36;5;45m \e[1;36;5;45m [0m 
[0;37;45m   \e[37;45m   [0m [0;1;37;45m  \e[1;37;45m  [0m [0;37;4;45m  \e[37;4;45m  [0m [0;1;37;4;45m \e[1;37;4;45m [0m [0;37;5;45m  \e[37;5;45m  [0m [0;1;37;5;45m \e[1;37;5;45m [0m 
[0;30;46m   \e[30;46m   [0m [0;1;30;46m  \e[1;30;46m  [0m [0;30;4;46m  \e[30;4;46m  [0m [0;1;30;4;46m \e[1;30;4;46m [0m [0;30;5;46m  \e[30;5;46m  [0m [0;1;30;5;46m \e[1;30;5;46m [0m 
[0;31;46m   \e[31;46m   [0m [0;1;31;46m  \e[1;31;46m  [0m [0;31;4;46m  \e[31;4;46m  [0m [0;1;31;4;46m \e[1;31;4;46m [0m [0;31;5;46m  \e[31;5;46m  [0m [0;1;31;5;46m \e[1;31;5;46m [0m 
[0;32;46m   \e[32;46m   [0m [0;1;32;46m  \e[1;32;46m  [0m [0;32;4;46m  \e[32;4;46m  [0m [0;1;32;4;46m \e[1;32;4;46m [0m [0;32;5;46m  \e[32;5;46m  [0m [0;1;32;5;46m \e[1;32;5;46m [0m 
[0;33;46m   \e[33;46m   [0m [0;1;33;46m  \e[1;33;46m  [0m [0;33;4;46m  \e[33;4;46m  [0m [0;1;33;4;46m \e[1;33;4;46m [0m [0;33;5;46m  \e[33;5;46m  [0m [0;1;33;5;46m \e[1;33;5;46m [0m 
[0;34;46m   \e[34;46m   [0m [0;1;34;46m  \e[1;34;46m  [0m [0;34;4;46m  \e[34;4;46m  [0m [0;1;34;4;46m \e[1;34;4;46m [0m [0;34;5;46m  \e[34;5;46m  [0m [0;1;34;5;46m \e[1;34;5;46m [0m 
[0;35;46m   \e[35;46m   [0m [0;1;35;46m  \e[1;35;46m  [0m [0;35;4;46m  \e[35;4;46m  [0m [0;1;35;4;46m \e[1;35;4;46m [0m [0;35;5;46m  \e[35;5;46m  [0m [0;1;35;5;46m \e[1;35;5;46m [0m 
[0;36;46m   \e[36;46m   [0m [0;1;36;46m  \e[1;36;46m  [0m [0;36;4;46m  \e[36;4;46m  [0m [0;1;36;4;46m \e[1;36;4;46m [0m [0;36;5;46m  \e[36;5;46m  [0m [0;1;36;5;46m \e[1;36;5;46m [0m 
[0;37;46m   \e[37;46m   [0m [0;1;37;46m  \e[1;37;46m  [0m [0;37;4;46m  \e[37;4;46m  [0m [0;1;37;4;46m \e[1;37;4;46m [0m [0;37;5;46m  \e[37;5;46m  [0m [0;1;37;5;46m \e[1;37;5;46m [0m 
[0;30;47m   \e[30;47m   [0m [0;1;30;47m  \e[1;30;47m  [0m [0;30;4;47m  \e[30;4;47m  [0m [0;1;30;4;47m \e[1;30;4;47m [0m [0;30;5;47m  \e[30;5;47m  [0m [0;1;30;5;47m \e[1;30;5;47m [0m 
[0;31;47m   \e[31;47m   [0m [0;1;31;47m  \e[1;31;47m  [0m [0;31;4;47m  \e[31;4;47m  [0m [0;1;31;4;47m \e[1;31;4;47m [0m [0;31;5;47m  \e[31;5;47m  [0m [0;1;31;5;47m \e[1;31;5;47m [0m 
[0;32;47m   \e[32;47m   [0m [0;1;32;47m  \e[1;32;47m  [0m [0;32;4;47m  \e[32;4;47m  [0m [0;1;32;4;47m \e[1;32;4;47m [0m [0;32;5;47m  \e[32;5;47m  [0m [0;1;32;5;47m \e[1;32;5;47m [0m 
[0;33;47m   \e[33;47m   [0m [0;1;33;47m  \e[1;33;47m  [0m [0;33;4;47m  \e[33;4;47m  [0m [0;1;33;4;47m \e[1;33;4;47m [0m [0;33;5;47m  \e[33;5;47m  [0m [0;1;33;5;47m \e[1;33;5;47m [0m 
[0;34;47m   \e[34;47m   [0m [0;1;34;47m  \e[1;34;47m  [0m [0;34;4;47m  \e[34;4;47m  [0m [0;1;34;4;47m \e[1;34;4;47m [0m [0;34;5;47m  \e[34;5;47m  [0m [0;1;34;5;47m \e[1;34;5;47m [0m 
[0;35;47m   \e[35;47m   [0m [0;1;35;47m  \e[1;35;47m  [0m [0;35;4;47m  \e[35;4;47m  [0m [0;1;35;4;47m \e[1;35;4;47m [0m [0;35;5;47m  \e[35;5;47m  [0m [0;1;35;5;47m \e[1;35;5;47m [0m 
[0;36;47m   \e[36;47m   [0m [0;1;36;47m  \e[1;36;47m  [0m [0;36;4;47m  \e[36;4;47m  [0m [0;1;36;4;47m \e[1;36;4;47m [0m [0;36;5;47m  \e[36;5;47m  [0m [0;1;36;5;47m \e[1;36;5;47m [0m 
[0;37;47m   \e[37;47m   [0m [0;1;37;47m  \e[1;37;47m  [0m [0;37;4;47m  \e[37;4;47m  [0m [0;1;37;4;47m \e[1;37;4;47m [0m [0;37;5;47m  \e[37;5;47m  [0m [0;1;37;5;47m \e[1;37;5;47m [0m 
EOF
}

function color_explain() {
	eval "$(dircolors -b)"
	eval $(echo "no:global default;fi:normal file;di:directory;ln:symbolic link;pi:named pipe;so:socket;do:door;bd:block device;cd:character device;or:orphan symlink;mi:missing file;su:set uid;sg:set gid;tw:sticky other writable;ow:other writable;st:sticky;ex:executable;"|sed -e 's/:/="/g; s/\;/"\n/g')
	{
	  IFS=:
	  for i in $LS_COLORS
	  do
		echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
	  done
	}
}

function __ssh_agent() {
	# If no SSH agent is already running, start one now. Re-use sockets so we never
	# have to start more than one session.

	ssh-add -l >/dev/null 2>&1
	result=$?
	if [ $result = 2 ]; then
		# read ssh-agent config from file and retry
		[ -r ~/.ssh-agent ] && source ~/.ssh-agent >/dev/null
		ssh-add -l >/dev/null 2>&1
		result=$?
		if [ $result = 2 ]; then
			ssh-agent > ~/.ssh-agent
			source ~/.ssh-agent >/dev/null
			ssh-add
		fi
	fi
	if [ $result = 1 ]; then
		ssh-add
	fi
}

# cygwin-only settings
if [ -d /cygdrive ]; then

	if [ ! -x $EDITOR ]; then
		export EDITOR="notepad++.exe -multiInst -nosession -notabbar"
	fi

	# notepad++
	function npp() {
		opts=""
		for ((arg=1; arg <= $#; arg++))
		do
			opts="$opts `cygpath -wa ${!arg}`"
			if [ ! -f ${!arg} ]
			then
				touch ${!arg}
			fi
		done
		
		run "C:\Program Files (x86)\Notepad++\notepad++.exe" -nosession $opts
	}

fi

# check for dotfile updates & reload this file
if [[ ! -e ~/.dotfiles/.update_check || $(( $(date +%s) - $(date +%s -r .update_check) )) -gt 28800 ]]; then
	echo Updating dotfiles...
	~/.dotfiles/update.sh
	touch ~/.dotfiles/.update_check
	source ~/.bashrc
fi
