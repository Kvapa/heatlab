#encoding: utf-8
module ApplicationHelper
	def wday_to_name(var)
		wday = {1 => "Pondělí", 2 => "Úterý", 3 => "Středa", 4 => "Čtvrtek", 5 => "Pátek", 6 => "Sobota",
								 0 => "Neděle"}
		wday[var]
	end

	def date_number_to_string(var)
		months = {1 => "Leden", 2 => "Únor", 3 => "Březen", 4 => "Duben", 5 => "Květen", 6 => "Červen",
								 7 => "Červenec", 8 => "Srpen", 9 => "Září", 10 => "Říjen", 11 => "Listopad", 12 => "Prosinec"}
		months[var]
	end 
end
