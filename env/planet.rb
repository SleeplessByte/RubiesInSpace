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
		
		@size = 0
		@temperature = 0 # make up some formulaaa
		
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
	
end