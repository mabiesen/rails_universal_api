document.addEventListener("turbolinks:load", () => {
 function download(filename, text) {
   var element = document.createElement('a');
   element.setAttribute('href', 'data:text/json;charset=utf-8,' + encodeURIComponent(text));
   element.setAttribute('download', filename);

   element.style.display = 'none';
   document.body.appendChild(element);

   element.click();

   document.body.removeChild(element);
  }

  $("#download_endpoint_output").on('click', function(event){
    var output_text = $('#output').text();
    var now = new Date();
    var time_string = now.toLocaleString().replace(",","").replace(/:.. /," ").replaceAll('/','_').replaceAll(' ','_');
    download('output' + time_string + '.json',output_text);
  });
});
