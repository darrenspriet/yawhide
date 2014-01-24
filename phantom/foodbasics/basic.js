
 var allSelects = $('select').attr('id', 'myNewSelector');
 var cities = [];

 var allSelects = $('select').attr('id', 'myNewSelector');
 $("#myNewSelector option").each(function(){
 	cities.push($(this).val());
 });

 var arrayData=$('<div id="mySecondDiv">'+JSON.stringify(cities)+'</div>');
$('body').append(arrayData);

// console.log($('body').html());
 // var array = [];
 // array = $('body').html();
 // console.log(array);

//  $('body').html().each(function(){
//  	array.push($(this).val());
//  });
//  console.log(array);
