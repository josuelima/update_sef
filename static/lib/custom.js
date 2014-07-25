$(".add-regra-sped").click(function() {
  $("#regras-sped-1 tr:last").after("<tr><td><input class='input-small' name='registro[]' type='text' /></td><td><input class='input-small' name='campo[]' type='text' /></td><td><select class='input-small' name='regra[]'><option value='='>=</option><option value='!='>!=</option><option value='<'><</option><option value='>'>></option></select></td><td><input class='input-large' name='filtro[]' type='text' /></td><td><input class='input-medium' name='campo_sub[]' type='text' /></td><td><input class='input-large' name='substituir[]' type='text' /></td></tr>");
});

$(".add-regra2-sped").click(function() {
  $("#regras-sped-2 tr:last").after("<tr><td><input class='input-small' name='linha[]' type='text' /></td><td><input class='input-small' name='campo_rule_2[]' type='text' /></td><td><input class='input-xxlarge' name='substituir_2[]' type='text' /></td></tr>");
});