require_relative 'defineclasses.rb'

instance1 = Area.new
instance2 = Area.new
instance1.set_border(instance2)
if instance1.check_border(instance2)
	puts "Yep i border it!"
end
if instance2.check_border(instance1)
	puts "I agree!"
end