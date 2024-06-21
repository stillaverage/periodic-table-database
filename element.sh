#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -X -t --no-align -c"

MAIN() {
  if [[ $1 ]]
  then
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1;")
    else
      ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';")
    fi
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
      echo $ELEMENT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    echo "Please provide an element as an argument."
  fi
}

MAIN $1
