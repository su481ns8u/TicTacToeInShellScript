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
	firstPlayFlag=0
	tossRes=$((RANDOM%2))
	if [ $tossRes -eq 1 ]
	then
		firstPlayFlag=1
		echo "Computer Won Toss"
		symbol=$((RANDOM%2))
                if [ $symbol -eq 1 ]
                then
                        compSymbol='X'
                        userSymbol='O'
                else
                        compSymbol='O'
                        userSymbol='X'
                fi
	else
		firstPlayFlag=2
		echo "User won toss"
		read -p "Enter 1 for 'X' symbol and 2 for 'O' symbol: " symbol
                if [ $symbol -eq 1 ]
                then
                        userSymbol='X'
                        compSymbol='O'
                else
                        userSymbol='O'
                        compSymbol='X'
                fi
	fi
	echo " ";echo "Assigned Symbols";echo "Computer: $compSymbol";echo "User: $userSymbol"
}

resetBoard
toss
