document.addEventListener("turbolinks:load", () => { 

  $("button.params_submit").on('click', function(event){
    event.preventDefault();
    var call_url = $(this).attr('data-callurl');
    var $output = $('#output');
    var form_data = $('form').serialize();

    // clear output box and let user know what we're doing
    $output.text("Fetching data. Time is " + new Date().toLocaleTimeString());

    // no metter, either error or success, we print to the output box 
    //retaining pass/fail convention for ease of troubleshooting
    var response_data = '';
    $.post(call_url, form_data, function(data, status){
      console.log("Endpoint Called. \nResponse Status: " + status);
      response_data = data;
    })
    .fail(function() {
      $output.text(JSON.stringify(response_data, null, 2));
    })
    .done(function() {
      $output.text(JSON.stringify(response_data, null, 2));
    });

    // take  the user to the output
    $("html, body").animate({ scrollTop: $('#output').offset().top }, 1000);
  });

  // this event will trigger the validation of the individual param
  $("input.param_input").on('keyup', function(){
    // input specific detail
    var $this_input = $(this);
    var input_name = $this_input.attr('name');
    var input_text = $this_input.val();
    var param_data_hash = {};
    param_data_hash[input_name] = input_text;

    // form related detail
    var $urlpath_display = $('#urlpath_display');
    var $params_display = $('#params_display');
    var form_data = $('form').serialize();

    // build urls
    var client_tag = $this_input.attr('data-clienttag');
    var request_name = $this_input.attr('data-requestname');
    var validation_url = '/validate_param/' + client_tag + '/' + request_name;
    var build_params_url = '/build_params/' + client_tag + '/' + request_name;
    var build_urlpath_url = '/build_urlpath/' + client_tag + '/' + request_name;
    
    // call to validate individual param, set border color
    $.post(validation_url,param_data_hash, function(data, status){
      console.log("Validating Param. Data success: " + data['success']  + "\nData Error: " + data['error'] + "\nStatus: " + status);
    })
    .fail(function() {
      $this_input.addClass('border-danger');
    })
    .done(function() {
      $this_input.removeClass('border-danger');
    });

    // call to build urlpath, place in appropriate box
    var urlpath_response_data = '';
    $.post(build_urlpath_url, form_data, function(data, status){
      console.log("Building Urlpath. Data success: " + data['success']  + "\nData Error: " + data['error'] + "\nStatus: " + status);
      urlpath_response_data = data;
    })
    .done(function() {
      $urlpath_display.text(urlpath_response_data['success']);
    });

    // call to build params
    var params_response_data = '';
    $.post(build_params_url, form_data, function(data, status){
      console.log("Building Params. Data success: " + data['success']  + "\nData Error: " + data['error'] + "\nStatus: " + status);
      params_response_data = data;
    })
    .done(function() {
      $params_display.text(JSON.stringify(params_response_data['success'], null, 2));
    });

  });
});
