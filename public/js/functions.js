/**
* Sets the global URL - helpful if the app needs to point to a specific server
* @param {string} - current IP/Server
* @return {string} - formatted URL with current IP/Server
*
*/
function getURL(op){
    //DEPLOYING ON LOCAL MACHINE
    // return "http://192.168.11.54:3000"+op;

    //DEPLOYING ON CTI SERVER (IN HOUSE)
    return ""+op;


}