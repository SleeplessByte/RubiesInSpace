require_relative 'iship'

#
#
class ShipInterface

	#
	#
	class Command
		
		attr_reader :source
		
		##
		#
		#
		def initialize( source )
			@source = source
		end
		
	end
	
end