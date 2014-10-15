#encoding: utf-8
class Events2Controller < ApplicationController
	before_filter :authorize
	
	def index
		@events = Event.order("day ASC")
	end

	def xls
		@events = Event.order("day ASC")
		@events=@events.where("project_id IN (?)",params[:projects]) if !params[:projects].blank? 
 		@events=@events.where("day >= ?",params[:from]) if !params[:from].blank? 
 		@events=@events.where("day <= ?",params[:until]) if !params[:until].blank?

 		require 'spreadsheet'
      	Spreadsheet.client_encoding = 'UTF-8'    
     
        book = Spreadsheet.open 'public/events.xls'
      	sheet = book.worksheet 0

      	sheet[0, 0]="Od"
      	sheet[0, 1]="Do"
      	sheet[0, 2]="Název projektu"
      	sheet[0, 3]="Název akce"
      	sheet[0, 4]="Popis akce"
      	sheet[0, 5]="Účastníci"

      	@events.each_with_index do |event,i| 
      		sheet[i+1, 0] = event.day.strftime("%d.%m.%Y")
      		sheet[i+1, 1] = event.date_until.strftime("%d.%m.%Y")
      		sheet[i+1, 2] = Project.find(event.project_id).workname	
      		sheet[i+1, 3] = event.name
      		sheet[i+1, 4] = event.description

      		users=""
      		event.users.each do |user|
          		users += user.sur_firstname + ", "
          	end

          	sheet[i+1, 5] = users[0..-3]

      	end
      	book.write 'public/events-cache.xls'
      	send_file 'public/events-cache.xls', :type => "application/vnd.ms-excel",:filename => "akce.xls", :stream => false    
	end
end
