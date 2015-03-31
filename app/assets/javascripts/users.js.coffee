# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$(document).ready () ->
		if $('.contract option:selected').val() is '1' 
			$('.contract_end').hide()	
		else
			$('.contract_end').show()	

	$('#user_decree50_proper').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]

	$('#user_contract_end_proper').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]

	$('#user_retire_proper').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]

	$('#user_rider_proper').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]	

	$('#user_birthday_proper').datepicker
		changeMonth: true
		changeYear: true
		dateFormat: 'dd.mm.yy'
		firstDay: 1 
		monthNamesShort: [ "Leden", "Únor", "Březen", "Duben", "Květen", "Červen", "Červenec", "Srpen", "Září", "Říjen", "Listopad", "Prosinec" ]
		yearRange: '-100:+0'	

	if $('.contract option:selected').val() is '0' 
		$('.contract_end').hide()

	$('.contract').change ->
		if $('.contract option:selected').val() is '0'
			$('.contract_end').show()
		else
			$('.contract_end').hide()	