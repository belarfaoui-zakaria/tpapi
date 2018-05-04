module Travelport::Response

		class Travel

		    attr_reader :segments,
		    :depart_duration,
		    :origin_city,
		    :destination_city,
		    :origin_airport,
		    :destination_airport,
		    :arrival_duration,
		    :stops,
		    :direct,
		    :depart_date,
		    :arrival_date

		    def initialize travel, parser

				if travel['Option'].first.is_a? Hash then
				  options = travel['Option']
				else
				  options = [Hash[travel['Option']]]
				end

			  @segments = options.first['BookingInfo'].map do |s|
			  	Segment.new(parser.airSegmentList[s['SegmentRef']], parser)
			  end

		      @depart_date = @segments.first.depart_date
		      @arrival_date = @segments.last.arrival_date
		      @origin_airport = @segments.first.origin_airport
		      @destination_airport = @segments.last.destination_airport

		      @origin_city = Flight::Airport.get(@origin_airport).city
		      @destination_city = Flight::Airport.get(@destination_airport).city

		      @depart_duration= @depart_date.to_time
		      @arrival_duration = @arrival_date.to_time
		      @stops = @segments.length - 1
		      @direct = @stops == 0
		    end

		    def duration
		      @minutes ||= TimeDifference.between(@depart_duration,  @arrival_duration).in_minutes
		    end

		    def duration_hours
		       (duration/60).to_i
		    end

		    def duration_minutes
		      (duration%60).to_i
		    end

		end
 

end
