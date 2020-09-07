document.addEventListener("turbolinks:load", () => { 
  function sendAjaxRequest(method, urlpath, extra_params) {
    var k = null;
    $.ajax({
      type: method.toUpperCase(),
      url: url_path,
      data: jQuery.param(extra_params),
      dataType: 'json',
      success: function(response){
        if(response == 1){
          var k = response;
          console.log(response);
         }
       },
       error: function(response){
         console.log(response); 
       }
    });
  }

  // this event will trigger the validation of the individual param
  $("input").on('focusout', function(){
    console.log($(this).attr['id']);
    // get id of the input

    //get data from the input

    //get name of input

    //get validation url from datatag

    //send the post request, capture response

    //on error set the color of the input to redo

    $.post("demo_test_post.asp",
    {
      name: "Donald Duck",
      city: "Duckburg"
    },
    function(data, status){
      console.log("Data: " + data + "\nStatus: " + status);
    });
  });
});
