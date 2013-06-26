require_relative 'planet'

#
#
class Building
	
	attr_reader :planet
	
	#
	#
	def initialize( planet )
		@planet = planet
	end
	
end