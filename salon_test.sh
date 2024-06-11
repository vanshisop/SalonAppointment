#! /bin/bash
PSQL='psql --username=freecodecamp --dbname=salon --tuples-only -c'

echo -e "\nWelcome to our Great Flips\n"

echo -e "\nHere is a list of all the services we have available\n"
echo -e "\nPlease make a selection of the service you would like\n"



SELECT_SERVICE() {

  if [[ $1 ]]
    then echo -e "\n$1\n"
  fi
  
  SERVICES=$($PSQL "SELECT * FROM SERVICES")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  # read the service type
  
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
  SELECT_SERVICE "Please make a valid numberical seleciton(1-17)"
  elif [[ $SERVICE_ID_SELECTED -lt 1 ]] || [[ $SERVICE_ID_SELECTED -gt 11 ]]
  then
    SELECT_SERVICE "Please select a service in valid range"
  else 
     SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nYou have chosen$SERVICE"
    echo -e "\nPlease enter your 10 digit phone number to proceed with the appointment"
    read CUSTOMER_PHONE
    if [[ ! $CUSTOMER_PHONE =~ ^[0-9]{10}$ ]]
    then
      SELECT_SERVICE $SERVICE_ID_SELECTED "Sorry, this is not a valid phone number"
    else 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
    echo -e "\nThank you being a first time customer. Could we have your name please?"
    read CUSTOMER_NAME
    ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    echo -e "\nI have put you down for a $SERVICE at $TIME, $CUSTOMER_NAME"
    fi
    
  fi
  fi


}


SELECT_SERVICE
