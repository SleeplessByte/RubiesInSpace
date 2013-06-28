Rubies In Space
=============
Find some Rubies by building your own agent in Ruby

What is _Rubies in Space_
----------------------
_Rubies in Space_ is a Programming Game in **Ruby** that takes place in space. Instead of simulation a grid based world where the main point is creating the best swarm tactic, _Rubies in Space_ evolves around **RTS** and **RPG** tactics. 

As far as I know (and searched - not that I looked thoroughly) there is no such thing and especially no such thing in Ruby. There is so much software for Ruby, but not a lot of games, simply because it isn't suited very well for games. That said, I don't really care. So let's go! -- this is a DRAFT

How to Win the Game
----------------------
In _Rubies in Space_ you control ships by providing the crew. You have two goals:
- Stay alive by keeping the ship alive
- Find the **Ruby**

There latter is hidden in one of the many asteroids and can only be found by drilling with a special **Drill** that has to be researched and build. More on this later. You stay alive by keeping the energy level of the ship above 0.

Game Rules
----------------------
There are three rules:
- You have access to the `./interface` folder. The `iship.rb` file contains a class `ShipInterface`. When your **crew** is assigned a **ship**, it will be passed on an instance of this interface. Use it to control the ship. Don't try to extend, read, send, access the internals. That's just lame.
- If you want to use a `Randomizer`, use `ShipInterface#rand`, `ShipInterface#rand(n)` or `ShipInterface#bytes(n)`. The reason is that we can then simulate the complete game again by passing in the seed.
- Try to keep your code fast. In later versions you will be penalized.

Participation
----------------------
At this moment the best way is to **Fork** this repo and provide a new **Crew** in the `./crew` folder. I am working on an online tournament system, other game modes and so forth and on. 

Game World
----------------------
See the wiki

~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

Progress
-------------
### Environment
Space
- &#x2611; is a graph

Nodes are
- &#x2611; A Star or
    - &#x2611; sustainable deuterium at a rate
    - &#x2611; has a size [ does nothing yet ]
    - &#x2611; has temperature [ does nothing yet ]
    - Events
        - &#x2610; solar flares [ damage ]
        - &#x2610; death [ kills nodes -> asteroids ]
- &#x2611; A planet or
    - &#x2611; non-renewable deuterium
    - &#x2611; has a size [ does nothing yet ]
    - A building
        - &#x2610; A lab or
        - &#x2610; A factory or
        - &#x2611; nothing
- &#x2611; An asteroid
    - &#x2611; non-renewable deuterium
    - &#x2610; the ruby

Pathways are between two nodes
- &#x2611; have a distance

### Player
- &#x2611; has a ship
- &#x2610; may build new ships
- &#x2611; maintain a crew [ the agent program ]

### Ship Actions
- &#x2611; You can only do one thing at a time
- &#x2611; scan
    - &#x2611; yields a ScanReport
        - &#x2611; the properties of the location
        - &#x2611; enemies at location
        - &#x2611; friendlies at location
        - &#x2610; tech provides more/less information
            - &#x2610; blocking stuff
            - &#x2611; enabling stuff
- &#x2611; travel
    - &#x2611; traverse a path
    - &#x2611; yields a Travel Report
        - &#x2611; destination name
        - &#x2611; consumed energy
- &#x2610; communicate
    - &#x2610; broadcast data
    - &#x2611; yields a Communicate Report
- &#x2610; attack
    - &#x2610; attacks a player
    - &#x2610; yields an attack event
    - &#x2610; attacked player can determine action
    - &#x2611; yields a Battle Report
- &#x2610; build
    - &#x2610; builds new ships, upgrades, tech
    - &#x2611; yields a Build Report
- &#x2610; research
    - &#x2610; research tech, upgrades
    - &#x2611; yields a Research Report
- &#x2611; collect
    - &#x2611; collect deuterium
    - &#x2611; yields a Collect Report
        - &#x2611; collected deut
- &#x2610; transfer
    - &#x2610; send deut to other ship
    - &#x2611; yields a Transfer Report
        - &#x2610; transfered deut

- Resources
    - &#x2611; deuterium
    - &#x2611; time

### Ship Stats and Components
Each component has its own stats
- &#x2611; engine
    - &#x2611; power
    - &#x2611; warmup
    - &#x2611; cooldown
- &#x2611; reactor
    - &#x2611; efficiency
- &#x2611; collector
    - &#x2611; warmup
    - &#x2611; power
- &#x2611; scanner
    - &#x2611; efficiency
- &#x2611; weapons rack
    - &#x2611; warmup
    - &#x2611; rate
    - &#x2611; power
- &#x2611; command center

### Build

### Research
TechTree
- &#x2610; Better efficiency
- &#x2610; Better weapons
- &#x2610; Better ...
- &#x2610; Passive Scanner
- &#x2610; Passive Collector
- &#x2610; Ruby miner

### End Conditions
- &#x2610; Survival of the rubiest ( find rubies! )
- &#x2611; Survival of the fittest ( last standing )

#### Events
There will be Random events
- &#x2610; Solar flares
- &#x2610; Super nova
- ...

