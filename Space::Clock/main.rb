#!/usr/bin/env ruby
# Written by Sourav Goswami thanks to Ruby2D.

begin
	require 'ruby2d'
	file = File.open('config.conf')
	$info = file.readlines
	res = $info[0][$info[0].index('=') + 1 .. - 1]
	$border = $info[1][$info[1].index('=') + 1 .. - 1].chomp == 'true'
	$fullscreen = $info[2][$info[2].index('=') + 1 .. -1].chomp == 'true'
	$width, $height= res[0..res.index('x') - 1].to_i, res[res.index('x') + 1..-1].to_i
	$defaulttimeformat = $info[3][$info[3].index('=') + 1 .. -1].chomp == '24'
	$defaultdateformat = $info[4][$info[4].index('=') + 1 .. - 1].chomp
	$defaultcolours = $info[5][$info[5].index('=') + 1 .. -1].chomp.split(',')
	$spaceships = $info[6][$info[6].index('=') + 1..-1].to_i
	$staticmagic = $info[7][$info[7].index('=') + 1..-1].to_i
	$planets = $info[8][$info[8].index('=') + 1..-1].to_i
	$comets = $info[9][$info[9].index('=') + 1..-1].to_i
	$particle = $info[10][$info[10].index('=') + 1..-1].to_i
	$magicparticles = $info[11][$info[11].index('=') + 1..-1].to_i
	$flakes = $info[12][$info[12].index('=') + 1..-1].to_i
	$hoverparticles = $info[13][$info[13].index('=') + 1..-1].to_i
	$fontsize = $info[14][$info[14].index('=') + 1..-1].to_i
	$customtext1 = $info[15][$info[15].index('=') + 1..-1].chomp
	$customsize1 = $info[16][$info[16].index('=') + 1..-1].to_i
	$customtext2 = $info[17][$info[17].index('=') + 1..-1].chomp
	$customsize2 = $info[18][$info[18].index('=') + 1..-1].to_i
	$customfont = $info[19][$info[19].index('=') + 1..-1].chomp
	$customfontcolour = $info[20][$info[20].index('=') + 1..-1].chomp
	$start_time = Time.new.strftime('%s').to_i
rescue LoadError
	warn "Uh Oh, Ruby2D is not installed. Please read the instruction.txt file in this directory"
	abort
rescue NoMethodError, Errno::ENOENT
	warn "Generating the config.conf file with default values."
	Thread.new { system('ruby', 'Subwindows/conf_generator.rb') }
	sleep 1
	Thread.new { system('ruby', 'main.rb') }
end

END { run_for = Time.new.strftime('%s').to_i - $start_time
	"Thanks for using Space::Clock for #{run_for} #{run_for == 1 ? "second" : "seconds"}.\nHave a good day...".chars do |c|
	print "\033[38;5;#{rand(160..184)}m#{c}" end }

module Ruby2D
	def r=(val) self.color = [val, self.color.g, self.color.b, self.opacity] end
	def g=(val) self.color = [self.color.r, val, self.color.b, self.opacity] end
	def b=(val) self.color = [self.color.r, self.color.g, val, self.opacity] end
	def change_colour(*color)
		opacity = self.opacity
		self.color = color.empty? ? $generate_colour.call : color.sample
		self.opacity = opacity
	end
end

