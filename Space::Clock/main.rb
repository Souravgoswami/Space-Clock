#!/usr/bin/env ruby
=begin
	Written by Sourav Goswami thanks to Ruby2D.

	This is the lite version of the original Space::Clock Screensaver where I removed the space theme and spaceships, comets, planets, etc.
	This version focuses more on the lightweightness on CPU, and requires even lesser RAM than the original one.
	Get the original version here (a bit heavy on CPU but requires < 40 MiB of RAM:
		https://github.com/Souravgoswami/Space-Clock
=end

begin
	require 'ruby2d.rb'
	$start_time = Time.new.strftime('%s').to_i
	$info = File.open('config.conf').readlines
	res = $info[0][$info[0].index('=') + 1 .. - 1]
	$width, $height= res[0..res.index('x') - 1].to_i, res[res.index('x') + 1..-1].to_i
	$border = $info[1][$info[1].index('=') + 1 .. - 1].chomp == 'true'
	$fullscreen = $info[2][$info[2].index('=') + 1 .. -1].chomp == 'true'
	$defaulttimeformat = $info[3][$info[3].index('=') + 1 .. -1].chomp == '24'
	$defaultdateformat = $info[4][$info[4].index('=') + 1 .. - 1].chomp
	$defaultcolours = $info[5][$info[5].index('=') + 1 .. -1].chomp.split(',')
	$staticmagic = $info[6][$info[6].index('=') + 1..-1].to_i
	$particle = $info[7][$info[7].index('=') + 1..-1].to_i
	$magicparticles = $info[8][$info[8].index('=') + 1..-1].to_i
	$flakes = $info[9][$info[9].index('=') + 1..-1].to_i
	$fontsize = $info[10][$info[10].index('=') + 1..-1].to_i
	$customtext1 = $info[11][$info[11].index('=') + 1..-1].chomp
	$customsize1 = $info[12][$info[12].index('=') + 1..-1].to_i
	$customtext2 = $info[13][$info[13].index('=') + 1..-1].chomp
	$customsize2 = $info[14][$info[14].index('=') + 1..-1].to_i
	$customfont = $info[15][$info[15].index('=') + 1..-1].chomp
	$customfontcolour = $info[16][$info[16].index('=') + 1..-1].chomp
	$fps = $info[17][$info[17].index('=') + 1..-1].to_i
rescue LoadError
	warn "Uh Oh, Ruby2D is not installed"
	exit! 127
rescue NoMethodError, Errno::ENOENT
	warn "Generating the config.conf file with default values."
	Thread.new { system('ruby', 'Subwindows/conf_generator.rb') }
	sleep 1
	Thread.new { system('ruby', 'main.rb') }
end

END { at_exit {
puts "\033[1;36mThanks for using \033[1;33mSpace::Clock::Lite \033[1;34mfor #{Time.new.strftime('%s').to_i - $start_time} second(s)!
\033[1;32mHave a good time!\033[0m" } }

module Ruby2D
	def random_color(*color)
		opacity = self.opacity
		self.color = color.empty? ? 'random' : color.sample
		self.opacity = opacity
	end
end

def main
	static = -> (size, z=-5) {
		Image.new( ['crystals/hoverstars.png', 'crystals/hoverstars1.png', 'crystals/hoverstars2.png', 'crystals/hoverstars3.png', 'crystals/hoverstars4.png',
						'crystals/hoverstars5.png', 'crystals/hoverstars6.png', 'crystals/hoverstars7.png', 'crystals/hoverstars8.png',
						'crystals/hoverstars9.png'].sample, x: rand(0..$width), y: rand(0..$height), width: size, height: size, z: z) }
	magic = -> (z=-15, size=rand(1..2)) do Square.new x: rand(0..$width), y: rand(0..$height), z: z, color: %w(yellow white #6ba3ff).sample, size: size end
	t = lambda { |format| Time.new.strftime(format) }
	set title: "Space::Clock", resizable: true, width: $width, height: $height, borderless: $border, fullscreen: $fullscreen, fps_cap: $fps
	colours = $defaultcolours

	bg = Rectangle.new width: $width, height: $height, color: colours, z: -10
	gradient = Rectangle.new width: $width, height: $height, z: -25, color: %w(green blue fuchsia purple teal #ff50a6 blue #00e3d5 #3ce3d4).sample(4)
	gradient.opacity = 1

	timelabel = Text.new t.call('%T:%N')[0..-8], font: 'mage/arima.otf', size: $fontsize + 20
	timelabel.x, timelabel.y = $width/2 - timelabel.width/2, $height/2 - timelabel.height/2
	timelabelswitch = 1
	ampm = Text.new t.call('%r')[-2..-1], font: 'mage/arima.otf'
	ampm.x, ampm.y, ampm.opacity = timelabel.x + timelabel.width - 5, timelabel.y, 0
	timeformat = ('%T:%N') if $defaulttimeformat
	timeformat = '%I:%M:%S:%N' unless $defaulttimeformat
	ampm.opacity = 1 unless $defaulttimeformat
	daylabel = Text.new t.call('%A'), font: 'mage/arima.otf', size: $fontsize
	daylabel.x, daylabel.y = $width/2 - daylabel.width/2, timelabel.y - daylabel.height

	datelabel = Text.new t.call('%d/%m/%y'), font: 'mage/arima.otf', size: $fontsize
	datelabel.x, datelabel.y = $width/2 - datelabel.width/2, timelabel.y + timelabel.height
	dateformatswitch = 1

	greetlabel = Text.new "Welcome to Space Clock", font: 'mage/MateSC-Regular.ttf', size: 50
	greetlabel.x, greetlabel.y, greetlabel.opacity = $width/2 - greetlabel.width/2, daylabel.y - greetlabel.height, 1.5

	greetlabel1 = Text.new "Welcome to Space Clock", font: 'mage/MateSC-Regular.ttf', size: 50
	greetlabel1.x, greetlabel1.y, greetlabel1.opacity = $width/2 - greetlabel1.width/2, datelabel.y + datelabel.height, 1.5

	greetflag = [-10, 10].sample
	customemove = Image.new  'crystals/moveicon.png', z: 1
	customemove.opacity, movealpha = 0, false
	customtext1 = Text.new $customtext1, font: $customfont, size: $customsize1, color: $customfontcolour
	customtext1.x, customtext1.y = $width/2 - customtext1.width/2, greetlabel.y - customtext1.size
	customtext1drag = false

	customtext2 = Text.new $customtext2, font: $customfont, size: $customsize2, color: $customfontcolour
	customtext2.x, customtext2.y = $width/2 - customtext2.width/2, greetlabel1.y + greetlabel1.size
	customtext2drag = false

	particles, randomparticles, flakehash, flakeparticleshash = [], [], [], []
	magicparticles1, magicparticles2, magicparticles3, magicparticles4 = [], [], [], []
	magicparticles5, magicparticles6, magicparticles7, magicparticles8  = [], [], [], []
	magic1, magic2, magic3, magic4, magic5, magic6 = [], [], [], [], [], []

	$particle.times do
		size = rand($width/25..$width/10)
		particles << sq = Image.new('crystals/1pixel_square.png', x: rand(0..$width), y: rand(0..$height + 1000), z: -10, color: 'white', width: size, height: size)
		sq.opacity = rand 0.1..0.3
 	end
	$staticmagic.times do static.call(rand(4..8)) end
	($flakes * 3).times do |temp| flakeparticleshash << magic.call(1) end

	150.times do |temp| randomparticles[temp] = static.call(rand(4..8)) end
	$flakes.times do |temp|
		size = rand(25..35)
		flakehash << c = Image.new( ['crystals/flake1.png', 'crystals/flake2.png'].sample, x: rand(0..$width),
								y: rand(-1000..0), z: -10, width: size, height: size) ;  c.opacity = rand(0.3..0.7)
	end
	$magicparticles.times do |temp|
		magicparticles1[temp], magicparticles2[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles3[temp], magicparticles4[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles5[temp], magicparticles6[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles7[temp], magicparticles8[temp] = static.call(rand(8..12)), static.call(rand(8..12))
	end

	rand(15..25).times do |temp|
		magic1 << magic.call(-5) ; magic2 << magic.call(-5) ; magic3 << magic.call(-5)
		magic4 << magic.call(-5) ; magic5 << magic.call(-5) ; magic6 << magic.call(-5)
 	end

	timelinebool, datelinebool, daylinebool = false, false, false
	on :mouse_move do |e|
		if timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y)
			timelabel.color = 'lime' ; ampm.random_color('white')
			else timelabel.color= 'white' ; ampm.random_color('white') end
		datelabel.color = datelabel.contains?(e.x, e.y) ? 'lime' : 'white'
		daylabel.color = daylabel.contains?(e.x, e.y) ? 'lime' : 'white'
		for val in particles do val.opacity = 0 if val.contains?(e.x, e.y) end
		for val in flakehash do val.x, val.y = rand(0..$width), rand(-1000..0) if val.contains?(e.x, e.y) end
		timelinebool, datelinebool, daylinebool = false, false, false if customtext1.contains?(e.x, e.y) or customtext2.contains?(e.x, e.y)

		if customtext1.contains?(e.x, e.y) and !customtext1.text.empty?
				customtext1.x, customtext1.y = e.x - customtext1.width/2, e.y - customtext1.height/2 if customtext1drag
				movealpha, customemove.x = true, customtext1.x + customtext1.width/2 - customemove.width/2
				customemove.y = customtext1.y + customtext1.height/2 - customemove.height/2
		elsif customtext2.contains?(e.x, e.y) and !customtext2.text.empty?
				customtext2.x, customtext2.y = e.x - customtext2.width/2, e.y - customtext2.height/2 if customtext2drag
				movealpha, customemove.x = true, customtext2.x + customtext2.width/2 - customemove.width/2
				customemove.y = customtext2.y + customtext2.height/2 - customemove.height/2
		else movealpha = false end
	end
	on :mouse_down do |e|
		if e.button == :left
			if customtext1.contains?(e.x, e.y) then customtext1drag = true
			elsif customtext2.contains?(e.x, e.y) then customtext2drag = true
			elsif datelabel.contains?(e.x, e.y)
				dateformatswitch += 1
				$defaultdateformat = dateformatswitch % 2 == 0 ? '%D' : '%d/%m/%y'
			elsif timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y)
				timelabelswitch += 1
				if timelabelswitch % 2 == 0 then timeformat, ampm.opacity = '%T:%N', 0
					else timeformat, ampm.opacity =  '%I:%M:%S:%N', 1 end
			else
				$magicparticles.times do |key|
					magicparticles1[key].x, magicparticles1[key].y = rand(0..$width), rand(0..$height)
					magicparticles2[key].x, magicparticles2[key].y = rand(0..$width), rand(0..$height)
					magicparticles3[key].x, magicparticles3[key].y = rand(0..$width), rand(0..$height)
					magicparticles4[key].x, magicparticles4[key].y = rand(0..$width), rand(0..$height)
				end
				greetflag = [-8, 8].sample
				time = t.call('%H').to_i
				if time >=  5 and time < 12 then greetlabel.text = "Good Morning!..."
					elsif time >=  12 and time < 16 then greetlabel.text = "Good Afternoon."
					elsif time >=  16 and time < 19 then greetlabel.text = "Good Evening!!..."
					else greetlabel.text = "Very Good Night" end
				greetlabel.x, greetlabel.opacity = $width/2 - greetlabel.width/2, 1
				greetlabel1.text = t.call('%c')
				greetlabel1.x, greetlabel1.opacity = $width/2 - greetlabel.width/2, 1
			end
		else
			bg.color = %w(green blue fuchsia purple teal #ff50a6 blue #00e3d5 #3ce3d4).sample(4)
		end
	end

	on :mouse_up do |e| customtext1drag, customtext2drag = false, false end
	on :mouse_scroll do |e|
		bg.opacity += 0.2 if e.delta_y == -1 and bg.opacity <= 1
		bg.opacity -= 0.2 if bg.opacity >= 0 if e.delta_y == 1
	end
	on :key_down do |k|
		Thread.new { system('ruby', 'Subwindows/properties.rb', "#{colours}") } if 'cs'.include?(k.key)
		bg.opacity += 0.2 if bg.opacity < 1 if k.key == 'up'
		bg.opacity -= 0.2 if bg.opacity > 0 if k.key == 'down'
		exit if ['escape', 'q', 'p'].include?(k.key)
		Thread.new { system('ruby', 'main.rb') } if ['right shift', 'left shift'].include?(k.key)
		Thread.new { system('ruby', 'Subwindows/about.rb') } if ['a', 'i'].include?(k.key)
		if ['left alt', 'right alt', 'right ctrl', 'left ctrl', 'tab'].include?(k.key)
			movealpha = false
			customtext1.x, customtext1.y = $width/2 - customtext1.width/2, greetlabel.y - customtext1.height
			customtext2.x, customtext2.y = $width/2 - customtext2.width/2, greetlabel1.y + greetlabel1.height
			bg.random_color colours
			gradient.random_color [colours.sample(4), colours.sample].sample
		end
	end

	i, air_direction = 0, [-1, 0, 1].sample
	update do
		i += 1
		if movealpha then customemove.opacity += 0.03 if customemove.opacity < 1 else customemove.opacity -= 0.05 if customemove.opacity > 0 end
		air_direction = [-1, 0, 1].sample if i % 600 == 0
		flakehash.each do |val|
			if val.y < $height - val.height/2 and (val.x > -val.width and val.x < $width) and val.opacity > 0
				val.x += air_direction
				val.y += 1 + air_direction.abs
				unless air_direction == 0 then val.rotate += air_direction * 2 else val.rotate += rand(-3..3) end
				psample = flakeparticleshash.sample
				psample.x, psample.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height +  10)
				psample.color = 'white'
			else
				val.opacity -= 0.005
				val.x, val.y, val.opacity = rand(0..$width), rand(-1000..0), rand(0.3..0.7), 1 if i % 420 == 0
				val.width = val.height = rand(25..35)
			end
		end

		greetlabel.x += greetflag if greetlabel.x > -greetlabel.width and greetlabel.x < $width + greetlabel.width
		greetlabel.opacity -= 0.02 if greetlabel.opacity >= 0

		greetlabel1.x -= greetflag if greetlabel1.x > -greetlabel1.width and greetlabel1.x < $width + greetlabel1.width
		greetlabel1.opacity -= 0.02 if greetlabel1.opacity >= 0

		$magicparticles.times do |el|
			val = magicparticles1[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.y < -val.height
			val = magicparticles2[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x > $width + val.width or val.y < -val.height
			val = magicparticles3[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y > $height + val.height
			val = magicparticles4[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x > $width + val.width or val.y > $height + val.height
			val = magicparticles5[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width
			val = magicparticles6[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x > $width + val.width
			val = magicparticles7[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height
			val = magicparticles8[el] ; val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y > $height + val.height

			magicparticles1[el].x -= 1 ; magicparticles1[el].y -= 1
			magicparticles2[el].x += 1 ; magicparticles2[el].y -= 1
			magicparticles3[el].x -= 1 ; magicparticles3[el].y += 1
			magicparticles4[el].x += 1 ; magicparticles4[el].y += 1
			magicparticles5[el].x -= 1 ; magicparticles6[el].x += 1
			magicparticles7[el].y -= 1 ; magicparticles8[el].y += 1

			magicparticles1[el].rotate -= 5
			magicparticles2[el].rotate += 5
			magicparticles3[el].rotate -= 5
			magicparticles4[el].rotate += 5
			magicparticles5[el].rotate -= 5
			magicparticles6[el].rotate += 5
			magicparticles7[el].rotate += 5
			magicparticles8[el].rotate += 5
		end
		timelabel.text, daylabel.text = t.call(timeformat)[0..-8], t.call('%A')
		datelabel.text, ampm.text = t.call($defaultdateformat), t.call('%r')[-3..-1]

		randomparticles.sample.opacity = [0, 1].sample
		for val in magic1
			unless val.y <= -val.y
				val.y -= 4
				val.x += Math.cos(i/10)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic2
			unless val.y <= -val.y
				val.y -= 5
				val.x += Math.sin(i/20)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color = %w(yellow white #6ba3ff).sample
				val.size = rand(1..2)
			end
		end
		for val in magic3
			unless val.y <= -val.y
				val.y -= 6
				val.x += Math.sin(i/10)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic4
			unless val.y <= -val.y
				val.y -= 4
				val.x += Math.sin(i/12)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic5
			unless val.y <= -val.y
				val.y -= 2
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff #ff6850).sample(4), rand(1..2)
			end
		end
		for val in magic6
			unless val.y <= -val.y
				val.y -= 8
				val.x += Math.sin(i)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if [true, false].sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in particles
			val.rotate += val.width/250.0
			unless val.y <= -val.height or val.opacity <= 0 then val.y -= 1
			else
				size = rand($width/25..$width/10)
				val.y, val.x, val.opacity = rand($height..$height + 1000), rand(0..$width - val.width/2), rand(0.1..0.3)
				val.width = val.height = size
			end
		end
	end
	show
end
main
