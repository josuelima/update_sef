$(".add-regra").click(function() {
  $("#regras tr:last").after("<tr><td><input class='input-small' name='registro[]' type='text' /></td><td><input class='input-xxlarge' name='campos[]' type='text' /></td><td><input name='substituir[]' type='text' /></td></tr>");
});