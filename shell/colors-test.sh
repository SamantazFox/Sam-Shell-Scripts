#!/bin/zsh

. ${0%/*}/colors


bg=(
	$COLOR_NONE
	$COLOR_BG_BLACK  # \033[40m
	$COLOR_BG_RED    # \033[41m
	$COLOR_BG_GREEN  # \033[42m
	$COLOR_BG_BROWN  # \033[43m
	$COLOR_BG_BLUE   # \033[44m
	$COLOR_BG_PURPLE # \033[45m
	$COLOR_BG_CYAN   # \033[46m
	$COLOR_BG_GREY   # \033[47m
)
bg_names=(
	"None "
	"Black"
	"Red  "
	"Green"
	"Brown"
	"Blue "
	"Purple"
	"Cyan "
	"Grey "
)

fg=(
	$COLOR_FG_BLACK  # \033[30m
	$COLOR_FG_RED    # \033[31m
	$COLOR_FG_GREEN  # \033[32m
	$COLOR_FG_BROWN  # \033[33m
	$COLOR_FG_BLUE   # \033[34m
	$COLOR_FG_PURPLE # \033[35m
	$COLOR_FG_CYAN   # \033[36m
	$COLOR_FG_GREY   # \033[37m
	$COLOR_FG_DGREY   # \033[1;30m
	$COLOR_FG_LRED    # \033[1;31m
	$COLOR_FG_LGREEN  # \033[1;32m
	$COLOR_FG_YELLOW  # \033[1;33m
	$COLOR_FG_LBLUE   # \033[1;34m
	$COLOR_FG_LPURPLE # \033[1;35m
	$COLOR_FG_LCYAN   # \033[1;36m
	$COLOR_FG_WHITE   # \033[1;37m
)
fg_names=(
"Black" "Red" "Green" "Brown" "Blue" "Purple" "Cyan" "Grey"
"Dark grey" "Light red" "Light green" "Yellow" "Light blue" "Light Purple" "Light cyan" "White"
)


printColorTable()
{
	if ! test -z $1; then inv=$STYLE_INVERT; fi

	printf " ${COLOR_NONE}%12s " "Fgnd / Bgnd"
	for bg_n in $bg_names[@]; do printf "|  %6s  " $bg_n; done

	printf "|\n--------------"
	for bg_n in $bg_names[@]; do printf "+--%6s--" "------";  done

	printf "+\n"

	for fg_n in {1..${#fg}}
	do
		printf " ${COLOR_NONE}%12s " $fg_names[$fg_n]
		fg_color=$fg[$fg_n]

		for bg_color in $bg[@]; do
			printf "| ${bg_color}${fg_color}${inv}  Test  ${COLOR_NONE} "
		done

		printf "|\n"
	done
}


# Print normal colors
echo
printColorTable

# Print inverted colors
echo
printColorTable true
