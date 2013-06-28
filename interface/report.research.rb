require_relative 'report'

class ShipInterface

	class ResearchReport < CommandReport
	
		attr_reader :item
		
		def initialize( timestamp, source, item )
			super timestamp, source
			@item = item
		end
		
	end
end