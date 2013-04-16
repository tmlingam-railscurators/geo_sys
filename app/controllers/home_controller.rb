class HomeController < ApplicationController
	
	def index
		
	end
	
	def import_data
		
		file=params[:file]
		
		#~ if file.present? && file.content_type =="text/csv" 
		ReverseGeocode.deposit(file)
		redirect_to root_url, notice: "Data imported succesfully..!"
		#~ else
			#~ redirect_to root_url, notice: "Error in processing..!"
		#~ end
		
		
	end
	
	
end
