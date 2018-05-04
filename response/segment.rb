# "Key": "WwfeYK3R2BKAkek4IAAAAA==",
# "Group": "0",
# "Carrier": "OS",
# "FlightNumber": "306",
# "Origin": "CPH",
# "Destination": "VIE",
# "DepartureTime": "2018-05-01T20:05:00.000+02:00",
# "ArrivalTime": "2018-05-01T21:50:00.000+02:00",
# "FlightTime": "105",
# "Distance": "545",
# "ETicketability": "Yes",
# "Equipment": "320",
# "ChangeOfPlane": "false",
# "ParticipantLevel": "Secure Sell",
# "LinkAvailability": "true",
# "PolledAvailabilityOption": "Polled avail used",
# "OptionalServicesIndicator": "false",
# "AvailabilitySource": "S",
# "AvailabilityDisplayType": "Fare Shop/Optimal Shop",


module Travelport::Response

		class Segment

		    attr_accessor  :carrier_code, :code, :origin, :destination, :flight_code, :duration, :depart_date, :arrival_date, :origin_airport, :destination_airport, :origin_terminal, :destination_terminal, :carrier, :transit_duration

		    def initialize segment, parser
		      @key = segment['Key']
		      @airline = segment['Carrier']
		      @code = segment['FlightNumber']
		      @flight_code = "#{@airline}#{@code}"
		      @duration = segment['FlightTime']
		      @depart_date = segment['DepartureTime']
		      @arrival_date = segment['ArrivalTime']
		      @origin_airport  = segment['Origin']
		      @destination_airport = segment['Destination']
		      details = parser.flightDetailsList[segment['FlightDetailsRef']['Key']]
		      @terminal = details['OriginTerminal'] || details['DestinationTerminal']
		      @origin = Flight::Airport.get(@origin_airport)
		      @destination = Flight::Airport.get(@destination_airport)
		      @origin_terminal = nil
		      @destination_terminal = nil
		      @carrier = Flight::Airline.find_by(iata: @airline)
		      @transit_duration = nil
		    end


			def to_builder
			    Jbuilder.new do |segment|
			      segment.(self, :carrier_code, :code, :origin, :destination, :flight_code, :duration, :depart_date, :arrival_date, :origin_airport, :destination_airport, :origin_terminal, :destination_terminal, :carrier, :transit_duration)
			    end
			end
		end

 

end
