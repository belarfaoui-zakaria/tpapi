module Travelport::Response

		class AirlowfareParse

			attr_accessor :flightDetailsList,
			:airSegmentList,
			:fareInfoList,
			:airPricePointList,
			:brandList,
			:routeList

		    def initialize xml
					response = Hash.from_xml(xml)
					body = response["Envelope"]["Body"]["LowFareSearchRsp"]

					@flightDetailsList = Hash[body["FlightDetailsList"]["FlightDetails"].map { |e| [e['Key'], e] }]
					@airSegmentList = Hash[body["AirSegmentList"]["AirSegment"].map { |e| [e['Key'], e] }]
					# @fareInfoList = Hash[body["FareInfoList"]["FareInfo"].map { |e| [e['Key'], e] }]
					@airPricePointList = Hash[body["AirPricePointList"]["AirPricePoint"].map { |e| [e['Key'], e] }]
					# @brandList = Hash[body["BrandList"]["Brand"].map { |e| [e['Key'], e] }]
					# @routeList = body["RouteList"]["Route"]
		    end

		    def perform
		    	@result = @airPricePointList.values.map { |f|
		    		Trip.new f, self
			    }
		    end



		end


end
