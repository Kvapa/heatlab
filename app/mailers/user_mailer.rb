class UserMailer < ActionMailer::Base
	default :from => "info@heatlab.cz"
	def birthday(users1,users2)
		@users1=users1
		@users2=users2
		mail to: "kvapil@fme.vutbr.cz,vetesnikova@fme.vutbr.cz,sikorova@fme.vutbr.cz", subject: "Narozeniny"
		# mail to: "kvapil@fme.vutbr.cz", subject: "Narozeniny"
	end
end