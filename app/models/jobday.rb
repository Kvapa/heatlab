class Jobday < ActiveRecord::Base
  attr_accessible :day, :day_status, :description, :job_id, :hours, :name_wa, :description_wa
  before_update :test

  def test
  if self.day_status == 0 
  	self.hours =0
  	#self.description =''	
  	end
  end

  def name_wa
    if self.description == nil
      ""
    else
  	  self.description.split("|")[0]
    end
  end
  def description_wa
  	if self.description == nil
      ""
    else
      self.description.split("|")[1]
    end
  end

  def name_wa=(first)
  		first=first.strip
      if self.description == nil
        self.description = [first, ""].join("|")
      else 
    	 self.description = [first, self.description.split("|")[1]].join("|")
      end
   end

  def description_wa=(second)
  	second=second.strip
    
    if self.description == nil
      self.description = ["",second].join("|")
    else 
      self.description = [self.description.split("|")[0], second].join("|")
    end
  end
 
end
