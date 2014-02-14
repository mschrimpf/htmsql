#!/bin/bash

usage() {

  echo ''
  echo 'usage: mysql_dbt2_plans.sh [options]'
  echo 'options:'
  echo '--database      <database name (default dbt2)>'
  echo '--output-file   <output file name (default explain.out)>'
  echo '--client-path   <path to mysql client binary (default: /usr/local/mysql/bin)>'
  echo '--socket        <database socket (default use tcp protocol)>'
  echo '--host          <database host (default localhost>'
  echo '--port          <database port (default 3306)>'
  echo '--no-partitions    <Use only EXPLAIN>'
  echo ''
  echo 'Example: sh mysql_dbt2_plans.sh --output-file explain.out'
  echo ''

  if [ "$1" != "" ]; then
    echo ''
    echo "error: $1"
  fi
}

validate_parameter()
{
  if [ "$2" != "$3" ]; then
    usage "wrong argument '$2' for parameter '-$1'"
    exit 1
  fi
}

EXPLAIN="EXPLAIN PARTITIONS"
OUTPUT_FILE="explain.out"
DB_NAME="dbt2"
MYSQL="/usr/local/mysql/bin/mysql"
DB_HOST="localhost"
DB_PORT="3306"

while test $# -gt 0
do
  case $1 in
    --database | -database)
      shift
      DB_NAME=$1
      ;;
    --output-file | --output_file | -output-file | -output_file )
      shift
      OUTPUT_FILE=$1
      ;;
    --socket | -socket )
      shift
      DB_SOCKET=$1
      ;;
    --client-path | --client_path | -client-path | -client_path )
      shift
      MYSQL="$1/mysql"
      ;;
    --no-partitions | --no_partitions | -no-partitions | -no_partitions )
      EXPLAIN="EXPLAIN"
      ;;
    --host | -host )
      shift
      DB_HOST=$1
      ;;
    --port | -port )
      opt=$1
      shift
      DB_PORT=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $DB_PORT
      ;;
    --help | -help | -h | ? | -? )
      usage
      exit 0
      ;;
    * )
      usage "$1 not found"
      exit 1
      ;;
  esac
  shift
done

if [ ! -f "$MYSQL" ]; then
  usage "MySQL client binary '$MYSQL' doesn't exist. Specify correct one using --client-path #"
  exit 1
fi

if [ "x$DB_SOCKET" == "x" ]; then
  MYSQL="$MYSQL --protocol=tcp"
else
  MYSQL="$MYSQL --socket=$DB_SOCKET"
fi

MYSQL="$MYSQL -vvv"
MYSQL="$MYSQL --port $DB_PORT"
MYSQL="$MYSQL --host $DB_HOST"
MYSQL="$MYSQL --database $DB_NAME"

echo "--------------------" > $OUTPUT_FILE
echo "Delivery Transaction" >> $OUTPUT_FILE
echo "--------------------" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT no_o_id FROM new_order WHERE no_w_id = 1 AND no_d_id = 1 ORDER BY no_o_id ASC LIMIT 1 FOR UPDATE;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN DELETE FROM new_order WHERE no_o_id = 1 AND no_w_id = 1 AND no_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT o_c_id FROM orders WHERE o_id = 1 AND o_w_id = 1 AND o_d_id = 1 FOR UPDATE;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE orders SET o_carrier_id = 1 WHERE o_id = 1 AND o_w_id = 1 AND o_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE order_line SET ol_delivery_d = current_timestamp WHERE ol_o_id = 1 AND ol_w_id = 1 AND ol_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT SUM(ol_amount * ol_quantity) FROM order_line WHERE ol_o_id = 1 AND ol_w_id = 1 AND ol_d_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE customer SET c_delivery_cnt = c_delivery_cnt + 1, c_balance = c_balance + 1 WHERE c_id = 1 AND c_w_id = 1 AND c_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

