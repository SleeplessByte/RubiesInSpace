require_relative '../env/ship'
require_relative 'action.attack'
require_relative 'action.build'
require_relative 'action.research'
require_relative 'action.travel'
require_relative 'action.transfer'
require_relative 'action.communicate'
require_relative 'action.collect'
require_relative 'action.scan'
##
#
#
class IShip
	
	attr_reader :name
	
	##
	# Create an ship interface
	#
	def initialize( ship )
		@ship = ship
		@name = ship.data[ :name ] || "Unnamed vessel"
	end
	
	##
	#
	#
	def identifier
		@ship.object_id
	end
	
	#
	#
	#
	def position
		@ship.position
	end
	
	##
	#
	#
	def data
		@ship.data
	end
	
	##
	# Get ship energy
	#
	def energy
		@ship.amount_of :deuterium
	end
	
	##
	# Get ship energy capacity
	#
	def energy_capacity
		@ship.capacity  :deuterium
	end
	
	##
	# Get energy ratio
	#
	def energy_ratio
		energy().to_f / energy_capacity
	end
	
	##
	# Get ship speed
	#
	def speed
		@ship.stat :speed
	end
	
	##
	# Queue action
	#
	def queue( action )
		@ship.queue action
	end
	
	##
	# Empty queue
	#
	def clear_queue
		@ship.clear_queue
	end
	
	##
	# Current action
	#
	def current
		@ship.action
	end
	
	##
	# Get next action
	#
	def next
		@ship.queue.first
	end
	
	##
	# Get ship efficiency
	#
	def efficiency
		@ship.stat :efficiency
	end
	
	##
	# Action result
	#
	def result
		@ship.result
	end
	
	##
	# Create travel action to node
	#
	def travel( node )
		TravelAction.new self, node
	end
	
	##
	# Create collect action for time
	#
	def collect( time )
		CollectAction.new self, time
	end
	
	##
	# Create transfer action of amount to ship
	#
	def transfer( amount, ship )
		TransferAction.new self, amount, ship
	end
	
	##
	# Create scan action
	#
	def scan()
		ScanAction.new self
	end
	
	##
	# Create build action of item
	#
	def build( item )
		BuildAction.new self, item
	end
	
	##
	# Create research action of item
	#
	def research( item )
		ResearchAction.new self, item
	end
	
	##
	# Create communicate action of data
	#
	def communicate( *data )
		CommunicateAction.new self, data
	end
	
	##
	# Create attack action of data
	#
	def attack( ship )
		AttackAction.new self, ship
	end
	
	#
	#
	#
	def to_s
		"#{ name } (#{ identifier })"
	end
	
	# weapons
	# upgrades
	# tech
	# ...
	
end

IShip.freeze