class PagesController < ApplicationController
	def index
		if current_user&.mechanical
			redirect_to fixes_url
		end
	end

	def problems
	end
	
	def help
	end
end
