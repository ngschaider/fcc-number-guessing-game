#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(($RANDOM%1000+1))

echo -e "Enter your username:"
read $USERNAME

DATA=$($PSQL "SELECT user_id FROM users WHERE username=$USERNAME")

if [[ $DATA ]]
then
  echo $DATA | while read USER_ID

  DATA=$($PSQL "SELECT COUNT(game_id), MIN(num_tries) FROM games WHERE user_id=$USER_ID")
  echo $DATA | while read NUM_GAMES HIGH_SCORE
  echo "Welcome back, $USERNAME! You have played $NUM_GAMES games, and your best game took $HIGH_SCORE guesses."
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  DATA=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
fi

echo -e "Guess the secret number between 1 and 1000:"
read $GUESS
if ! [[ $GUESS =~ ^[0-9]+$ ]]
then
  echo -e "That is not an integer, guess again:"
  read $GUESS
fi

NUM_TRIES=1

while [[ $RANDOM_NUMBER -ne $GUESS ]]
do
  if [[ $RANDOM_NUMBER -lt $GUESS ]]
  then
    NUM_TRIES=$NUM_TRIES + 1
    echo -e "It's lower than that, guess again:"
    read $GUESS
    if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "That is not an integer, guess again:"
      read $GUESS
    fi
  fi

  if [[ $RANDOM_NUMBER -gt $GUESS ]]
  then
  NUM_TRIES=$NUM_TRIES + 1
    echo -e "It's higher than that, guess again:"
    read $GUESS
    if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "That is not an integer, guess again:"
      read $GUESS
    fi
  fi
done

echo "You guessed it in $NUM_TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
