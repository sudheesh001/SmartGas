Smart Gas Systems
=================

#### Installation Procedure

1. `cp config-temp.py config.py`
2. `virtualenv venv`
3. `source venv/bin/activate`
4. `pip install -r requirements.txt`

Edit the contents of the config.py file and dump the database SQL file into MySQL database

`mysql -u..... -p SmartGas < smart_gas.sql`

Prior to this step you have to create a blank database `SmartGas`.
