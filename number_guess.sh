#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(($RANDOM%1000+1))
echo "Random Number: $RANDOM_NUMBER"

echo -n "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ $USER_ID ]]
then
  DATA=$($PSQL "SELECT COUNT(game_id), MIN(num_tries) FROM games WHERE user_id=$USER_ID")
  IFS=\| read NUM_GAMES HIGH_SCORE <<< $DATA
  echo "Welcome back, $USERNAME! You have played $NUM_GAMES games, and your best game took $HIGH_SCORE guesses."
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  $PSQL "INSERT INTO users (username) VALUES ('$USERNAME')"
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
fi

echo -n "Guess the secret number between 1 and 1000:"
read GUESS
while ! [[ $GUESS =~ ^[0-9]+$ ]]
do
  echo -n "That is not an integer, guess again:"
  read GUESS
done

NUM_TRIES=1

while [[ $RANDOM_NUMBER != $GUESS ]]
do
  if [[ $RANDOM_NUMBER -lt $GUESS ]]
  then
    NUM_TRIES=$(($NUM_TRIES + 1))
    echo -n "It's lower than that, guess again:"
    read GUESS
    while ! [[ $GUESS =~ ^[0-9]+$ ]]
    do
      echo -n "That is not an integer, guess again:"
      read GUESS
    done
  fi

  if [[ $RANDOM_NUMBER -gt $GUESS ]]
  then
    NUM_TRIES=$(($NUM_TRIES + 1))
    echo -n "It's higher than that, guess again:"
    read GUESS
    while ! [[ $GUESS =~ ^[0-9]+$ ]]
    do
      echo -n "That is not an integer, guess again:"
      read GUESS
    done
  fi
done

DATA=$($PSQL "INSERT INTO games (user_id, num_tries) VALUES ($USER_ID, $NUM_TRIES)")

echo "You guessed it in $NUM_TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
