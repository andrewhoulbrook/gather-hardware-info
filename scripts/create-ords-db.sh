#!/bin/bash
# Script to create a sqlite database to hold device data in ORDS format

sqlite3 "${1}" "CREATE TABLE devices (id TEXT NOT NULL PRIMARY KEY, product_category TEXT, product_brand TEXT, product_model TEXT, manufacture_date INT);"

echo ""
echo -e "${GREEN}Created new database techcycle.sqlite to store repair data"
echo ""
