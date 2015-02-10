require 'gosu'
require_relative 'defineclasses.rb'

class GameWindow < Gosu::Window
	attr_accessor:latitude, :longitude, :risk, :click, :debug
  def initialize
    super 500, 650, false, 30
    self.caption = "Four Corners Risk"
	@background_image = Gosu::Image.new(self, "./images/riskmap.png", true)

	@arizona_red = Gosu::Image.new(self, "./images/arir.png", true)
	@arizona_blue = Gosu::Image.new(self, "./images/arib.png", true)
	@colorado_red = Gosu::Image.new(self, "./images/colr.png", true)
	@colorado_blue = Gosu::Image.new(self, "./images/colb.png", true)
	@newmex_red = Gosu::Image.new(self, "./images/mexr.png", true)
	@newmex_blue = Gosu::Image.new(self, "./images/mexb.png", true)
	@utah_red = Gosu::Image.new(self, "./images/utahr.png", true)
	@utah_blue = Gosu::Image.new(self, "./images/utahb.png", true)
#	@breaker = Gosu::Image.new(self, "./images/divider.png",true)
	@hover = Gosu::Image.new(self, "./images/overlay.png")

	@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	@click = false
	@latitude = @longitude = 0
	@risk = Game.new
#	@risk.currenta = @risk.utah
  end
  def display_win
	if @risk.win == true
		@font.draw("#{@risk.currentp.name} WINS!!!!", 125, 300, 2, 2.0, 2.0, 0xffffffff)
	end
  end
  def centered(string, pos)
	 _position = pos - ((string.length * 6) / 2)
	 return _position
  end
  def display_states
	@background_image.draw(0,0,2)
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
	@debug = {p_name: "",a_name: "",phase: "",win:""}
	@debug[:p_name] = @risk.currentp.name
	@debug[:phase] = @risk.phase
	@debug[:win] = @risk.win
	if @risk.currenta == nil
		@debug[:a_name] = "none"
	else 
		@debug[:a_name] = @risk.currenta.name 
	end
	
	@font.draw("Current Player: #{@debug[:p_name]}", 200, 170, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Current Area: #{@debug[:a_name]}", 200, 190, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Current Phase: #{@debug[:phase]}", 200, 210, 3, 1.0, 1.0, 0xff000000)
	@font.draw("Win state: #{@debug[:win]}", 200, 230, 3, 1.0, 1.0, 0xff000000)
	@font.draw("mouse x: #{@longitude} mouse y: #{latitude}", 200, 250, 3, 1.0, 1.0, 0xff000000)

  end
  def cursor_hover
	if mouse_x <= 250
		if mouse_y > 150 && mouse_y <= 400
			@hover.draw(-20,150,3)
		elsif mouse_y > 350
			@hover.draw(-20,400,3)
		end
	else 
		if mouse_y > 150 && mouse_y <= 400
			@hover.draw(250,150,3)
		elsif mouse_y > 350
			@hover.draw(250,400,3)
		end
	end
  end
  def needs_cursor?
	true
  end
  def button_up(id)
	if id == Gosu::MsLeft
		# draw text saying "Left Click Worked!"
		if @risk.phase == "transfer"
			@risk.transfer_units
		else
			@longitude = mouse_x
			@latitude = mouse_y
			@click = true
			select_area()
		end
	end
	if id == Gosu::MsRight
		# draw text saying "Right Click Worked!"
		if @risk.win
			@risk = Game.new
		elsif @risk.phase == "transfer"
			@risk.atk = @risk.def = nil
			puts "Attacker/Defender reset."
			@risk.phase = "attack"
		else
			if @risk.currentp.units == 0
				@risk.change_player
				@risk.phase = "give_u"
			end
		end
	end
  end
  def select_area
	options = {lat:@latitude, lon:@longitude, area:@risk.currenta}
	if @latitude > 150
		@risk.change_area(options)
	end
	if @latitude < 150 then @click = false end
  end
  def update
	if (@click && @risk.win == false)
		risk.run()
		@click = false
	end
	@risk.update_instruct
  end
  def draw
	cursor_hover
	display_win
	display_states()
	display_stats()
	display_debug()
  end
end

window = GameWindow.new
window.show