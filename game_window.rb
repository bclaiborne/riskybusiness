require 'gosu'
require_relative 'defineclasses.rb'

class GameWindow < Gosu::Window
	attr_accessor:latitude, :longitude, :risk, :click, :debug
  def initialize
    super 500, 650, false, 30
    self.caption = "Four Corners Risk"
	@background_menu = Gosu::Image.new(self, "./mainmenu.png", true)
	@background_image = Gosu::Image.new(self, "./riskmap.png", true)
	@breaker = Gosu::Image.new(self, "./divider.png",true)
	@hover = Gosu::Image.new(self, "./overlay.png")
	@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	@mainmenu = false
	@click = false
	@latitude = @longitude = 0
	@risk = Game.new
#	@risk.currenta = @risk.utah
  end
  def display_menu
	if @mainmenu == true
		@background_menu.draw(0,150,0)
	end
  end
  def display_board
	if @mainmenu == false
		@background_image.draw(0,150,0)
	end
  end
  def menu_choice()
	select_area()
	@risk.currenta ? @mainmenu = false : @mainmenu = true
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
  def display_stats
	@font.draw("#{risk.player1.name}", 10, 10, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.player1.units}", 10, 30, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.player2.name}", 415, 10, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.player2.units}", 415, 30, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Left-Click: Select Area", 10, 110, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Right-Click: Pass Turn", 315, 110, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.utah.owner.name}", 170, 330, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.utah.units}", 170, 350, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.colorado.owner.name}", 270, 330, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.colorado.units}", 270, 350, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.arizona.owner.name}", 170, 410, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.arizona.units}", 170, 430, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.newmex.owner.name}", 270, 410, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("Units: #{risk.newmex.units}", 270, 430, 1, 1.0, 1.0, 0xffffffff)
	@font.draw("#{risk.instruct}", centered(@risk.instruct, 250), 60, 1, 1.0, 1.0, 0xffffffff)
	@breaker.draw(0,148,3)
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
	
	@font.draw("Current Player: #{@debug[:p_name]}", 200, 170, 1, 1.0, 1.0, 0xff000000)
	@font.draw("Current Area: #{@debug[:a_name]}", 200, 190, 1, 1.0, 1.0, 0xff000000)
	@font.draw("Current Phase: #{@debug[:phase]}", 200, 210, 1, 1.0, 1.0, 0xff000000)
	@font.draw("Win state: #{@debug[:win]}", 200, 230, 1, 1.0, 1.0, 0xff000000)
	@font.draw("mouse x: #{@longitude} mouse y: #{latitude}", 200, 250, 1, 1.0, 1.0, 0xff000000)

  end
  def cursor_hover
	if mouse_x <= 250
		if mouse_y > 150 && mouse_y <= 400
			@hover.draw(-20,150,2)
		elsif mouse_y > 350
			@hover.draw(-20,400,2)
		end
	else 
		if mouse_y > 150 && mouse_y <= 400
			@hover.draw(250,150,2)
		elsif mouse_y > 350
			@hover.draw(250,400,2)
		end
	end
  end
  def needs_cursor?
	true
  end
  def button_up(id)
	if id == Gosu::MsLeft
		# draw text saying "Left Click Worked!"
		@longitude = mouse_x
		@latitude = mouse_y
		@click = true
		select_area()
	end
	if id == Gosu::MsRight
		# draw text saying "Right Click Worked!"
		if @risk.win
			@risk = Game.new
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
	display_menu
	display_board
	cursor_hover
	display_win
	display_stats()
	#display_debug()
	if @mainmenu then menu_choice() end
  end
end

window = GameWindow.new
window.show