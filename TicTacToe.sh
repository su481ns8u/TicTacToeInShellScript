#!/bin/bash -x

echo "<-+-+-+-Welcome to Tic Tac Toe-+-+-+->"

declare -A positions

function resetBoard(){
        for ((i=1; i<=9; i++))
        do
                positions[$i]=$i
        done
        echo "Board Reseted !"
        board
}

function board(){
        printf "+---+---+---+\n"
        printf "| ${positions[1]} | ${positions[2]} | ${positions[3]} |\n"
        printf "+---+---+---+\n"
        printf "| ${positions[4]} | ${positions[5]} | ${positions[6]} |\n"
        printf "+---+---+---+\n"
        printf "| ${positions[7]} | ${positions[8]} | ${positions[9]} |\n"
        printf "+---+---+---+\n"
}

function toss(){
        tossRes=$((RANDOM%2))
        if [ $tossRes -eq 1 ]
        then
                currPlay=0
                echo "Computer Won Toss"
                symbol=$((RANDOM%2))
                if [ $symbol -eq 1 ]
                then
                        compSymbol=X
                        userSymbol=O
                else
                        compSymbol=O
                        userSymbol=X
                fi
        else
                currPlay=1
                echo "User won toss"
                read -p "Enter 1 for 'X' symbol and 2 for 'O' symbol: " symbol
                if [ $symbol -eq 1 ]
                then
                        userSymbol=X
                        compSymbol=O
                else
                        userSymbol=O
                        compSymbol=X
                fi
        fi
        echo " ";echo "Assigned Symbols";echo "Computer: $compSymbol";echo "User: $userSymbol"
}

function whoWon(){
        if [ $currPlay -eq 0 ]
        then
                compWinFlag=1
        else
                userWinFlag=1
        fi
        endFlag=1
}

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
                echo "The game is tie !!!"
                endFlag=1
        fi
}

function play(){
        resetBoard
        toss
        endFlag=0
        compWinFlag=0
        userWinFlag=0
        while [ $endFlag -ne 1 ]
        do
                board
                if [ $currPlay -eq 1 ]
                then
                        userPlay
                        checkWin
                        currPlay=0
                else
                        compPlay
                        checkWin
                        currPlay=1
                fi

                if [[ $compWinFlag == 1 ]]
                then
                    board
                    echo "Computer Won !!!"
                elif [[ $userWinFlag == 1 ]]
                then
                    board
                    echo "User Won !!!"
                fi
        done
}

function userPlay(){
        local choice
        read -p "Enter position you want to add $userSymbol: " choice
        while [ $((${positions["$choice"]})) -eq $(($compSymbol)) -o $((${positions["$choice"]})) -eq $(($userSymbol)) ]
        do
                echo "Place already taken chose another one"
                read -p "Enter position you want to add $userSymbol: " choice
        done
        positions["$choice"]=$userSymbol
}

function compPlay(){
        local choice
        posChange=0
        checkCompWin
        if [[ $posChange == 0 ]]
        then
                checkUserWin
        fi
        if [[ $posChange == 0 ]]
        then
                getCorner
        fi
        if [[ $posChange == 0 ]]
        then
                getCenter
        fi
        if [[ $posChange == 0 ]]
        then
                getRandom
        fi
}

function checkCompWin(){
        i=1
        j=1
        while [ $i -le 9 -a $j -le 9 ]
        do
                if [[ ${positions[$i]} == $i ]]
                then
                        positions[$i]=$compSymbol
                        checkWin
                        if [[ $compWinFlag == 1 ]]
                        then
                                echo "Entered Comp"
                                posChange=1
                                compWinFlag=0
                                echo "Computer Chose: $i"
                                break
                        else
                                positions[$i]=$i
                        fi
                fi
        i=$((i+1))
        j=$((j+1))
        done
}

function checkUserWin(){
        i=1
        j=1
        while [ $i -le 9 -a $j -le 9 ]
        do
                if [[ ${positions[$i]} == $i ]]
                then
                        positions[$i]=$userSymbol
                        checkWin
                        if [[ $userWinFlag == 1 ]]
                        then
                                echo "Entered user"
                                posChange=1
                                compWinFlag=0
                                userWinFlag=0
                                positions[$i]=$compSymbol
                                break
                        else
                                positions[$i]=$i
                        fi
                fi
        i=$((i+1))
        j=$((j+1))
        done
}

function getCorner(){
        for ((i=1; i<=9; i=$((i+2))))
        do
                if [[ $i = 5 ]]
                then
                        continue
                else
                        if [[ ${positions[$i]} == $i ]]
                        then
                                echo $compWinFlag
                                checkWin
                                posChange=1
                                positions[$i]=$compSymbol
                                compWinFlag=0
                                break
                        fi
                fi
        done
}

function getCenter(){
        if [[ ${positions[5]} == 5 ]]
        then
                checkWin
                compWinFlag=0
                posChange=1
                positions[5]=$compSymbol
                break
        fi
}

function getRandom(){
        choice=$(($(($RANDOM % ${#positions[@]}))))
        while [[ ${positions[$choice]} == $userSymbol && ${positions[$choice]} == $userSymbol ]]
        do
                choice=$(($(($RANDOM % ${#positions[@]})) + 1))
                break
        done
        echo "Computer chose $choice"
        echo "Entered print"
        positions[$choice]=$compSymbol
        board
}

play
