PORT=2003
SERVER=localhost
echo "diceroll $RANDOM `date +%s`" | nc ${SERVER} ${PORT}
