require "rubygems"
require "geocoder"
require 'mysql2'
require "csv"
require 'optparse'
require 'logger'
require 'active_record'

client= Mysql2::Client.new(:host => "localhost", :username => "root", :password=>"root",:database=>"geo_development")
Geocoder::Configuration.lookup = :nominatim
Geocoder::Configuration.timeout = 20
Geocoder::Configuration.language = :en
#~ Geocoding API's response was not valid JSON. FOR geocoder_ca
Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
$logger = Logger.new("#{File.dirname(__FILE__)}/logs/geo_process.log", 'weekly')
#~ $logger.level = Logger::DEBUG
$logger.formatter = Logger::Formatter.new
 
		while true do 
		client.query("select * from reverse_geocodes where (is_started = 0 and is_processed is false and error_message is NULL) ORDER BY id ASC limit 1 ").each_with_index do |set,ind|
		#~ client.query("select * from reverse_geocodes where id = 100 ").each_with_index do |set,ind|
		begin

			puts "started processing #{ind} =  #{set["latitude"]},#{set["longitude"]} ------------ #{Time.now}"
			client.query("UPDATE `geo_development`.`reverse_geocodes` SET `is_started` = '1' WHERE `reverse_geocodes`.`id` =#{set["id"]}")
			res = Geocoder.search( "#{set["latitude"]},#{set["longitude"]}") 
			#~ puts res.inspect
			
			#~ if !res.empty?
			if res[0].address
				address = res[0].address.empty? ? "no data" : res[0].address
			else
				address  = "no data"
			end
			if res[0].city
				city = res[0].city.empty? ? "no data" : res[0].city
			else
				city = "no data"
			end	
			if res[0].state
				state = res[0].state.empty? ? "no data" : res[0].state
			else
				state = "no data"
			end

			if res[0].country
				country = res[0].country.empty? ? "no data" : res[0].country
				if  country == "United States of America"
					country ="United States"
				else
					country = country
				end
			else
				country = "no data"
			end
				

				client.query("UPDATE `geo_development`.`reverse_geocodes` SET `address` = '#{address}',`city` = '#{city}',`state` = '#{state}',`country` = '#{country}' , `is_processed` = '1' WHERE `reverse_geocodes`.`id` =#{set["id"]}")
			#~ else
		 #~ puts "elseee"
				#~ address = "no data"	
				#~ city = "no data"	
				#~ state = "no data"	
				#~ country = "no data"	
				#~ client.query("UPDATE `US_GEOCODER`.`reverse_geocodes` SET `address` = '#{address}',`city` = '#{city}',`state` = '#{state}',`country` = '#{country}' , `is_processed` = '1' ,`error_message` = 'error' WHERE `reverse_geocodes`.`id` =#{set["id"]}")
			#~ end

		rescue Exception => e
		sleep 10
		$logger.info 'rescue'
		$logger.info e.message.inspect
	
				address = "no data"	
				city = "no data"	
				state = "no data"	
				country = "no data" 
				client.query("UPDATE `geo_development`.`reverse_geocodes` SET `address` = '#{address}',`city` = '#{city}',`state` = '#{state}',`country` = '#{country}' , `is_processed` = '1' , `error_message` = 'error' WHERE `reverse_geocodes`.`id` =#{set["id"]}")
		end

		end
		end
		client.close()



#~ s = Geocoder.search( "61.275689,-149.787651") 