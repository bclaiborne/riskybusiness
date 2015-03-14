require 'gosu'

class Player
	attr_accessor :name, :units, :wins
	def initialize(name)
		#initialize a player with a name, default units and no battle wins. - DO IT!
		@name = name
		@units = 5
		@wins = 0
	end
end

class Area
	attr_accessor :owner, :borders, :latitudes, :longitudes, :name
	attr_accessor :units, :attack, :target

	def initialize(options)
		#initialize(options = {name: "", owner:@playern, latitudes: [Integer, Integer], longitudes: [Integer, Integer]}
		#Creates a new area and sets initial information. 
		#Latitudes and longitudes define the clickable area registered as the area.
		@owner = options[:owner]
		@name = options[:name]
		@units = 0
		@latitudes = options[:latitudes]
		@longitudes = options[:longitudes]
		#Unused in 4 corners risk where all areas border each other.
		@borders = []
	end
	#Unused in 4 corners risk where all areas border each other.
	def set_border(area1, area2 = nil)
		@borders.push(area1)
		area1.borders.push(self)
		if area2 != nil
			@borders << area2
			area2.borders << self
		end
	end

	#Unused in 4 corners risk where all areas border each other.
	def check_border(area)
		#check_border(Area) boolean to test borders between itself and the passed neighbor.
		@borders.each do |my_neighbor| 
			return true if my_neighbor == area
		end			
		false
	end
	def edge_check(options)
		#edge_check(options = {lat: Integer, lon: Integer}
		#Compares the click location to the Areas clickable area.
		#Returns itself if the click was within its area.
		
		if latitudes[0] < options[:lat] && options[:lat] < latitudes[1]
			if longitudes[0] < options[:lon] && options[:lon] < longitudes[1]
				options[:area] = self
			end
		end
		options[:area] = options[:area]
	end
	def draw
		#draw displays the Areas name.
		@font.draw("#{self.name}", self.name_x, self.name_y, 1, 1.0, 1.0, 0xff000000)

	end
end

