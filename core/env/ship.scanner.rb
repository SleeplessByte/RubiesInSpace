require_relative 'ship.component'

#
#
class Ship
	
	#
	#
	class Scanner < Component
		
		BASESCAN = 10
		
		attr_reader :efficiency
		
		##
		#
		#
		def initialize( ship, efficiency = 5 )
			super ship
			
			@efficiency = efficiency
		end
		
		##
		#
		#
		def execute( t, action )
		
			duration = BASESCAN * ( 1 - @efficiency / 100.to_f )
			
			# Get the data
			location = ship.location
			ships = location.ships
			
			# Build the result
			environment = location.scan( self )
			paths = location.scan_paths( self )		
			friendlies = ships.select { |s| s.owner == ship.owner }.map { |s| s.scan( self ) }
			enemies = ships.select { |s| s.owner != ship.owner }.map { |s| s.scan( self ) }
			result = Interface::ScanReport.new( 
				t, ship.interface, environment, paths, friendlies, enemies 
			)
			
			return {
				:duration => duration,
				:state => :continue,
				:result => result				
			}
		end
	end

end