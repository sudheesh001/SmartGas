# all the imports
import os,binascii
from flask import Flask, request, session, g, redirect, url_for, abort, \
		render_template, flash, Blueprint, stream_with_context, Response
from flaskext.mysql import MySQL
from flask_mail import Mail,Message
from config import config, ADMINS, MAIL_SERVER, MAIL_PORT, MAIL_USERNAME, MAIL_PASSWORD, NEXMO_API_KEY, NEXMO_API_SECRET
from werkzeug.utils import secure_filename
from flask import send_from_directory
import datetime
from datetime import timedelta
import logging
from logging.handlers import SMTPHandler
from collections import Counter
import chartkick, requests
import nexmo

client = nexmo.Client(key=NEXMO_API_KEY, secret=NEXMO_API_SECRET)
credentials = None

mysql = MySQL()
# create our little application :)

app = Flask(__name__)

for key in config:
	app.config[key] = config[key]

mail = Mail(app)
# Mail
mail.init_app(app)

if MAIL_USERNAME or MAIL_PASSWORD:
	credentials = (MAIL_USERNAME, MAIL_PASSWORD)
	mail_handler = SMTPHandler((MAIL_SERVER, MAIL_PORT), 'no-reply@' + MAIL_SERVER, ADMINS, 'resetpass', credentials)
	mail_handler.setLevel(logging.ERROR)
	app.logger.addHandler(mail_handler)

mysql.init_app(app)
app.config.from_object(__name__)
ck = Blueprint('ck_page', __name__, static_folder=chartkick.js(), static_url_path='/static')
app.register_blueprint(ck, url_prefix='/ck')
app.jinja_env.add_extension("chartkick.ext.charts")

from api import *

def tup2float(tup):
	return float('.'.join(str(x) for x in tup))

def get_cursor():
	return mysql.connect().cursor()

@app.errorhandler(404)
def page_not_found(e):
	return render_template('404.html'), 404


####### API ENDPOINTS #######

# Device Connectivity APIs for hardware
# API endpoint is validated only by the mobile number of the GSM module on the Device
@app.route('/api/<phone>')
def getCylinderDetails(phone=None):
	if phone != None:
		db = get_cursor()
		phno = phone
		userQuery = 'select sno from Users where phoneNumber="%s"'%phno
		db.execute(userQuery)
		data = db.fetchone()[0]
		# User sno retrieved
		CLOUDQuery = 'select * from CLOUD_Cylinders where UserSno="%s"'%data
		db.execute(CLOUDQuery)
		result = db.fetchall()
		return result
		

####### END API ENDPOINTS ###


@app.route('/')
def screen():
	return render_template('index.html')

@app.route('/register', methods=['GET','POST'])
def register():
	if request.method == "POST":
		db = get_cursor()
		username = request.form['username']
		indexQuery = 'select count(*) from Authentication'
		db.execute(indexQuery)
		value = db.fetchone()[0]
		sno = value + 1
		checkQuery = 'select username from Authentication where username = "%s"'%username
		db.execute(checkQuery)
		data = db.fetchall()
		if not data:
			password = request.form['password']
			confpassword = request.form['confirmpassword']
			usertype = request.form['userType']
			verified = 0
			lastRecovery = datetime.datetime.now()
			if password == confpassword:
				insertQuery = 'insert into Authentication VALUES ("%s","%s","%s","%s","%s","%s")'
				db.execute(insertQuery%(sno, username, password, usertype, verified, lastRecovery))
				userInsertQuery = 'insert into Users (sno,username) VALUES ("%s","%s")'%(sno,username)
				db.execute(userInsertQuery)
				db.execute("COMMIT")
				print "success"
				return redirect(url_for('login'))
			else:
				print "Password didnot match"
				return redirect(url_for('register'))
		else:
			print "Username already exists"
			return redirect(url_for('register'))
	return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
	global store
	error = None
	db = get_cursor()
	session['temp'] = 0
	if request.method == 'POST':
		uname = str(request.form['username'])
		password = str(request.form['password'])
		sql = 'select count(*) from Authentication where username="%s" AND password="%s"'%(uname, password)
		db.execute(sql)
		result = db.fetchone()[0]
		if not result:
			error = "Invalid Username / Password"
		else:
			session['logged_in'] = True
			sql = 'select userType from Authentication where username="%s" AND password="%s"'%(uname, password)
			db.execute(sql)
			result = db.fetchone()[0]
			session['temp'] = result
			sql = 'select sno from Authentication where username="%s" AND password="%s"'%(uname, password)
			db.execute(sql)
			uid = db.fetchone()[0]
			db.execute("COMMIT")
			app.config['USERNAME'] = uname
			app.config['USERID'] = uid
			dataPresence = 'select firstName from Users where username="%s"'%(uname)
			db.execute(dataPresence)
			checkValues = db.fetchone()[0]
			if checkValues:
				return redirect(url_for('dashboard'))
			return redirect(url_for('editprofile'))
	return render_template('login.html')

