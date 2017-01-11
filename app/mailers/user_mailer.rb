class UserMailer < ActionMailer::Base
	default :from => "info@heatlab.cz"
	def birthday(users1,users2)
		@users1=users1
		@users2=users2
		mail to: "jirikvapil@centrum.cz,vetesnikova@fme.vutbr.cz,Hana.Hodosi@vut.cz", subject: "Narozeniny"
		# mail to: "kvapil@fme.vutbr.cz", subject: "Narozeniny"
	end
end