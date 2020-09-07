document.addEventListener("turbolinks:load", () => { 

  // this event will trigger the validation of the individual param
  $("input").on('keyup', function(){
    var $element = $(this);
    var input_name = $element.attr('name');
    var input_text = $element.val();
    var validation_url = $element.attr('data-validationurl')
    var data_hash = {};
    data_hash[input_name] = input_text;

    $.post(validation_url,data_hash, function(data, status){
      console.log("Data success: " + data['success']  + "\nData Error: " + data['error'] + "\nStatus: " + status);
    })
    .fail(function() {
      $element.addClass('border-danger')
    })
    .done(function() {
      $element.removeClass('border-danger');
    })
  });
});
