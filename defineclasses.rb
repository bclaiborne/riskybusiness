class Player
	attr_accessor :name, :units, :areas, :wins
	def initialize()
		@name = name
		@units = 20
		@wins = 0
		@areas = []
	end
	def change_units(int)
		@units = @units + int
	end
	def claim_area(area)
		@areas.push(area)
	end
	def set_name(name = nil)
		if name == nil
			puts "Please enter an arbitrary string of characters that will uniquely define you."
			@name = gets.chomp
		else
			@name = name
		end
	end
end

class Area
	attr_accessor :name, :owner, :borders, :units, :attack, :target
	def initialize(options)
		@owner = options[:owner]
		@name = options[:name].capitalize
		@units = 0
		@borders = []
	end
	def set_owner(player)
		@owner = player
	end
	def set_border(area)
		@borders.push(area)
		area.borders.push(self)
	end
	def check_border(area)
		@borders.each do |my_neighbor| 
			return true if my_neighbor == area
		end			
		false
	end
	def roll_die(int)
		rolls = []
	end

end

class Game
	attr_accessor :player1, :player2, :west, :east, :current, :attacks, :win
	def initialize()
		@player1 = Player.new()
		@player1.set_name()
		@current = @player1
		@player2 = Player.new()
		@player2.set_name("Wayne the Great")
		@west = Area.new(owner:@player1, name:"west")
		@east = Area.new(owner:@player2, name:"east")
		@player1.claim_area(@west)
		@player2.claim_area(@east)
		@west.set_border(@east)
		@win = false

		puts "Welcome to Berlin Risk! Troops are building and it is up to you to free the east! Can you do it!?"
	end
	def change_player()
		if @current.equal?@player1
			@current=@player2
		else 
			@current =@player1
		end
	end
	def check_win(count)
		if count >= 50
			puts @current.name + " WINS!"
			@win = true
		end
	end
	def die_roll(number)
		
	end
	def run()
		until @win == true do
			puts "Now its " + @current.name + "s turn!"
			#give units to players
			units = 3
			if @current.wins > 2
				units += 5
				@current.wins = 0
			end
			@current.change_units(units)
			puts @current.name + " now has "+ @current.units.to_s + " units in " + @current.areas[0].name + " Berlin."
			
			#player places units
			#attack (loops)
			while attacks == true do 
				puts "Want to attack?"
				gets.chomp
				#player chooses attacker and defender
				#attack roll until dead or lose
			end
			#ends turn
			self.check_win(@current.units)
			self.change_player()
		end
	end
end

