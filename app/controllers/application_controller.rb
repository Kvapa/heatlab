# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

private
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def admin?
		current_user.admin?
	end
	helper_method :admin?

	def authorize
		redirect_to login_url, alert: "Nejste přihlášen/a" if current_user.nil?
	end

	def authorize_admin
		unless admin?
			flash[:error] = "Nepovolený přístup"
			redirect_to login_url
			false
		end
	end

end
