# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#from').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]

	$('#until').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]