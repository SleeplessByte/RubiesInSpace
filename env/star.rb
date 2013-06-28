require_relative 'spacenode'
#
#
class Star < SpaceNode
	
	attr_reader :size
	attr_reader :temperature
	attr_reader :age
	attr_reader :rate
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@temperature = seed[ 1 ]
		@age = seed[ 2 ]
		@rate = seed[ 3 ]
		
	end
	
	def scan( scanner = nil )
		result = {
			:type => self.class,
			:size => @size,
			:temperature => @temperature,
			:age => @age,
			:rate => @rate
		}
		result[ :log ] = SpaceLog.generate( :scan, :star, result, scanner )
		return result
	end
	
	#
	#
	def collect( c ) 
		return [ c, @rate ].min
	end
	
end 