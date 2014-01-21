
var startParseOfAddresses = function(){
var page = new WebPage(), testindex = 0, loadInProgress = false;

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

page.onLoadStarted = function() {
  loadInProgress = true;
  console.log("load started");
};

page.onLoadFinished = function() {
  loadInProgress = false;
  console.log("load finished");
  page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js');
};


var steps = [
  function() {
    //Load Login Page
    page.open("http://www.foodbasics.ca/en/find-your-food-basics.html");

  },
  function() {
    //Manipulate the page if needed!!!!!
    page.evaluate(function() {
      $("select[name='town'] option").each(function(){
          console.log($(this).val());
        });
      $("input[name='searchMode']").attr('value', 'town');
      $('select[name="town"], option[value="Ancaster"]').attr('selected','selected');
      $("button, input[type='submit']").attr('id', 'buttonForm');

    });
  }, 
  function() {
    //Login
    page.evaluate(function() {
      //Click the form
       $( "#buttonForm" ).click();

    });
  }, 
  function() {
    // Output content of page to stdout after form has been submitted
    page.evaluate(function() {
       console.log(document.querySelectorAll('html')[0].outerHTML);
    });
  }
];

interval = setInterval(function() {
  if (!loadInProgress && typeof steps[testindex] == "function") {
    console.log("step " + (testindex + 1));
    steps[testindex]();
    testindex++;
  }
  if (typeof steps[testindex] != "function") {
    console.log("test complete!");
    phantom.exit();
  }
}, 250);
};


startParseOfAddresses();
