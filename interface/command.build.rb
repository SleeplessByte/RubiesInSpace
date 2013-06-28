require_relative 'command'

class ShipInterface

	class BuildCommand < Command

		attr_reader :item
		
		##
		#
		#
		def initialize( source, item )
			super source
			@item = item
		end
	end
	
end