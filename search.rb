module Travelport
    class Search < Request
    	attr_reader :result
	    def initialize
	    	super
			@username =  Rails.application.secrets.travelport_username
			@password =  Rails.application.secrets.travelport_password
			@target = Rails.application.secrets.travelport_target
			@provider =  Rails.application.secrets.travelport_provider
			@request_url = "#{@api}/AirService"
	    end

	    def self.test
	    	result = Rails.cache.fetch("travelport-response04", :expires_in => 1.hour) do
	 	    	s = Search.new
		    	s.perform([{from: "CPH", to: "RAK", at: Date.parse("2018-06-09", '%Y-%m-%d')}, {from: "RAK", to: "CPH", at: Date.parse('2018-06-16', '%Y-%m-%d')}], {passengers: [{code:"ADT"}]})
		    	puts s.result
		    	s.result
			end
			Response::AirlowfareParse.new(result)
	    end

	    def self.from_request request
	    	key = "AirService/#{request.session}"
	    	result = $travelport_cache.get(key)
        search_request = Search.new

	    	if result.nil?
		    	legs = []
		    	legs << {from: request.origin, to: request.destination, at: request.in_date}
		    	legs << {from: request.destination, to: request.origin, at: request.out_date}
  				options = {}
  				options[:passengers] = []

  				request.adult.times.each do |variable|
  					options[:passengers] << {code: 'ADT'}
  				end

  				if request.children_number > 0
  					request.occupancies.each do |occupancy|
  						occupancy.infant_ages.each do |variable|
  							options[:passengers] << {code: 'INF', age: 0}
  						end

  						occupancy.children_ages.each do |variable|
  							options[:passengers] << {code: 'CNN', age: 3}
  						end
  					end
  				end


		    	search_request.perform(legs, options)
          result = search_request.result
          $travelport_cache.set(key, result)
				end

        parse = Response::AirlowfareParse.new(result)
        parse.perform

	    end

	    def perform legs, options
	    	@legs = legs
	    	@options = options
			@xml_path = "#{Rails.root}/app/classes/travelport/requests/search.xml.erb"
			@request_body = ERB.new(File.read(@xml_path)).result(binding)
	    	run
	    end

	end
end
