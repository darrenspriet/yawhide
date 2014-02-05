var mongoose = require('mongoose');
var Schema = mongoose.Schema;
module.exports.mongoose = mongoose;
module.exports.Schema = Schema;

//openshift
var usernameO = "admin";
var passwordO = "1XTDF3AHtyZR";
var addressO = '@52f176ec50044610ce000355-thegreat.rhcloud.com:55141/';

var username = "user";
var password = "sobeys";
var address = '@ds053858.mongolab.com:53858/projectyawhide';

var localUsername = "localhost";
var localPassword = "27017";
var localAddress = "/projectyawhide";

connect();
// Connect to mongo
function connect() {
	var url2 = 'mongodb://' + usernameO	+ ':' + passwordO + addressO;
    var url0 = 'mongodb://' + username + ':' + password + address;
    var url1 = 'mongodb://' + localUsername + ':' + localPassword + localAddress;

    mongoose.connect(url2);
    console.log("Database connected!");
}
function disconnect() {mongoose.disconnect()}