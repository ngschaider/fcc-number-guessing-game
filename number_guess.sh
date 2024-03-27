#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

RANDOM_NUMBER=$(($RANDOM%1000+1))

echo -e "Enter your username:"
read $USERNAME

DATA=$($PSQL "SELECT username FROM users WHERE username=$USERNAME")

if [[ $DATA ]]
then
  echo "Welcome back, $USERNAME! You have played $NUM_GAMES games, and your best game took $HIGH_SCORE guesses."
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  DATA=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
fi

echo -e "Guess the secret number between 1 and 1000:"
read $GUESS

NUM_TRIES=1

while [[ $RANDOM_NUMBER -ne $GUESS ]]
do
  if [[ $RANDOM_NUMBER -lt $GUESS ]]
  then
    NUM_TRIES=$NUM_TRIES + 1
    echo -e "It's lower than that, guess again:"
    read $GUESS
  fi

  if [[ $RANDOM_NUMBER -gt $GUESS ]]
  then
  NUM_TRIES=$NUM_TRIES + 1
    echo -e "It's higher than that, guess again:"
    read $GUESS
  fi
done