class Game
	attr_accessor :player1, :player2, :none, :utah, :colorado, :arizona, :newmex
	attr_accessor :currentp, :currenta, :atk, :def, :win, :phase, :instruct

	def initialize()
		#initialize()
		#Instantiates all components of a new game.
		
		#Create Players
		@player1 = Player.new("Player1")
		@player2 = Player.new("Player2")
		@playern = Player.new("None")
		@currentp = @player1
		@currenta = nil
		puts "Players created."

		#Create Areas
		@utah = Area.new(name: "Utah", owner:@playern, latitudes: [150,400], longitudes: [0,250]) 
		@colorado = Area.new(name: "Colorado", owner:@playern, latitudes: [150,400], longitudes: [250,500]) 
		@arizona = Area.new(name: "Arizona", owner:@playern, latitudes: [400,650], longitudes: [0,250]) 
		@newmex = Area.new(name: "New Mexico", owner:@playern, latitudes: [400,650], longitudes: [250,500])
		@utah.set_border(@arizona, @colorado)
		@newmex.set_border(@colorado, @arizona)
		puts "Areas created"
		
		#Set initial status bar instructions.
		@instruct = "#{@currentp.name} choose an area."
		#Set win condition to false
		@win = false
		#Set initial phase
		@phase = "setup"
		puts "Game Phase = #{@phase} / Win State: #{@win}"
	end
	def change_player()
		#change_player()
		#Changes the current player.
		if @currentp.equal?@player1
			@currentp=@player2
		else 
			@currentp =@player1
		end
		puts "Current Player: #{@currentp.name}"
	end
	def change_area(options)
		#change_area(options = {lat: Integer, lon: Integer})
		#Sets the current Area.
		#Options are NOT used here, only passed to the edge_check method.
		@currenta = @utah.edge_check(options)
		@currenta = @colorado.edge_check(options)
		@currenta = @arizona.edge_check(options)
		@currenta = @newmex.edge_check(options)
		if @currenta then puts "Selected: #{@currenta.name}" else puts "Nothing Selected" end
	end
	def transfer_units()
		#transfer_units()
		#Helper method to move units from attacking Area to conqured Area.
		
		#Move a unit.
		if @atk.units > 1
			@atk.units -= 1
			@def.units += 1
		end
		#Display phase instructions.
		@instruct = "March Troops. Rt-Click to cancel."
	end
	def check_game_win(player)
		#check_game_win(Player Object)
		#Checks if a player owns all Areas.
		_i = 0
		if @utah.owner == player then _i += 1 end
		if @arizona.owner == player then _i += 1 end
		if @colorado.owner == player then _i += 1 end
		if @newmex.owner == player then _i += 1 end
		puts "#{@currentp.name} owns #{_i.to_s} states."
		#check if we own them all. 
		#THIS VARIABLE SHOULD PROBABLY BE PASSED AS AN ARGUEMENT.
		#Currently this means we are hard coding the board size!
		if _i == 4 
			@win = true 
			puts "Game Win."
		end
	end
	def battle()
		#Perform a battle sequence between Attacking and Defending areas.
		att_units = @atk.units
		def_units = @def.units
		
		#Make sure one unit is still in the attacking country.
		if att_units <= 3 then att_units -= 1 end
		#Set attacking/defending units to max.
		if att_units > 3 then att_units = 3 end 
		if def_units > 2 then def_units = 2	end
		puts "#{@atk.name} uses: #{att_units}. #{@def.name} uses: #{def_units}."
		#Roll atk/def dice.
		att_roll = die(att_units)
		def_roll = die(def_units)
		puts "Attack array: #{att_roll} Defence array: #{def_roll}"
		#Compare Attack Roll to Defense Roll
		_i = 0
		while (_i < def_roll.length and _i < att_roll.length) do
			if def_roll[_i] < att_roll[_i]
				#Kill a defender
				puts "-1 defending unit"
				@def.units -=1
				if @def.units == 0
					#Take over the defender and start transfer phase.
					@def.owner = atk.owner
					@atk.units -= att_units
					@def.units += att_units
					@atk.owner.wins += 1
					@phase = "transfer"
				end
			end
			if def_roll[_i] >= att_roll[_i] 
				#Kill an attacker
				puts "-1 attacking unit."
				@atk.units -=1 
			end
			_i += 1
		end
	end
	def die(number)
		#die(Integer)
		#Rolls a die the specified number of times and sorts them greatest to least.
		i = 0
		dice = []
		while i < number do 
			dice.push(1+rand(6))
			#Sort the dice in desending order.
			dice.sort! {|x, y| y <=> x}
			i += 1
		end
		return dice
	end
	def update_state
		#update_state()
		#Updates the instructions on the status bar.
		#Helps clarify the phase of the game.
		if @phase == "setup"
			@instruct = "#{@currentp.name} choose an area."
		elsif @phase == "start"
			@instruct = "#{@currentp.name} place a unit."
		elsif @phase == "give_u" or @phase == "place_u"
			@instruct = "#{@currentp.name} place a unit."
		elsif @phase == "attack"
			@instruct = "#{@currentp.name} select battle states."
		elsif @phase == "transfer"
			@instruct = "March Troops. Rt-Click to cancel."
		end
		#The following doesn't fit SRP... Should be refactored somewhere else.
		#give units to player
		if @phase == "give_u"
			@currentp.units += 3 
			if @currentp.wins > 2
				@currentp.units += 2
				@currentp.wins = 0
			end
			#Change phase to unit placement
			@phase = "place_u"
		end
	end
	def run()
		#run()
		#Manages game logic according to phase.
		if @phase == "setup"
			#Setting Countries Owners.
			if @currenta.owner and @currenta.owner == @playern
				@currenta.owner = @currentp
				if @currenta then puts "#{@currenta.name} claimed for #{@currentp.name}" else puts "No Area Selected" end
				@currenta.units += 1
				@currentp.units -= 1
				change_player()
			end
			#Checks for completion of phase.
			#If all areas are claimed change phase.
			if 	@utah.owner!=@playern && 
				@arizona.owner!=@playern && 
				@colorado.owner!=@playern && 
				@newmex.owner!=@playern then
				@phase = "start"
				puts "All areas claimed. Phase: #{@phase}"
			end
		#Placing initial units phase
		elsif @phase == "start"
			if @currenta.owner == @currentp
				@currenta.units += 1
				@currentp.units -= 1
				puts "Unit placed on #{@currenta.name} for #{@currentp.name}"
				change_player()
			end
			#Changes Phase if all units are placed.
			if @player1.units == 0 and @player2.units == 0 
				@phase = "give_u" 
				puts "Phase: #{@phase}"				
			end
		end
		if @phase == "place_u"
			#place units
			if @currenta.owner == @currentp
				@currenta.units += 1
				@currentp.units -= 1
			end
			@atk = @def = nil
			puts "Attacker/Defender reset."
			if @currentp.units == 0 
				@phase = "attack" 
				puts "Phase: #{@phase}"
			end
		elsif @phase == "attack"
			#do battles until no units to attack or player cancels/ wins.
			
			#Check for valid attacker.
			if @atk == nil and @currenta.units > 1 and @currenta.owner == @currentp
				@atk = @currenta
				puts "Attacker: #{@atk.name}"
			#Possibly remove as attacker.
			elsif @atk != nil and @atk == @currenta
				puts "#{@atk.name} removed as attacker."
				@atk = nil
			#Check for valid defender
			elsif @def == nil and @currenta.owner != @currentp
				@def = @currenta
				puts "Defender: #{@def.name}"
			#Possibly remove as defender.
			elsif @def != nil and @def == @currenta
				puts "#{@def.name} removed as defender."
				@def = nil
			end
			#If both are set, performe the battle and check for win condition.
			if @atk and @def
				battle()
				check_game_win(@currentp)
				#If the game didn't end, reset attacker/defender and continue phase.
				if @phase == "attack"
					@atk = @def = nil
					@instruct = "Select battle states."	
				end
			end
		end
	end
end

