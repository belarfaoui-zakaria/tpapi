module Travelport::Response



		class Trip

			attr_accessor :id, :amount, :sell_price, :aller, :retour, :travels, :sell_amount

		    def initialize trip, parser

		      pricing = trip["AirPricingInfo"]
		      @key = trip['Key']
		      @travels = pricing['FlightOptionsList']['FlightOption'].map { |e|
		      	Travel.new(e, parser)
		      }
		      @amount = pricing['TotalPrice'].gsub(/[a-zA-Z]/, '').to_f
		      @sell_amount = @amount * 1.15
		      @aller = @travels.first
		      @retour = @travels.last
		    end


		    def id
		    	@key
		    end

		    def provider
		      "travelport"
		    end


		    def flight_code
		      [].tap do |array|
		        array << @aller.segments.map(&:flight_code)
		        array << @retour.segments.map(&:flight_code)
		      end
		    end

		    def direct
		      @aller.direct && @retour.direct
		    end

		    def duration
		      (@aller.duration+@retour.duration).to_i
		    end
		end
 
end