def main
	static = -> (size, z=-5) {
		Image.new( ['crystals/hoverstars.png', 'crystals/hoverstars1.png', 'crystals/hoverstars2.png', 'crystals/hoverstars3.png', 'crystals/hoverstars4.png',
						'crystals/hoverstars5.png', 'crystals/hoverstars6.png', 'crystals/hoverstars7.png', 'crystals/hoverstars8.png',
						'crystals/hoverstars9.png'].sample, x: rand(0..$width), y: rand(0..$height), width: size, height: size, z: z)
	}

	magic = -> (z=-15, size=1) { Square.new x: rand(0..$width), y: rand(0..$height), z: z, color: %w(yellow white #6ba3ff).sample, size: size }

	generate = lambda {
				sq = Square.new x: rand(0..$width), y: rand(0..$height + 1000), z: -10, color: 'white', size: rand($height/10..$width/10)
				sq.opacity = rand 0.1..0.3 ; sq
	}

	$generate_colour = -> {
		colour = ''
		6.times do colour += [('a'..'f').to_a.sample, ('0'..'9').to_a.sample].sample end
		"##{colour}"
	}

	t = proc { |format| Time.new.strftime(format) }

	set title: "Space::Clock", resizable: true, width: $width, height: $height, borderless: $border, fullscreen: $fullscreen
	bg = Rectangle.new width: $width, height: $height, color: $defaultcolours, z: -10

	timelabel = Text.new t.call('%T:%N')[0..-8], font: 'mage/arima.otf', size: $fontsize + 20
	timelabel.x, timelabel.y = $width/2 - timelabel.width/2, $height/2 - timelabel.height/2
	timeline = Line.new x1: timelabel.x + timelabel.width/2, x2: timelabel.x + timelabel.width/2,
			y1: timelabel.y + timelabel.height - 20, y2: timelabel.y + timelabel.height - 20, width: 3
	timelineparam = timelabel.x + timelabel.width/2
	timelabelswitch = 1
	ampm = Text.new t.call('%r')[-2..-1], font: 'mage/arima.otf'
	ampm.x, ampm.y, ampm.opacity = timelabel.x + timelabel.width - 5, timelabel.y, 0
	timeformat = ('%T:%N') if $defaulttimeformat
	timeformat = '%I:%M:%S:%N' unless $defaulttimeformat
	ampm.opacity = 1 unless $defaulttimeformat
	daylabel = Text.new t.call('%A'), font: 'mage/arima.otf', size: $fontsize
	daylabel.x, daylabel.y = $width/2 - daylabel.width/2, timelabel.y - daylabel.height
	dayline = Line.new x1: daylabel.x + daylabel.width/2, x2: daylabel.x + daylabel.width/2,
			y1: daylabel.y + daylabel.height - 20, y2: daylabel.y + daylabel.height - 20, width: 3
	daylineparam = daylabel.x + daylabel.width/2

	datelabel = Text.new t.call('%d/%m/%y'), font: 'mage/arima.otf', size: $fontsize
	datelabel.x, datelabel.y = $width/2 - datelabel.width/2, timelabel.y + timelabel.height
	dateline = Line.new x1: datelabel.x + datelabel.width/2, x2: datelabel.x + datelabel.width/2,
			y1: datelabel.y + datelabel.height - 20, y2: datelabel.y + datelabel.height - 20, width: 3
	datelineparam = datelabel.x + datelabel.width/2
	dateformat = t.call($defaultdateformat)
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

	spacecrafts, fires, fireball, firepixels, comets, sparkles, crystals, planets = [], [], [], [], [], [], [], []
	spacecrafts_speed, spacecrafs_size = [], []
	particles, particleswitch, randomparticles, hoverparticles1, hoverparticles2, hoverparticles3 = [], true, [], [], [], []
	flakehash, flakeparticleshash = [], []
	magicparticles1, magicparticles2, magicparticles3, magicparticles4 = [], [], [], []
	magicparticles5, magicparticles6, magicparticles7, magicparticles8  = [], [], [], []

	magics, speeds = [], []
	i, spaceshiphover = 0, nil
	timelinebool, datelinebool, daylinebool = false, false, false

	Thread.new {
		for temp in 0..($width/35)
			tempsize = rand(30..40)
			Image.new  ['crystals/crystal1.png', 'crystals/crystal2.png', 'crystals/crystal3.png', 'crystals/crystal4.png', ].sample,
						width: tempsize, height: tempsize, x: temp * rand(tempsize - 2.0..tempsize + 2.0), y: $height - tempsize - 10, z: -15

			tempsize = rand(30..40)
			crystals[temp] = Image.new( 'crystals/crystal3.png', width: tempsize, height: tempsize, x: temp * rand(40.0..45.0), y: $height - tempsize - 10,
				z: -15, color: %w(yellow aqua white).sample)
		end
		($width/150).times do
			tempsize = rand(14..16)
			Image.new  ['crystals/specialstar.png', 'crystals/specialstar2.png', 'crystals/specialstar3.png'].sample,
					x: rand(0..$width), y: $height - tempsize * 1.3, z: -[15,16].sample, width: tempsize, height: tempsize
		end
		Image.new  'crystals/galaxy2.png', y: $height - 150, z: -25, x: rand(0..$width - 50)
		Image.new  'crystals/galaxy3.png', y: 50, z: -25, x: rand(0..$width - 50), width: $height/10, height: $height/10
	}

	galaxy = Image.new  'crystals/galaxy1.png', y: 0, z: -25, width: timelabel.width * 2, height: timelabel.width
	galaxy.x, galaxy.y = $width/2 - galaxy.width/2, $height/2 - galaxy.height/2

	$spaceships.times do |temp|
		img = Image.new(['crystals/spacecraft1.png', 'crystals/spacecraft2.png',
					'crystals/spacecraft3.png', 'crystals/spacecraft4.png',
					'crystals/spacecraft5.png', 'crystals/spacecraft6.png', 'crystals/spacecraft7.png'].sample,
					x: rand(0..$width), y: rand($height..$height + 2000), width: 25, height: 40, z: -15)

		spacecrafts << img

		speed = rand(3.0..10.0)

		spacecrafts_speed << speed

		if speed <= 5.0 then spacecrafs_size << [img.width/2, img.height/2]
			elsif speed <= 7.0 then spacecrafs_size << [img.width/1.5, img.height/1.5]
			else	spacecrafs_size << [img.width, img.height]
		end

		fires << Image.new(
						['crystals/fireball1.png', 'crystals/fireball2.png',
						'crystals/fireball3.png', 'crystals/fireball4.png',
						'crystals/fireball5.png', 'crystals/fireball6.png'].sample, x: rand(0..$width), y: rand(0..$width), z: -15)
	end

	$planets.times do |temp|
		size = rand(10..30)
		planets << p = Image.new( ['crystals/planet1.png', 'crystals/planet2.png', 'crystals/planet3.png',
				'crystals/planet4.png', 'crystals/planet5.png', 'crystals/planet6.png'].sample,
				width: size, height: size, x: rand(0..$width), y: rand($height/2..$height), z: -20) ; p.opacity = rand(0.5..1)
	end

	$comets.times do |temp|
		size = rand(2..10)
		comets << Image.new( ['crystals/comet1.png', 'crystals/comet2.png'].sample,
 						x: rand($width..$width + 700), y: rand(-700..0),
						z: -15, width: size, height: size, color: %w(yellow white #6ba3ff #ff6850).sample)
	end
	$particle.times do particles << Image.new('crystals/1pixel_square.png', y: -10) end

	gradient = Rectangle.new color: %w(black black purple fuchsia), width: $width, height: $height, z: -25
	gradient.opacity = 0.2
	snow = nil
	($width/95).times do |temp| snow = Image.new( 'crystals/snow.png', y: $height - 10, x: temp * 100, z: -14) end
	($width/35).times do sparkles.push magic.call(-12) end
	moon = Image.new  'crystals/moon.png', x: 0, y: $height - 80, width: 100, height: 100 , z: -20
	150.times do |temp| randomparticles[temp] = static.call(rand(4..8)) end
	$flakes.times do |temp|
		size = rand(25..35)
		flakehash << c = Image.new( ['crystals/flake1.png', 'crystals/flake2.png'].sample, x: rand(0..$width),
								y: rand(-1000..0), z: -10, width: size, height: size) ;  c.opacity = rand(0.3..0.7)
	end
	($flakes * 3).times do |temp| flakeparticleshash << magic.call(1) end
	$hoverparticles.times do |temp|
		tempsize = rand(8..15) ; hoverparticles1[temp] = static.call tempsize, 2
		tempsize = rand(8..15) ; hoverparticles2[temp] = static.call tempsize, 2
		tempsize = rand(8..15) ; hoverparticles3[temp] = static.call tempsize, 2
	end

	$magicparticles.times do |temp|
		magicparticles1[temp], magicparticles2[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles3[temp], magicparticles4[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles5[temp], magicparticles6[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles7[temp], magicparticles8[temp] = static.call(rand(8..12)), static.call(rand(8..12))
	end

	100.times do |temp|
		magics << magic.call(-5, 2)
		speeds << rand(2.0..8.0)
 	end

	$staticmagic.times do static.call(rand(4..8)) end
	($spaceships * rand(10..12)).times do |temp|
		tempsize = rand(10..19)
		firepixels << magic.call(-15)
		fireball << img = Image.new( 'crystals/light.png', x: rand(0..$width), y: rand(0..$height),
			z: -15, height: tempsize, width: tempsize) ; img.opacity = 0
	end

	tempsize = rand(80..100)
	light = Image.new  'crystals/light.png', width: tempsize, height: tempsize, x: rand(100..$width - 100), y: 20, z: -20
	mercury, xflag = Image.new( ['crystals/planet3.png', 'crystals/planet5.png'].sample, width: 1, height: 1, x: light.x - light.width/2,
							y: light.y + light.height/2 - 5, z: -21, color: 'black'), 0

	on :mouse_move do |e|
		if timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y) then timelinebool = true else timelinebool = false end
		datelinebool = datelabel.contains?(e.x, e.y) ? true : false
		daylinebool = daylabel.contains?(e.x, e.y) ? true : false
		for val in flakehash do val.opacity = 0 if val.contains?(e.x, e.y) end
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

		key = rand(0...$hoverparticles)
		hoverparticles1[key].opacity = hoverparticles2[key].opacity = hoverparticles3[key].opacity = rand(0.7..1)
		hoverparticles1[key].x, hoverparticles1[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles2[key].x, hoverparticles2[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles3[key].x, hoverparticles3[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles1[key].color = hoverparticles2[key].color = hoverparticles3[key].color = 'white'
		for val in particles do val.opacity = 0 if val.contains?(e.x, e.y) end
		for val in spacecrafts do if val.contains?(e.x, e.y) then spaceshiphover = val ; break end end
	end
	on :mouse_down do |e|
		if e.button == :left
			if customtext1.contains?(e.x, e.y) then customtext1drag = true
			elsif customtext2.contains?(e.x, e.y) then customtext2drag = true
			elsif datelabel.contains?(e.x, e.y)
				dateformatswitch += 1
				dateformat = dateformatswitch % 2 == 0 ? dateformat = t.call('%D') : t.call('%d/%m/%y')
			elsif timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y)
				timelabelswitch += 1
				if timelabelswitch % 2 == 0 then timeformat, ampm.opacity = '%I:%M:%S:%N', 1
					else timeformat, ampm.opacity = '%T:%N', 0 end
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
			bg.change_colour [$generate_colour.call, $generate_colour.call, $generate_colour.call, $generate_colour.call]
		end
	end

	on :mouse_up do |e| customtext1drag, customtext2drag = false, false end
	on :mouse_scroll do |e|
		bg.opacity += 0.2 if e.delta_y == -1 and bg.opacity <= 1
		if e.delta_y == 1
			bg.opacity -= 0.2 if bg.opacity >= 0
			particles.each do |val| val.opacity = 0 end
			flakehash.each do |val| val.opacity = 0 end
		end
	end

	on :key_down do |k|
		if k.key == 'space'
			if bg.opacity > 0
				bg.opacity = 0
				greetlabel.text = 'Press Space Again to Restore Brightness'
				greetlabel1.text = 'Press Space Again to Restore Brightness'
				greetlabel.x = $width/2 - greetlabel.width/2
				greetlabel1.x = $width/2 - greetlabel1.width/2
				greetlabel.opacity = greetlabel1.opacity = 1.5
				particles.each do |val| val.opacity = 0 end
				flakehash.each do |val| val.opacity = 0 end
			elsif bg.opacity <= 0
				bg.opacity = 1
				greetlabel.text = 'Press Space Again to Lower Brightness'
				greetlabel1.text = 'Press Space Again to Lower Brightness'
				greetlabel.x = $width/2 - greetlabel.width/2
				greetlabel1.x = $width/2 - greetlabel1.width/2
				greetlabel.opacity = greetlabel1.opacity = 1.5
			end
		end

		Thread.new { system('ruby', 'Subwindows/properties.rb', "#{$defaultcolours}") } if 'cs'.include?(k.key)

		if k.key == 'up'
			bg.opacity += 0.2 if bg.opacity < 1
			particles.each do |val| val.opacity = 0 end
		end

		if k.key == 'down'
			bg.opacity -= 0.2 if bg.opacity > 0
			particles.each do |val| val.opacity = 0 end
			flakehash.each do |val| val.opacity = 0 end
		end

		if ['right', 'left'].include?(k.key)
			for key in 0...$hoverparticles
				hoverparticles1[key].color = hoverparticles2[key].color = hoverparticles3[key].color = 'white'
				hoverparticles1[key].x, hoverparticles1[key].y = rand(0..$width), rand(0..$height)
				hoverparticles2[key].x, hoverparticles2[key].y = rand(0..$width), rand(0..$height)
				hoverparticles3[key].x, hoverparticles3[key].y = rand(0..$width), rand(0..$height)
			end
		end

		exit if ['escape', 'q', 'p'].include?(k.key)

		Thread.new { system('ruby', 'main.rb') } if ['right shift', 'left shift'].include?(k.key)

		Thread.new { system('ruby', 'Subwindows/about.rb') } if ['a', 'i'].include?(k.key)

		if ['left alt', 'right alt', 'right ctrl', 'left ctrl', 'tab'].include?(k.key)
			for val in spacecrafts do val.x, val.y = rand(0..$width), rand(0..$height + 1000) end
			for val in planets do val.x, val.y = rand(0..$width), rand($height/2..$height) end
			light.x, light.y = rand(100..$width - 100), 20
			mercury.x, mercury.y = light.x - light.width/2, light.y + light.height/2
			mercury.width, mercury.height = 1, 1
			movealpha = false
			customtext1.x, customtext1.y = $width/2 - customtext1.width/2, greetlabel.y - customtext1.height
			customtext2.x, customtext2.y = $width/2 - customtext2.width/2, greetlabel1.y + greetlabel1.height
			bg.change_colour $defaultcolours
		end
	end
	sparkles.each do |val| val.color = 'white' end
	air_direction = [-1, 0, 1].sample
	update do
		i += 1
		air_direction = [-1, 0, 1].sample if i % 600 == 0

		if movealpha then customemove.opacity += 0.03 if customemove.opacity < 1 else customemove.opacity -= 0.05 if customemove.opacity > 0 end
		if spaceshiphover.y > 0 then spaceshiphover.y -= 10 else spaceshiphover = nil end if spaceshiphover

		ampm.text = t.call('%r')[-3..-1]

		if bg.opacity < 1
			for val in flakeparticleshash.first(30) do
				val.x, val.y = rand(0..$width), rand(0..$height) ; val.change_colour('white', 'yellow')
			end

			crystals.each do |val|
				samplespark = sparkles.sample
				samplespark.x, samplespark.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height)
			end

			if xflag != 1
				mercury.width -= 0.1 ; mercury.height -= 0.1
			else
				mercury.width += 0.1 ; mercury.height += 0.1
			end

			if mercury.x > light.x + light.width then xflag, mercury.z = -1, -20
				elsif mercury.x < light.x then xflag, mercury.z = 1, -21
			end

			mercury.x += xflag

			if (mercury.x >= light.x + light.width/3 and mercury.x <= light.x + light.width/2) and xflag == -1 then light.b = light.g = rand(0.6..1)
				else light.b = light.g = 1
			end

			particleswitch = false

			for val in comets
				val.x -= rand(1..2) + Math.sin(i/[-2, -1, 1, 2].sample)
				val.y += rand(1..2)
				if val.y >= $height + val.height
					val.x, val.y = rand($width..$width + 700), rand(-700..0)
					val.color, val.width, val.height = %w(yellow white #6ba3ff #ff6850).sample, rand(4..8), rand(4..8)
				end
			end

			spacecrafts.each_with_index do |c, index|
				c.y -= spacecrafts_speed[index]
				c.width, c.height = spacecrafs_size[index]
				fires[index].x, fires[index].y = c.x + c.width/2 + Math.sin(i) - 10, c.y + c.height + Math.cos(i)
				temp = rand(0...fireball.length)
					fireball[temp].width = fireball[temp].height = rand(15.0..19.0)
					fireball[temp].opacity, fireball[temp].x = 1, rand(fires[index].x..fires[index].x + fires[index].width - fireball[temp].width)
					fireball[temp].y, fireball[temp].color = rand(fires[index].y..fires[index].y + fires[index].height), '#00ff00'

					firepixels[temp].opacity, firepixels[temp].x = 1, rand(fires[index].x..fires[index].x + fires[index].width)
					firepixels[temp].y = rand(fires[index].y..fires[index].y + fires[index].height)
				if c.y < -c.height then c.x, c.y = rand(0..$width), rand($height..$height + 1000)
				end
			end

			fireball.each do |val|
				val.r += 0.15 if val.r <= 1
				val.b += 0.08 if val.b <= 1
				val.g -= 0.1 if val.g <= 1
				val.opacity -= 0.025
				val.width -= 0.1
				val.height -= 0.1
				if val.opacity <= 0.5 then val.color = 'white' end
				val.x += air_direction
			end

			firepixels.each do |val|
				val.x += air_direction * 1.5
				val.opacity -= 0.005
				val.change_colour
			end
		else
			particleswitch = true
			flakehash.each do |val|
				if val.y < $height - val.height/2 and (val.x > -val.height and val.x < $width) and val.opacity > 0
					val.x += air_direction
					val.y += 1 + air_direction.abs
					unless air_direction == 0 then val.rotate += air_direction * 3 else val.rotate += 1 end
					psample = flakeparticleshash.sample
					psample.x, psample.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height +  10)
					psample.change_colour('white')
				else
					val.opacity -= 0.005
					val.x, val.y, val.opacity = rand(0..$width), rand(-1000..0), rand(0.3..0.7) if i % 420 == 0
					size = rand(25..35)
					val.width = val.height = size
				end
			end
		end
		if timelinebool
			timeline.x1 -= 20 if timeline.x1 > timelabel.x
			timeline.x2 += 20 if timeline.x2 < timelabel.x + timelabel.width
			timelabel.y -= 1 if timelabel.y > $height/2 - timelabel.height/2 - 10
			timeline.y1 = timeline.y2 = timelabel.y + timelabel.height - 25
			timelabel.color = timeline.color = '#4cff99'
			ampm.y -= 1 if ampm.y > timelabel.y
		else
			timeline.x1 += 10 if timeline.x1 < timelineparam
			timeline.x2 -= 10 if timeline.x2 > timeline.x1
			timeline.x2 += 1 if timeline.x2 < timeline.x1
			timelabel.y += 1 if timelabel.y < $height/2 - timelabel.height/2
			timeline.y1 = timeline.y2 = timelabel.y + timelabel.height - 25
			timelabel.color = timeline.color = 'white'
			ampm.y += 1 if ampm.y < timelabel.y
		end
		if daylinebool
			dayline.x1 -= 10 if dayline.x1 > daylabel.x
			dayline.x2 += 10 if dayline.x2 < daylabel.x + daylabel.width
			daylabel.y -= 1 if daylabel.y > timelabel.y - daylabel.height - 10
			dayline.y1 = dayline.y2 = daylabel.y + daylabel.height - 15
			daylabel.color = dayline.color = 'lime'
		else
			dayline.x1 += 5 if dayline.x1 < daylineparam
			dayline.x2 -= 5 if dayline.x2 > dayline.x1
			dayline.x2 += 1 if dayline.x2 < dayline.x1
			daylabel.y += 1 if daylabel.y < timelabel.y - daylabel.height
			dayline.y1 = dayline.y2 = daylabel.y + daylabel.height - 15
			daylabel.color = dayline.color = 'white'
		end
		if datelinebool
			dateline.x1 -= 10 if dateline.x1 > datelabel.x
			dateline.x2 += 10 if dateline.x2 < datelabel.x + datelabel.width
			datelabel.y -= 1 if datelabel.y > timelabel.y + timelabel.height - 10
			dateline.y1 = dateline.y2 = datelabel.y + datelabel.height - 15
			datelabel.color = dateline.color = 'lime'
		else
			dateline.x1 += 5 if dateline.x1 < datelineparam
			dateline.x2 -= 5 if dateline.x2 > datelineparam
			dateline.x2 += 1 if dateline.x2 < datelineparam
			datelabel.y += 1 if datelabel.y < timelabel.y + timelabel.height
			dateline.y1 = dateline.y2 = datelabel.y + datelabel.height - 15
			datelabel.color = dateline.color = 'white'
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
		$hoverparticles.times do |key|
			hoverparticles1[key].y -= 1 if hoverparticles1[key].y > -20
			hoverparticles2[key].y += 1 if hoverparticles2[key].y < $height + 5
			hoverparticles3[key].y += 1 if hoverparticles3[key].y < $height + 5
			hoverparticles3[key].x += 1 if hoverparticles3[key].x < $width + 5
			hoverparticles2[key].x -= 1 if hoverparticles2[key].x > -20

			hoverparticles1[key].opacity -= 0.02 ; hoverparticles2[key].opacity -= 0.02 ; hoverparticles3[key].opacity -= 0.02
			hoverparticles1[key].b -= 0.015 ; hoverparticles1[key].g -= 0.015
			hoverparticles2[key].b -= 0.015 ; hoverparticles2[key].g -= 0.015
			hoverparticles3[key].b -= 0.015 ; hoverparticles3[key].g -= 0.015

			hoverparticles1[key].rotate += air_direction * 10
			hoverparticles2[key].rotate -= 10
			hoverparticles3[key].rotate += 10
		end

		timelabel.text = t.call(timeformat)[0..-8]
		daylabel.text = t.call('%A')
		datelabel.text = dateformat
		randomparticles.sample.opacity = [0, 1].sample

		magics.each_with_index do |val, index|
			val.y -= speeds[index]
			val.x += Math.sin(i/speeds[index]) * 2
			val.opacity = [0, 1].sample
			if val.y < -val.height
				val.color = %w(yellow white).sample
				val.x, val.y = rand(0..$width - val.width), $height
			end
		end

		if particleswitch
			for val in particles
				val.rotate += val.width/100.0
				unless val.y <= -val.height or val.opacity <= 0 then val.y -= 1
				else
					val.width = val.height = rand($width/15..$width/10)
					val.y, val.x, val.opacity = rand($height..$height + 1000), rand(0..$width - val.width/2), rand(0.1..0.3)
				end
			end
		end
	end
	Ruby2D::Window.show
end
main
