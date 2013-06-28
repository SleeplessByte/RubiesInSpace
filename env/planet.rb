require_relative 'spacenode'

#
#
class Planet < SpaceNode

	attr_reader :building
	attr_reader :size
	attr_reader :temperature
	attr_reader :deuterium
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@temperature = seed[ 1 ]
		@deuterium = seed[ 2 ]
		
		@building = nil
	end
	
	#
	#
	def build( building )
	
		unless @building.nil?
			raise RuntimeError.new "I am already built upon!"
		end
		
		unless @building.is_a? Building
			raise TypeError.new "I can only build buildings!"
		end
		
		@building = building
	end
	
	#
	#
	def scan( scanner = nil )
		result = {
			:type => self.class,
			:size => @size,
			:temperature => @temperature,
			:building => @building.nil? ? nil : @building.scan(), 
			:deuterium => @deuterium
		}
		result[ :log ] = SpaceLog.generate( :scan, :planet, result, scanner )
		return result
	end
	
	#
	#
	def collect( c )
		collection = [ c, @deuterium ].min
		@deuterium -= collection
		return collection
	end
	
end