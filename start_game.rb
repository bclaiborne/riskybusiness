require 'gosu'
require_relative 'defineclasses.rb'

class GameWindow < Gosu::Window
	attr_accessor:latitude, :longitude, :risk, :click, :debug
  def initialize
	#Initializes all attributes of the GameWindow and loads images into variables.
	
	#Window Size and draw rate.
    super 500, 650, false, 30
	
	#Window Title
    self.caption = "Four Corners Risk"
	
	#add images used thru a game to variable names.
	@background_image = Gosu::Image.new(self, "./images/riskmap.png", true)
	@arizona_red = Gosu::Image.new(self, "./images/arir.png", true)
	@arizona_blue = Gosu::Image.new(self, "./images/arib.png", true)
	@colorado_red = Gosu::Image.new(self, "./images/colr.png", true)
	@colorado_blue = Gosu::Image.new(self, "./images/colb.png", true)
	@newmex_red = Gosu::Image.new(self, "./images/mexr.png", true)
	@newmex_blue = Gosu::Image.new(self, "./images/mexb.png", true)
	@utah_red = Gosu::Image.new(self, "./images/utahr.png", true)
	@utah_blue = Gosu::Image.new(self, "./images/utahb.png", true)
	@hover = Gosu::Image.new(self, "./images/overlay.png")

	#Sets Font Type
	@font = Gosu::Font.new(self, Gosu::default_font_name, 20)

	#Initial State Settings and Game Initalization.
	@click = false
	@latitude = @longitude = 0
	@risk = Game.new

	end
  def display_win
	#display_win displays the victory text if a win condition has been met.
	if @risk.win == true
		@font.draw("#{@risk.currentp.name} WINS!!!!", 125, 300, 2, 2.0, 2.0, 0xffffffff)
	end
  end
  def centered(string, pos)
	#centered(String, Integer) attempts to center a string of text around a specific position. 
	 _position = pos - ((string.length * 6) / 2)
	 return _position
  end
  def display_states
	#display_states draws the states to the game window with the appropriate player color.
	#Refactoring:
	#This could be refactored to a helper method call passing the area and player to compare.
	#It could also be refactored to require the positions to be passed in rather than hard coding them here.

	#draw the background
	@background_image.draw(0,0,2)
	#draw areas blue or red depending on owner.
	if @risk.arizona.owner == @risk.player1
		@arizona_blue.draw(0,150,1)
	elsif @risk.arizona.owner == @risk.player2
		@arizona_red.draw(0,150,1)
	end
	if @risk.utah.owner == @risk.player1
		@utah_blue.draw(0,150,1)
	elsif @risk.utah.owner == @risk.player2
		@utah_red.draw(0,150,1)
	end
	if @risk.colorado.owner == @risk.player1
		@colorado_blue.draw(0,150,1)
	elsif @risk.colorado.owner == @risk.player2
		@colorado_red.draw(0,150,1)
	end
	if @risk.newmex.owner == @risk.player1
		@newmex_blue.draw(0,150,1)
	elsif @risk.newmex.owner == @risk.player2
		@newmex_red.draw(0,150,1)
	end
  end
  def display_stats
	#display_stats draws the text over the images of the board/areas.
	#The internal accessing of the game object should probably be managed with dependency injection.
	@font.draw("#{risk.player1.name}", 10, 10, 2, 1.0, 1.0, 0xff000000)
	@font.draw("Units: #{risk.player1.units}", 10, 30, 2, 1.0, 1.0, 0xff000000)
	@font.draw("#{risk.player2.name}", 415, 10, 2, 1.0, 1.0, 0xff000000)
	@font.draw("Units: #{risk.player2.units}", 415, 30, 2, 1.0, 1.0, 0xff000000)
	@font.draw("Left-Click: Select Area", 10, 110, 2, 1.0, 1.0, 0xff000000)
	@font.draw("Right-Click: Pass Turn", 315, 110, 2, 1.0, 1.0, 0xff000000)
	@font.draw("#{risk.utah.owner.name}", 170, 330, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.utah.units}", 170, 350, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.colorado.owner.name}", 270, 330, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.colorado.units}", 270, 350, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.arizona.owner.name}", 170, 410, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.arizona.units}", 170, 430, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.newmex.owner.name}", 270, 410, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.newmex.units}", 270, 430, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.instruct}", centered(@risk.instruct, 250), 60, 2, 1.0, 1.0, 0xff000000)
  end
  def display_debug
	#display_debug is just a block of state variables displayed on the game window for testing.
	
	#set debug variables I want to display.
	@debug = {p_name: "",a_name: "",phase: "",win:""}
	@debug[:p_name] = @risk.currentp.name
	@debug[:phase] = @risk.phase
	@debug[:win] = @risk.win

	#error catch for no current attacking area.
	if @risk.currenta == nil
		@debug[:a_name] = "none"
	else 
		@debug[:a_name] = @risk.currenta.name 
	end
	#draw the debug options information to specific spots on the screen.
	@font.draw("Current Player: #{@debug[:p_name]}", 200, 170, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Current Area: #{@debug[:a_name]}", 200, 190, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Current Phase: #{@debug[:phase]}", 200, 210, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Win state: #{@debug[:win]}", 200, 230, 3, 1.0, 1.0, 0xff000000)
	@font.draw("mouse x: #{@longitude} mouse y: #{latitude}", 200, 250, 3, 1.0, 1.0, 0xff000000)

  end
  def cursor_hover
	#cursor_hover sets the position of the overlay image to help clarify what area a user will be selecting.
	if mouse_x <= 250
		#left side of the map
		if mouse_y > 150 && mouse_y <= 400
			#below status bar and above lower quadrant
			@hover.draw(-20,150,3)
		elsif mouse_y > 350
			#lower quadrant
			@hover.draw(-20,400,3)
		end
	else 
		#right side of the map
		if mouse_y > 150 && mouse_y <= 400
			#below status bar and above lower quadrant
			@hover.draw(250,150,3)
		elsif mouse_y > 350
			#lower quadrant
			@hover.draw(250,400,3)
		end
	end
  end
  def needs_cursor?
	#needs_cursor? forces the game window to display the cursor position.
	true
  end
  def button_up(id)
	#button_up(Gosu::'button') triggers the event associated with the button at click time.
	if id == Gosu::MsLeft
		#Set the mouse location and select the corresponding area or transfer units if it is the transfer phase.
		if @risk.phase == "transfer"
			@risk.transfer_units
		else
			#Store mouse location at time of click and set click state to trigger game logic.
			@longitude = mouse_x
			@latitude = mouse_y
			@click = true
			select_area()
		end
	end
	if id == Gosu::MsRight
		#Start a new game, End unit transfer after an attack or End the Players Turn depending on the phase of the game.
		if @risk.win
			@risk = Game.new
		elsif @risk.phase == "transfer"
			#reset battle states and move back to the attack phase.
			puts "Attacker/Defender reset."
			@risk.atk = @risk.def = nil
			@risk.phase = "attack"
		else
			if @risk.currentp.units == 0
				#Change Player and set phase to begining of a turn.
				@risk.change_player
				@risk.phase = "give_u"
			end
		end
	end
  end
  def select_area
	#select_area handles the click events in the update cycle if a button press was detected.
	options = {lat:@latitude, lon:@longitude, area:@risk.currenta}
	#Make sure we are clicking on the actual map and not on the status bar.
	if @latitude > 150
		@risk.change_area(options)
	end
	if @latitude < 150 then @click = false end
  end
  def update
	#update is called by Gosu to run the game logic.
  
	#Check that a click happened and the game isn't over before running all the game logic.
	if (@click && @risk.win == false)
		risk.run()
		@click = false
	end
	#refresh the status bar.
	@risk.update_state
  end
  def draw
	#draw is called by Gosu to draw stuff.
	#position the overlay image under the mouse.
	cursor_hover
	display_win
	display_states()
	display_stats()
	#display_debug()
  end
end

#run all the things.
window = GameWindow.new
window.show