require 'sinatra'
require 'sinatra/support'

require_relative 'helpers'
require_relative 'core/runner'

configure do
	set :public_folder, Proc.new { File.join( root, "static" ) }
	enable :sessions
end

###
# The online version will handle multiple running instances
# The offline version won't, so we define this globally for now
$runner = RubiesInSpaceRunner.new

before do
	@snapshot = $runner.instance.snapshot
	session[ :state ] = @snapshot.state
end

#=====-=====-=====-=====-=====-=====# 
# Home
#=====-=====-=====-=====-=====-=====#
get '/' do
	erb :index
end

#=====-=====-=====-=====-=====-=====# 
# Simulation
#=====-=====-=====-=====-=====-=====#
get '/simulation' do
	erb :'simulation/index'
end

post '/simulation' do
	try_setting_simulation( params )
	redirect to '/simulation'
end

#=====-=====-=====-=====-=====-=====# 
# Exploration
#=====-=====-=====-=====-=====-=====#
get '/explore' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@page = 0
		erb :'explore/index'
	end
end

get '/explore/page/:n' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@page = params[ :n ].to_i
		erb :'explore/index'
	end
end

get '/explore/:id' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@node = $runner.universe.nodes[ params[ :id ].to_i ]
		if @node.nil?
			redirect to '/explore'
		else
			erb :'explore/show'
		end
	end
end

#=====-=====-=====-=====-=====-=====# 
# Logger
#=====-=====-=====-=====-=====-=====#
get '/log' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@page = 0
		erb :'simulation/log'
	end
end

get '/log/page/:n' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@page = params[ :n ].to_i
		erb :'simulation/log'
	end
end

get '/log/:date' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		@stardate = Space::Universe.stardate params[ :date ].to_i
		@logs = Space::Universe.logger[ params[ :date ].to_i ]
		#@next = 
		if @logs.nil?
			redirect to '/log'
		else
			erb :'simulation/log_entry'
		end
	end
end

#=====-=====-=====-=====-=====-=====# 
# Ships
#=====-=====-=====-=====-=====-=====#
get '/ships' do
	if $runner.universe.nil?
		redirect to '/simulation'
	else
		erb :'ships/index'
	end
end

get '/ship/:id' do
	ships = ( $runner.players.map do | player | player.ships end ).flatten
	@ship = ships.find do | ship | ship.id.to_s == params[ :id ] end
	puts "", "", "s:" + @ship.to_s
	if @ship.nil?
		redirect to '/ships'
	else
		erb :'ships/show'
	end
end


#=====-=====-=====-=====-=====-=====# 
# Players
#=====-=====-=====-=====-=====-=====#
get '/player/:id' do
	@player = $runner.players.find do |p| p.id.to_s == params[ :id ] end
	if @player.nil?
		redirect to '/players'
	else
		erb :'players/show'
	end
end

get '/players/join' do
	erb :'players/join'
end

get '/players' do
	erb :'players/index'
end

post '/players' do
	unless try_adding_player( params )
		redirect to session[ :previous_url ] || '/players/join'
	else
		redirect to '/players'
	end
end

get '/crews' do
	erb :'players/crews'
end