echo "---------------------" >> $OUTPUT_FILE
echo "New-Order Transaction" >> $OUTPUT_FILE
echo "---------------------" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT w_tax FROM warehouse WHERE w_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT d_tax, d_next_o_id FROM district WHERE d_w_id = 1 AND d_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE district SET d_next_o_id = d_next_o_id + 1 WHERE d_w_id = 1 AND d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT c_discount, c_last, c_credit FROM customer WHERE c_w_id = 1 AND c_d_id = 1 AND c_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN INSERT INTO new_order (no_o_id, no_d_id, no_w_id) VALUES (-1, 1, 1);"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN INSERT INTO orders (o_id, o_d_id, o_w_id, o_c_id, o_entry_d, o_carrier_id, o_ol_cnt, o_all_local) VALUES (-1, 1, 1, 1, current_timestamp, NULL, 1, 1);"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT i_price, i_name, i_data FROM item WHERE i_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT s_quantity, s_dist_01, s_data FROM stock WHERE s_i_id = 1 AND s_w_id = 1 FOR UPDATE;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE stock SET s_quantity = s_quantity - 10 WHERE s_i_id = 1 AND s_w_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN INSERT INTO order_line (ol_o_id, ol_d_id, ol_w_id, ol_number, ol_i_id, ol_supply_w_id, ol_delivery_d, ol_quantity, ol_amount, ol_dist_info) VALUES (-1, 1, 1, 1, 1, 1, NULL, 1, 1.0, 'hello kitty');" >> $OUTPUT_FILE
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

echo "------------------------" >> $OUTPUT_FILE
echo "Order-Status Transaction" >> $OUTPUT_FILE
echo "------------------------" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT c_id FROM customer WHERE c_w_id = 1 AND c_d_id = 1 AND c_last = 'BARBARBAR' ORDER BY c_first ASC LIMIT 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT c_first, c_middle, c_last, c_balance FROM customer WHERE c_w_id = 1 AND c_d_id = 1 AND c_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT o_id, o_carrier_id, o_entry_d, o_ol_cnt FROM orders WHERE o_w_id = 1 AND o_d_id = 1 AND o_c_id = 1 ORDER BY o_id DESC LIMIT 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT ol_i_id, ol_supply_w_id, ol_quantity, ol_amount, ol_delivery_d FROM order_line WHERE ol_w_id = 1 AND ol_d_id = 1 AND ol_o_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

echo "-------------------" >> $OUTPUT_FILE
echo "Payment Transaction" >> $OUTPUT_FILE
echo "-------------------" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT w_name, w_street_1, w_street_2, w_city, w_state, w_zip, w_ytd FROM warehouse WHERE w_id = 1 FOR UPDATE;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE warehouse SET w_ytd = w_ytd + 1.0 WHERE w_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT d_name, d_street_1, d_street_2, d_city, d_state, d_zip FROM district WHERE d_id = 1 AND d_w_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE district SET d_ytd = d_ytd + 1.0 WHERE d_id = 1 AND d_w_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT c_id FROM customer WHERE c_w_id = 1 AND c_d_id = 1 AND c_last = 'BARBARBAR' ORDER BY c_first ASC LIMIT 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT c_first, c_middle, c_last, c_street_1, c_street_2, c_city, c_state, c_zip, c_phone, c_since, c_credit, c_credit_lim, c_discount, c_balance, c_data, c_ytd_payment FROM customer WHERE c_w_id = 1 AND c_d_id = 1 AND c_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE customer SET c_balance = c_balance - 1.0, c_ytd_payment = c_ytd_payment + 1 WHERE c_id = 1 AND c_w_id = 1 AND c_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN UPDATE customer SET c_balance = c_balance - 1.0, c_ytd_payment = c_ytd_payment + 1, c_data = 'hello dogger' WHERE c_id = 1 AND c_w_id = 1 AND c_d_id = 1;"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

#SQL="$EXPLAIN INSERT INTO history (h_c_id, h_c_d_id, h_c_w_id, h_d_id, h_w_id, h_date, h_amount, h_data) VALUES (1, 1, 1, 1, 1, current_timestamp, 1.0, 'ab    cd');"
#$MYSQL -e "$SQL" >> $OUTPUT_FILE

echo "-----------------------" >> $OUTPUT_FILE
echo "Stock-Level Transaction" >> $OUTPUT_FILE
echo "-----------------------" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT d_next_o_id FROM district WHERE d_w_id = 1 AND d_id = 1;"
$MYSQL -e "$SQL" >> $OUTPUT_FILE

SQL="$EXPLAIN SELECT count(*) FROM order_line, stock, district WHERE d_id = 1 AND d_w_id = 1 AND d_id = ol_d_id AND d_w_id = ol_w_id AND ol_i_id = s_i_id AND ol_w_id = s_w_id AND s_quantity < 15 AND ol_o_id BETWEEN (1) AND (20);"
$MYSQL -e "$SQL" >> $OUTPUT_FILE