@app.route('/dashboard')
def dashboard():
	db = get_cursor()
	sno = app.config['USERID']
	# Logged in  Index value
	print 'Dashboard: '+ sno
	CLOUDQuery = 'select * from CLOUD_Cylinders where userSno = "%s"'
	db.execute(CLOUDQuery%sno)
	res = db.fetchall()
	db.execute("COMMIT")
	cloudObject = {}
	cloudObject['userSno'] = 0
	cloudObject['CompanyId'] = 0
	cloudObject['cylinderId'] = 0
	cloudObject['netWeight'] = 1
	cloudObject['grossWeight'] = 0
	cloudObject['dateOfFilling'] = 0
	if res:
		cloudObject = {}
		cloudObject['userSno'] = res[0][0]
		cloudObject['CompanyId'] = res[0][1]
		cloudObject['cylinderId'] = res[0][2]
		cloudObject['netWeight'] = res[0][3]
		cloudObject['grossWeight'] = res[0][4]
		cloudObject['dateOfFilling'] = res[0][5]
		# Populate Local Gas Objects
		curDate = res[0][5]
		EndDate = curDate + timedelta(days=10)
		autoRebook = "1"
		EXPCompletionDate = EndDate + timedelta(days = 2)
		LOCALQuery = 'insert into LOCAL_GasCylinder values ("%s","%s","%s","%s","%s","%s","%s","%s","%s")'
		db.execute(LOCALQuery%(sno, cloudObject['cylinderId'], 30, cloudObject['netWeight'], cloudObject['grossWeight'], cloudObject['grossWeight'], EndDate, EXPCompletionDate, autoRebook))
		db.execute("COMMIT")
	return render_template('dashboard.html', cylinderDetails = cloudObject)

@app.route('/enterprise')
def enterprise():
	return render_template('enterprise.html')

@app.route('/enterpriseprofile')
def enterpriseprofile():
	return render_template('enterpriseprofile.html')

@app.route('/successfullydelivered')
def successfullydelivered():
	return render_template('successDelivery.html')

@app.route('/undelivered')
def undelivered():
	return render_template('undelivered.html')

@app.route('/grid')
def grid():
	# Cylinders in warehouse should take us to Grid
	return render_template('grid.html')

@app.route('/invoice')
def invoice():
	return render_template('invoice.html')

@app.route('/invoices')
def invoices():
	# Shows the list of invoices of previous purchases as a table
	return render_template('invoices.html')

@app.route('/profile')
def profile():
	return render_template('profile.html')

@app.route('/approve/<id>', methods=['POST'])
def approve(id=None):
	# Approve the order based on the ID that's being sent
	# Approved or Not
	return 1

@app.route('/shipped', methods=['GET', 'POST'])
def shipped():
	return render_template('shippedItems.djt')

@app.route('/editprofile', methods=['GET', 'POST'])
def editprofile():
	db = get_cursor()
	sno = app.config['USERID']
	userNameQuery = 'select * from Authentication where username="%s"'%app.config['USERNAME']
	db.execute(userNameQuery)
	userData = db.fetchone()[0]
	print userData
	if request.method == 'POST':
		fname = request.form['fname']
		lname = request.form['lname']
		uemail = request.form['email']
		phno = request.form['phoneno']
		pancard = request.form['pancard']
		aadharcard = request.form['aadharcard']
		companyAff = request.form['companyAffiliation']
		currentQty = request.form['currentQuantity']
		gasAgencyAff = request.form['gasCompanyAffiliation']
		addr1 = request.form['addressLineOne']
		addr2 = request.form['addressLineTwo']
		addr3 = request.form['city']
		addr4 = request.form['state']
		addr5 = request.form['zipcode']
		country = request.form['country']
		addr = addr1 + '|' + addr2 + '|' + addr3 + '|' + addr4 + '|' + addr5 + '|' + country
		sql = 'update Users set firstName="%s", lastName="%s", userEmail="%s", addressDetails="%s", aadharCardNo="%s", PANCardNo="%s", companyAffiliation="%s", currentQuantity="%s", gasAgencyAffiliation="%s", phoneNumber="%s" where username="%s"'
		db.execute(sql%(fname, lname, uemail, addr, aadharcard, pancard, companyAff, currentQty, gasAgencyAff, phno, app.config['USERNAME']))
		db.execute("COMMIT")
		client.send_message({'from': 'SmartGas', 'to': '91'+phno, 'text': 'Thank You, You have been successfully registered.'})
		return redirect(url_for('dashboard'))
	return render_template('editprofile.html', username = app.config['USERNAME'])

@app.teardown_appcontext
def close_db():
	"""Closes the database again at the end of the request."""
	get_cursor().close()

@app.route('/logout')
def logout():
	if session['logged_in'] != None:
		if session['logged_in']==True:
			session.pop('logged_in', None)
			session.pop('temp',0)
	return redirect(url_for('login'))#show_entries.html

if __name__ == '__main__':
	app.debug = True
	app.secret_key=os.urandom(24)
	# app.permanent_session_lifetime = datetime.timedelta(seconds=200)
	app.run()