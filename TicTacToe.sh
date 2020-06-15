#!/bin/bash

printf "<--+--+--+--Welcome To Tic Tac Toe--+--+--+-->\n"

#ARRAY DECLARATION
declare -A positions

#VARIABLES
ARRAY_LIMIT=9
SYMBOL_1=X
SYMBOL_2=O
TOSS_LIM=2
TOSS_WIN=1
TOSS_LOSE=0
COMP_TURN=1
USER_TURN=2
START=0
END=1
WIN=1
LOSE=0
MOVE=1
STABLE=0
CENTER=5

#CONSTANTS
compSymbol=''
userSymbol=''
currentTurn=0
endGameFlag=$START
compWinFlag=$LOSE
userWinFlag=$LOSE
position=$STABLE
userScore=0
computerScore=0

#FUNCTION TO RESET BOARD
function resetBoard() {
    local i=0
    for ((i=1; i<=$ARRAY_LIMIT; i++))
    do
		positions[$i]=$i
    done
}

#FUNCTION TO DISPLAY BOARD
function displayBoard(){
	local i=0
	printf "\n+---+---+---+\n|"
	for ((i=1; i<=$ARRAY_LIMIT; i++))
	do
		printf " ${positions[$i]} |"
		if [[ $((i%3)) == 0 ]]
		then	
			printf "\n+---+---+---+\n"
			if [[ $i != 9 ]]
			then
				printf "|"
			fi
		fi
	done
}

#FUNCTION TO TOSS AND CHOOSE SYMBOLS AND DECIDE WHO PLAYS FIRST
function toss(){
	local tossResult=$((RANDOM%TOSS_LIM))
	case $tossResult in
		$TOSS_WIN)
			currentTurn=$COMP_TURN
			printf "\nComputer Won Toss !\n"
			compChoice=$((RANDOM%TOSS_LIM))
			case $compChoice in
				$TOSS_WIN)
					compSymbol=$SYMBOL_1
					userSymbol=$SYMBOL_2
					;;
				$TOSS_LOSE)
					compSymbol=$SYMBOL_2
					userSymbol=$SYMBOL_1
					;;
				esac
			;;
		$TOSS_LOSE)
			currentTurn=$USER_TURN
			printf "\nUser Won Toss !\n"
			local flag=0 
			while [[ $flag == 0 ]]
			do
				printf "\nChoose your symbol\n1. X\n2. O\n"
				read -p "Choice: " choice
				case $choice in
					1)
						userSymbol=$SYMBOL_1
						compSymbol=$SYMBOL_2
						flag=1
						;;
					2)
						userSymbol=$SYMBOL_2
						compSymbol=$SYMBOL_1
						flag=1
						;;
					*)
						printf "\nEnter the valid choice !"
						flag=0
						;;
				esac
			done
			;;
	esac
	printf "\nAssigned Symbols are\nComputer: $compSymbol\nUser:     $userSymbol"
}

#FUNCTION TO PLAY USER TURN
function userTurn() {
	local choice=0
    read -p "Enter position you want to add $userSymbol: " choice
    while [[ ${positions[$choice]} != $choice ]]
    do
        printf "\n\nPlace already taken chose another one\n"
		read -p "Enter position you want to add $userSymbol: " choice
    done
    positions[$choice]=$userSymbol
}

#FUNCTION TO PLAY COMPUTER TURN
function computerTurn(){
	position=$STABLE
	if [[ $position == $STABLE ]]
	then
		canWin $compSymbol
	fi
	if [[ $position == $STABLE ]]
	then
		canWin $userSymbol
	fi
	if [[ $position == $STABLE ]]
	then
		canCorner
	fi
	if [[ $position == $STABLE ]]
	then
		canCenter
	fi
	if [[ $position == $STABLE ]]
	then
		canRemaining
	fi
}

#FUNCTION TO CHECK IF ANYONE CAN WIN
function canWin(){
	local i=1
	while [[ $i -le $ARRAY_LIMIT ]]
	do
		if [[ ${positions[$i]} == $i ]]
		then
			positions[$i]=$1
			checkWin
			if [[ $compWinFlag == $WIN ]]
			then
				compWinFlag=$LOSE
				position=$MOVE
				positions[$i]=$compSymbol
				endGameFlag=$START
				printf "\nComputer Choose: $i"
				break
			else
				positions[$i]=$i
			fi
		fi
		i=$((i+1))
	done
}

#FUNCTION TO CHECK IF ANY CORNERS ARE AVAILABLE
function canCorner(){
	local i=0
	for ((i=1; i<=$ARRAY_LIMIT; i=i+2))
	do
		if [[ $i == $CENTER ]]
		then
			continue
		elif [[ ${positions[$i]} == $i ]]
		then
			printf "\nComputer Chose: $i"
			position=$MOVE
			positions[$i]=$compSymbol
			break
		fi
	done
}

#FUNCTION TO CHECK IF CENTER IS AVAILABLE
function canCenter(){
	if [[ ${positions[$CENTER]} == $CENTER ]]
	then
		position=$MOVE
		$positions[$CENTER]=$compSymbol
		printf "\nComputer chose: $i"
	fi
}

