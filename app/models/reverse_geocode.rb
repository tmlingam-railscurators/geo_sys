class ReverseGeocode < ActiveRecord::Base
	attr_accessible :is_started, :latitude, :longitude, :address, :city, :state, :country, :is_processed, :errors
	
	def self.deposit(file)
		rg_array=[]
		CSV.foreach(file.path, headers: true) do |row|			
			rg_array << ReverseGeocode.new(:latitude=>row[0],:longitude=>row[1])
		end 
		ReverseGeocode.import rg_array
	end
	
end
