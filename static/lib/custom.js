$(".add-regra-sef").click(function() {
  $("#regras-sef tr:last").after("<tr><td><input class='input-small' name='registro[]' type='text' /></td><td><input class='input-xxlarge' name='campos[]' type='text' /></td><td><input name='substituir[]' type='text' /></td></tr>");
});

$(".add-regra-edoc").click(function() {
  $("#regras-edoc tr:last").after("<tr><td><input class='input-small' name='registro[]' type='text' /></td><td><input class='input-xxlarge' name='campos[]' type='text' /></td></tr>");
});