#FUNCTION TO ADD AT ANY POSITION IF NOTHING IS AVAILABLE FROM CORNERS AND CENTER
function canRemaining(){
	position=$MOVE
	local choice=$(($((RANDOM%${#positions[@]}))+1))
	while [[ ${positions[$choice]} != $choice ]]
	do
		choice=$(($((RANDOM%${#positions[@]}))+1))
	done
	positions[$choice]=$compSymbol
	printf "\nComputer chose : $choice"
}

#FUNCTION TO CHECK WINNING CONDITIONS
function checkWin(){
    if [[ ${positions[1]} == ${positions[2]} && ${positions[2]} == ${positions[3]} ]]
    then
		whoWon
    elif [[ ${positions[4]} == ${positions[5]} && ${positions[5]} == ${positions[6]} ]]
    then
		whoWon
	elif [[ ${positions[7]} == ${positions[8]} && ${positions[8]} == ${positions[9]} ]]
    then
		whoWon
    elif [[ ${positions[1]} == ${positions[4]} && ${positions[4]} == ${positions[7]} ]]
    then
		whoWon
	elif [[ ${positions[2]} == ${positions[5]} && ${positions[5]} == ${positions[8]} ]]
    then
		whoWon
	elif [[ ${positions[3]} == ${positions[6]} && ${positions[6]} == ${positions[9]} ]]
    then
		whoWon
    elif [[ ${positions[1]} == ${positions[5]} && ${positions[5]} == ${positions[9]} ]]
    then
		whoWon
    elif [[ ${positions[7]} == ${positions[5]} && ${positions[5]} == ${positions[3]} ]]
    then
		whoWon
    elif [[ ${positions[1]} != 1 && ${positions[2]} != 2 && ${positions[3]} != 3 && ${positions[4]} != 4 && ${positions[5]} != 5 && ${positions[6]} != 6 && ${positions[7]} != 7 && ${positions[8]} != 8 && ${positions[9]} != 9 ]]
    then
        printf "\n\nThe game is tie !!!\n"
        endGameFlag=1
    fi
}

#FUNCTION TO CHECK WINNER
function whoWon() {
	if [[ $currentTurn == $COMP_TURN ]]
	then
		compWinFlag=$WIN
	elif [[ $currentTurn == $USER_TURN ]]
	then
		userWinFlag=$WIN
	fi
	endGameFlag=$END
}

#FUNCTION TO DISPLAY CURRENT SCORES
function leaderBoard(){
	printf "\n+------------+------------+"
	printf "\n|    User    |  Computer  |"
	printf "\n+------------+------------+"
	printf "\n|      $userScore     |      $computerScore     |"
	printf "\n+------------+------------+\n"
}

#FUNCTION TO PLAY GAME
function playGame(){
	resetBoard
	toss
	compWinFlag=$LOSE
	userWinFlag=$LOSE
	endGameFlag=$START
	while [[ $endGameFlag != $END ]]
	do
		displayBoard
		if [[ $currentTurn == $COMP_TURN ]]
		then
			computerTurn
			checkWin
		if [[ $endGameFlag == $END && $compWinFlag == $WIN ]]
		then
			printf "\n\nComputer Won !!!\n"
			computerScore=$((computerScore+1))
			break
		fi
		currentTurn=$USER_TURN
		elif [[ $currentTurn == $USER_TURN ]]
		then
			userTurn
			checkWin
			if [[ $endGameFlag == $END && $userWinFlag == $WIN ]]
			then
				printf "\n\nUser Won !!!\n"
				userScore=$((userScore+1))
				break
			fi
			currentTurn=$COMP_TURN
		fi
	done
}

#MAIN
function main() {
	local flag=0
	while [[ $flag != 1 ]]
	do
		printf "\nEnter your choice\n1. Play Game\n2. Display Leader Board\n3. Exit\n"
		read -p "Choice: " choice
		case $choice in
			1)
				playGame
				;;
			2)
				leaderBoard
				;;
			3)
				flag=1
				printf "\n**** Thankyou for playing ****"
				;;
			*)
				printf "\nNot a valid choice !!!"
		esac
	done
}

#CALL MAIN
main

####	ALTERNATIVE FOR CHECK WINNER ####

# function checkWin(){
# 	local chFlag=0
# 	for ((i=1; i<=9; i++))
# 	do
# 		if [[ $i == 1 || $i == 4 || $i == 7 ]]
# 		then
# 			j=$(($i+1))
# 			k=$(($i+2))
# 			if [[ ${positions[$i]} == ${positions[$j]} || ${positions[$i]} == ${positions[$k]} ]]
# 			then 
# 				whoWon
# 			fi
# 		elif [[ $i -le 3 ]]
# 		then
# 			j=$(($i+3))
# 			k=$(($i+6))
# 			if [[ ${positions[$i]} == ${positions[$k]} || ${positions[$i]} == ${positions[$k]} ]]
# 			then 
# 				whoWon
# 			fi
# 		fi
# 	done
# 	if [[ ${positions[1]} == ${positions[5]} && ${positions[5]} == ${positions[9]} ]]
#     then
# 		whoWon
#     elif [[ ${positions[7]} == ${positions[5]} && ${positions[5]} == ${positions[3]} ]]
#     then
# 		whoWon
#     elif [[ ${positions[1]} != 1 && ${positions[2]} != 2 && ${positions[3]} != 3 && ${positions[4]} != 4 && ${positions[5]} != 5 && ${positions[6]} != 6 && ${positions[7]} != 7 && ${positions[8]} != 8 && ${positions[9]} != 9 ]]
#     then
#         printf "\n\nThe game is tie !!!"
#         endGameFlag=1
#     fi
# }
