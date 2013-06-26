require_relative 'spacenode'

#
#
class Planet < SpaceNode

	attr_reader :building
	attr_reader :size
	attr_reader :temperature
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@temperature = seed[ 1 ]
		@building = nil
	end
	
	#
	#
	def build( building )
	
		unless @building.nil?
			raise RuntimeError.new "I am already built upon!"
		end
		
		unless @building.is_a? Building
			rais TypeError.new "I can only build buildings!"
		end
		
		@building = building
	end
	
	#
	#
	def scan( tech = {} )
		result = {
			:type => self.class,
			:size => @size,
			:temperature => @temperature,
			:building => @building.class
		}
		result[ :log ] = SpaceLog.generate( :scan, :planet, result, tech )
		return result
	end
	
end