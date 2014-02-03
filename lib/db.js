// var mongoose = require('mongoose');
// var Schema = mongoose.Schema;
// module.exports.mongoose = mongoose;
// module.exports.Schema = Schema;

// // Connect to cloud database

// var username = "user";
// var password = "sobeys";
// var address = '@ds053858.mongolab.com:53858/projectyawhide';

// var localUsername = "localhost";
// var localPassword = "27017";
// var localAddress = "/projectyawhide";

// connect();
// // Connect to mongo
// function connect() {

//     var url0 = 'mongodb://' + username + ':' + password + address;
//     var url1 = 'mongodb://' + localUsername + ':' + localPassword + localAddress;

//     mongoose.connect(url1);
//     console.log("Database connected!");
// }
// function disconnect() {mongoose.disconnect()}

var mysql = require('mysql');
var Stores = require('../models/stores.js')

var conn = mysql.createConnection({
	host     : 'localhost',
	user     : 'root',
	password : 'yawhidepassword',
});

conn.connect(function(err) {
	if(err){
		console.log("Database Error is: "+ err);
		console.log("If Error is ECONNREFUSED then Run this command: sudo mysqld_safe ");

		//maybe try conn.mysqld_safe???
	}
	else{
		mysql.stop

		conn.query('CREATE DATABASE projectyawhide', function(err, results) {
			if (err && err.number != conn.ERROR_DB_CREATE_EXISTS) {
				console.log("ERROR: " + err.message);
			}
			else{
				conn.query('USE projectyawhide', function(err, results) {
					if (err) {
						console.log("ERROR: " + err.message);
						throw err;
					}else{
						console.log("Database Connected to projectyawhide and Using it!!!!");
						Stores.createStoreSchema();
					}
				});
			}
		});
	}
});

conn.on('error', function() {
	console.log('there was some error and the connection to the database is closing');
	conn.end();
});

module.exports.conn = conn;


