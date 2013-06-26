require_relative 'spacenode'
#
#
class Star < SpaceNode
	
	attr_reader :size
	attr_reader :temperature
	attr_reader :age
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@temperature = seed[ 1 ]
		@age = seed[ 2 ]
	end
	
	def scan( tech = {} )
		result = {
			:type => self.class,
			:size => @size,
			:temperature => @temperature,
			:age => @age
		}
		result[ :log ] = SpaceLog.generate( :scan, :star, result, tech )
		return result
	end
	
end 