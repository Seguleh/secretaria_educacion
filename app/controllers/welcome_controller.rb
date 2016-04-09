class WelcomeController < ApplicationController

	def index
		@datab = User.all()
	end

end
