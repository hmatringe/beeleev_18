function insertAtCursor(myField, myValue) {
	//IE support
	if (document.selection) {
		myField.focus();
		sel = document.selection.createRange();
		sel.text = myValue;
	}
	//MOZILLA/NETSCAPE support
	else if (myField.selectionStart || myField.selectionStart == '0') {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		myField.value = myField.value.substring(0, startPos)
		+ myValue + '\n'
		+ myField.value.substring(endPos, myField.value.length);
	} else {
		myField.value += myValue;
	}
}
$(document).ready(function() {
  $(window).keydown(function(event){
    if($('#connection_request_description').length && event.keyCode == 13) {
			var field = document.getElementById('connection_request_description');
			insertAtCursor(field, "");
      event.preventDefault();      
      return false;
    }
  });
});

