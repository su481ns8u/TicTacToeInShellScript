##!/bin/bash -x

echo "<-+-+-+-Welcome to Tic Tac Toe-+-+-+->"

declare -a positions
function resetBoard(){
	for ((i=0; i<=9; i++))
	do
		position[$i]=$i
	done
	echo "Board Reseted !"
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
toss
