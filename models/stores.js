var db = require('../lib/db');

var createStoreSchema = function(){
	db.conn.query(
		'CREATE TABLE Store'+
		'(id INT(11) AUTO_INCREMENT, '+
			'name VARCHAR(255), '+
			'location VARCHAR(255), '+
			'storeNumber MEDIUMINT, '+
			'urlNumber MEDIUMINT, '+
			'city VARCHAR(255), '+
			'PRIMARY KEY (id));', function(err, results) {
		if (err && err.number != db.conn.ERROR_TABLE_EXISTS_ERROR) {
			console.log("ERROR: " + err.message);
			throw err;
		}
		else{
			console.log("Store Table Created and Ready to Go");
		}
	}
	);
};

var addStore = function(name, location, storeNumber, urlNumber, city, callback){
	db.conn.query(
        'INSERT INTO Store'+
        ' SET name = ?'+
        ', location = ?'+
        ', storeNumber = ?'+
        ', urlNumber = ?'+
        ', city = ?',
        [name,location, storeNumber, urlNumber, city],
        function(err, results) {
            if (err) {
				console.log("ERROR: " + err.message);
				throw err;
			}
			else{
           	callback(null, results);
        }
    }
    );	
};

//WE NEED INSERT STORES INTO THE 

//SELECT STORES BASED ON LOCATION


// var tableHasData = function()
// {
//     db.conn.query(
//         'SELECT * FROM table1',
//         function selectCb(err, results, fields) {
//             if (err) {
//                 console.log("ERROR: " + err.message);
//                 throw err;
//             }
//             // console.log("Got "+results.length+" Rows:");
//             console.log(results[0]);
//             console.log(results[0].title);
//             // console.log("The meta data about the columns:");
//             // console.log(fields);
//             conn.end();
//         });
// };

module.exports.createStoreSchema = createStoreSchema;
module.exports.addStore = addStore;