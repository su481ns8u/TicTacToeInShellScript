##!/bin/bash -x

echo "<-+-+-+-Welcome to Tic Tac Toe-+-+-+->"

declare -a positions
function resetBoard(){
	for ((i=0; i<=9; i++))
	do
		position[$i]=$i
	done
	echo -n "Board Reseted !"
}

resetBoard
