require_relative 'report'

class ShipInterface

	class  BuildReport < CommandReport
		attr_reader :item
		
		def initialize( source, item )
			super source
			@item = item
		end
		
	end
	
end