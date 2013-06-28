require_relative 'report'

class ShipInterface

	class CollectReport < CommandReport
	
		attr_accessor :collected
		
		def initialize( timestamp, source, collected )
			super timestamp, source
			@collected = collected
		end
		
	end
end