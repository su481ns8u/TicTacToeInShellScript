##!/bin/bash -x

echo "<-+-+-+-Welcome to Tic Tac Toe-+-+-+->"

declare -a positions
function resetBoard(){
	for ((i=0; i<=9; i++))
	do
		position[$i]=$i
	done
}

function board(){
	printf "\n\n+-----+-----+-----+\n"
	printf "|     |     |     |\n"
	printf "|  ${position[1]}  |  ${position[2]}  |  ${position[3]}  |\n"
	printf "|     |     |     |\n"
	printf "+-----+-----+-----+\n"
        printf "|     |     |     |\n"
	printf "|  ${position[4]}  |  ${position[5]}  |  ${position[6]}  |\n"
        printf "|     |     |     |\n"
        printf "+-----+-----+-----+\n"
        printf "|     |     |     |\n"
	printf "|  ${position[7]}  |  ${position[8]}  |  ${position[9]}  |\n"
        printf "|     |     |     |\n"
        printf "+-----+-----+-----+\n\n"
}

function toss(){
	tossRes=$((RANDOM%2))
	if [ $tossRes -eq 1 ]
	then
		echo "Computer Won Toss"
	else
		echo "User won toss"
	fi
}

resetBoard
board
toss
