



var startParseOfAddresses = function(){
  var page = new WebPage()
  , testindex = 0
  , loadInProgress = false
  , keepDocumentOpen = true
  ,fs =require('fs')
  ,loading = 0
 ,currentNumber = 0;


  page.onConsoleMessage = function(msg) {
  //  console.log(msg);
  };

  page.onLoadStarted = function() {
    loadInProgress = true;
   // console.log("2nd load started");
  };

  page.onLoadFinished = function() {
    loading++;
    loadInProgress = false;
   // console.log("2nd load finished");
    page.injectJs('../phantomLibs/jquery-1.10.2.js');
   
    

  //NEED TO WRITE THE CODE THAT WILL PUT THE NUMBER INTO THE DOCUMENT SO THIS WILL KEEP GOING AND INCREENT LOADING
  if(loading % 2 === 0){
    console.log("Got HTML FoodBasics page number: " +currentNumber);
     fs.write('storeDetailPages/'+currentNumber+'.html', page.content, 'w');
  }
  else{
    currentNumber++;
    var innerHTML = '<div id="someSpecialID">'+currentNumber+'</div>';
    var html = "$('body').append('"+innerHTML+"');";
    fs.write('basic.js', html, 'w');
    page.injectJs('basic.js');
    if(currentNumber==65){
      phantom.exit();
    }
  }
};


var steps = [
function() {
    //Do noting in here, do not remove

  },
  function() {
          

    //Manipulate the page if needed!!!!!
    page.evaluate(function() {
      var myElem = document.getElementById('someSpecialID');
      if (myElem != null){
        $("input[name='searchMode']").attr('value', 'town');
        var allSelects = $('select').attr('id', 'myNewSelector');
        var number = $('#someSpecialID').html();
        $("#myNewSelector")[0].selectedIndex = number;
         $("button, input[type='submit']").attr('id', 'buttonForm');
      }

      
    });
  }, 
  function() {
    page.evaluate(function() {
       var myElem = document.getElementById('someSpecialID');
      if (myElem != null){
      $( "#buttonForm" ).click();
    }


    });
  }, 
  function() {
    // Output content of page to stdout after form has been submitted
    page.evaluate(function() {
      // console.log(document.querySelectorAll('html')[0].outerHTML);
    });
  }
  ];
  interval = setInterval(function() {
    if((!loadInProgress)&&(testindex==0)&&(keepDocumentOpen)){
      //console.log('2nd step '+ testindex);
      page.open("http://www.foodbasics.ca/en/find-your-food-basics.html");
      keepDocumentOpen = false;

    }
    if (!loadInProgress && typeof steps[testindex] == "function") {
      //console.log("2nd step " + (testindex + 1));
      steps[testindex]();
      testindex++;
    }
    if (typeof steps[testindex] != "function"){
     // console.log("2nd test complete!");
      testindex = 0;
      loadInProgress=false;
      keepDocumentOpen = true;
      //phantom.exit();
    }

  }, 100);
};




startParseOfAddresses();

