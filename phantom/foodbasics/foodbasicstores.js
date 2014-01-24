



var startParseOfAddresses = function(){
  var page = new WebPage()
  , testindex = 0
  , loadInProgress = false
  , keepDocumentOpen = true
  ,fs =require('fs')
  ,loading;


  page.onConsoleMessage = function(msg) {
    console.log(msg);
  };

  page.onLoadStarted = function() {
    loadInProgress = true;
    console.log("2nd load started");
  };

  page.onLoadFinished = function() {
    loading++;
    loadInProgress = false;
    console.log("2nd load finished");
    page.injectJs('../../lib/libsForPhantom/jquery-1.10.2.js');
    page.injectJs('basic.js');

  //NEED TO WRITE THE CODE THAT WILL PUT THE NUMBER INTO THE DOCUMENT SO THIS WILL KEEP GOING AND INCREENT LOADING
  if(loading % 2 === 0){
    fs.write('1.html', page.content, 'w');
  }
  else{
  }
};


var steps = [

function() {
    //Do noting in here, do not remove

  },
  function() {
    //Manipulate the page if needed!!!!!
    page.evaluate(function() {
      var allSelects = $('select').attr('id', 'myNewSelector');
      $("#myNewSelector")[0].selectedIndex = 1;

      $("button, input[type='submit']").attr('id', 'buttonForm');

    });
  }, 
  function() {
    page.evaluate(function() {
      //Click the form
      $( "#buttonForm" ).click();

    });
  }, 
  function() {
    // Output content of page to stdout after form has been submitted
    page.evaluate(function() {
      // console.log(document.querySelectorAll('html')[0].outerHTML);
    });
  }
  ];
// for (int i = 0; i<cities.length; i++){
  interval = setInterval(function() {
    if((!loadInProgress)&&(testindex==0)&&(keepDocumentOpen)){
      console.log('2nd step '+ testindex);
      page.open("http://www.foodbasics.ca/en/find-your-food-basics.html");
      keepDocumentOpen = false;

    }
    if (!loadInProgress && typeof steps[testindex] == "function") {
      console.log("2nd step " + (testindex + 1));
      steps[testindex]();
      testindex++;
    }
    if (typeof steps[testindex] != "function"){
      console.log("2nd test complete!");
      phantom.exit();
    }

  }, 100);
// }

};

startParseOfAddresses();