#!/usr/bin/env ruby
# Written by Sourav Goswami thanks to Ruby2D.

begin
	require_relative 'ruby2d/ruby2d.rb'
	file = File.open('config.conf')
$info = file.readlines
res = $info[0][$info[0].index('=') + 1 .. - 1]
$border = $info[1][$info[1].index('=') + 1 .. - 1].chomp == 'true'
$fullscreen = $info[2][$info[2].index('=') + 1 .. -1].chomp == 'true'
$width, $height= res[0..res.index('x') - 1].to_i, res[res.index('x') + 1..-1].to_i
$defaulttimeformat = $info[3][$info[3].index('=') + 1 .. -1].chomp == '24'
$defaultdateformat = $info[4][$info[4].index('=') + 1 .. - 1].chomp
$defaultcolours = $info[5][$info[5].index('=') + 1 .. -1].chomp
$defaultcolours = $defaultcolours.split(',')
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
rescue LoadError
	STDERR.puts "Uh Oh, Ruby2D is not installed"
	abort
rescue NoMethodError, Errno::ENOENT
	STDERR.puts "Generating the config.conf file with default values."
	file = File.open('config.conf', 'w')
	file.truncate(0)
	file.write <<EOF
resolution=1200x620
borderless=false
fullscreen=false
timeformat=12
dateformat=%d/%m/%y
defaultcolour=#0050a6,purple,aqua,#ff50a6
spaceships=12
static_stars=100
planets=6
comets=10
floating_square=8
magicparticles=4
snow flakes=25
mouse_move_particles=30
fontsize=50
custom text 1=
custom text 1 size=80
custom text 2=
custom text 2 size=100
custom font path=mage/arima.otf
custom font color=#3ce3b4
################################################################################
Help:
Change the above options according to your need.
The available options are:

resolution=WIDTHxHEIGHT
borderless=true/false
fullscreen=true/false
timeformat=24/12
dateformat=%d/%m/%y or %m/%d/%y or %y/%d/%m or %y/%m/%d and so on.
defaultcolour=#0050a6,fuchsia,red,random or your colours
spaceships=1/your number
static_stars=0/your number
planets=0/your number
comets=0/your number
floating_square=0/your number
magicparticles=0/your number
snow flakes=0/your number
mouse_move_particles=1/your number
fontsize=50(tested)/your number
custom text 1=Hello/custom text with no quotation(or the quotes will be displayed)
custom text 1 size=80/your custom number
custom text 2=Welcome!/custom text with no quotation(or the quotes will be displayed)
custom text 2 size=100/custom number
custom font path=mage/arima.otf(default), you can provide your path!
custom font color=white/your colour, it may be a random, or a hex, or an available name. Go to Suggestion 2 for more info.
--------------------------------------------------------------------------------
NOTE 1:	there should be no spaces between '='

NOTE 2:	Changing to an unexpected value may crash the app
		or even may freeze your computer.

NOTE 3:	Don not append a different line before the last value - Anything before the trailing hashes (####) (above)
		You can write anything after that. These current lines are the examples.

NOTE 4:	Too high resolution or spaships, static stars, etc. will cause a
		slowdown. Huge values can even freeze your computer.

NOTE 5: The font size of time will always be 20 pts. larger.

Suggestion 1: Changing the fullscreen to true, and get it working on the
	fullscreen mode may require the resolution to be changed.
	Example: If you have a 1920x1080 monitor, change the resolution to 1920x1080 and then change fullscreen to true.
		The file should look like the following:
			resolution:1920x1080
			borderless=true/false
			fullscreen=true
			... (other options according to your needs)
			(no tabs, spaces, or invalid values after the =. The values after = will get processed).

Suggestion 2: You can use hex colours like as defaultcolour, this will be displayed as the app starts:
	Example:
			defaultcolour=#3ce3b4,#0050a6,fuchsia,purple
	The available colour names are:
			navy, blue, aqua, teal, olive, green, lime, yellow, orange,
			red, brown, fuchsia, purple, maroon, white, silver, gray, black

	Or use the hex code of your favourite colour combinations.

	You can get a single colour by repeating the colour like this:
			defaultcolour=blue,blue,blue,blue

Suggestion 3: You can create random colours, just write random in place of colour names.
	Example:
			defaultcolour=random,purple,teal,#3ce3b5
--------------------------------------------------------------------------------
If the file gets corrupted, or you forget the values after modification, and you find no clue, then delete this config.conf file.
Run the program once, and it should automatically generate this file with the default values.
Just make sure you have proper write access.
EOF
	Thread.new { system('ruby', 'main.rb') }
ensure
	file.close
	at_exit do puts "\033[1;34mThanks for using Colour::Clock! Have a good time!\033[0m" end
end

module Ruby2D
	def r=(val) self.color = [val, self.color.g, self.color.b, self.opacity] end
	def g=(val) self.color = [self.color.r, val, self.color.b, self.opacity] end
	def b=(val) self.color = [self.color.r, self.color.g, val, self.opacity] end
	def r() self.color.r end
	def g() self.color.g end
	def b() self.color.b end
	def random_color(*color)
		opacity = self.opacity
		unless color.empty? then self.color = color.sample else self.color = 'random' end
		self.opacity = opacity
	end
end

def main
	static = -> (size, z=-5) do
		Image.new(path: ['crystals/hoverstars.png', 'crystals/hoverstars1.png', 'crystals/hoverstars2.png', 'crystals/hoverstars3.png', 'crystals/hoverstars4.png',
						'crystals/hoverstars5.png', 'crystals/hoverstars6.png', 'crystals/hoverstars7.png', 'crystals/hoverstars8.png',
						'crystals/hoverstars9.png'].sample, x: rand(0..$width), y: rand(0..$height), width: size, height: size, z: z)
	end
	magic = -> (z=-15, size=rand(1..2)) do Square.new x: rand(0..$width), y: rand(0..$height), z: z, color: %w(yellow white #6ba3ff).sample, size: size end
	generate = lambda { sq = Square.new x: rand(0..$width), y: rand(0..$height + 1000), z: -10, color: 'white', size: rand($height/10..$width/10)
				sq.opacity = rand 0.1..0.3 ; sq }

	set title: "Space::Clock", resizable: true, width: $width, height: $height, borderless: $border, fullscreen: $fullscreen
	t = proc { |format| Time.new.strftime(format) }
	colours = $defaultcolours
	bg = Rectangle.new width: $width, height: $height, color: colours, z: -10

	timelabel = Text.new font: 'mage/arima.otf', text: t.call('%T:%N')[0..-8], size: $fontsize + 20
	timelabel.x, timelabel.y = $width/2 - timelabel.width/2, $height/2 - timelabel.height/2
	timeline = Line.new x1: timelabel.x + timelabel.width/2, x2: timelabel.x + timelabel.width/2,
			y1: timelabel.y + timelabel.height - 20, y2: timelabel.y + timelabel.height - 20, width: 3
	timelineparam = timelabel.x + timelabel.width/2
	timelabelswitch = 1
	ampm = Text.new font: 'mage/arima.otf', text: t.call('%r')[-2..-1]
	ampm.x, ampm.y, ampm.opacity = timelabel.x + timelabel.width - 5, timelabel.y, 0
	timeformat = ('%T:%N') if $defaulttimeformat
	timeformat = '%I:%M:%S:%N' unless $defaulttimeformat
	ampm.opacity = 1 unless $defaulttimeformat
	daylabel = Text.new font: 'mage/arima.otf', text: t.call('%A'), size: $fontsize
	daylabel.x, daylabel.y = $width/2 - daylabel.width/2, timelabel.y - daylabel.height
	dayline = Line.new x1: daylabel.x + daylabel.width/2, x2: daylabel.x + daylabel.width/2,
			y1: daylabel.y + daylabel.height - 20, y2: daylabel.y + daylabel.height - 20, width: 3
	daylineparam = daylabel.x + daylabel.width/2

	datelabel = Text.new font: 'mage/arima.otf', text: t.call('%d/%m/%y'), size: $fontsize
	datelabel.x, datelabel.y = $width/2 - datelabel.width/2, timelabel.y + timelabel.height
	dateline = Line.new x1: datelabel.x + datelabel.width/2, x2: datelabel.x + datelabel.width/2,
			y1: datelabel.y + datelabel.height - 20, y2: datelabel.y + datelabel.height - 20, width: 3
	datelineparam = datelabel.x + datelabel.width/2
	dateformat = t.call($defaultdateformat)
	dateformatswitch = 1

	greetlabel = Text.new font: 'mage/MateSC-Regular.ttf', text: "Welcome to Space Clock", size: 50
	greetlabel.x, greetlabel.y, greetlabel.opacity = $width/2 - greetlabel.width/2, daylabel.y - greetlabel.height, 1.5

	greetlabel1 = Text.new font: 'mage/MateSC-Regular.ttf', text: "Welcome to Space Clock", size: 50
	greetlabel1.x, greetlabel1.y, greetlabel1.opacity = $width/2 - greetlabel1.width/2, datelabel.y + datelabel.height, 1.5

	greetflag = [-10, 10].sample
	customemove = Image.new path: 'crystals/moveicon.png', z: 1
	customemove.opacity, movealpha = 0, false

	customtext1 = Text.new font: $customfont, text: $customtext1, size: $customsize1, color: $customfontcolour
	customtext1.x, customtext1.y = $width/2 - customtext1.width/2, greetlabel.y - customtext1.size
	customtext1drag = false

	customtext2 = Text.new font: $customfont, text: $customtext2, size: $customsize2, color: $customfontcolour
	customtext2.x, customtext2.y = $width/2 - customtext2.width/2, greetlabel1.y + greetlabel1.size
	customtext2drag = false

	spacecrafts, fires, firepixels, comets, sparkles = [], {}, {}, {}, []
	crystals = {}
	Thread.new {
		for temp in 0..($width/35)
			tempsize = rand(30..40)
			Image.new path: ['crystals/crystal1.png', 'crystals/crystal2.png', 'crystals/crystal3.png', 'crystals/crystal4.png', ].sample,
						width: tempsize, height: tempsize, x: temp * rand(tempsize - 2.0..tempsize + 2.0), y: $height - tempsize - 10, z: -15

			tempsize = rand(30..40)
			crystals[temp] = Image.new(path: 'crystals/crystal3.png', width: tempsize, height: tempsize, x: temp * rand(40.0..45.0), y: $height - tempsize - 10,
				z: -15, color: %w(yellow aqua white).sample)
		end

		($width/150).times do
			tempsize = rand(14..16)
			specialstar = Image.new path: ['crystals/specialstar.png', 'crystals/specialstar2.png', 'crystals/specialstar3.png'].sample,
					x: rand(0..$width), z: -[15,16].sample, width: tempsize, height: tempsize
			specialstar.y = $height - 10 - specialstar.height + tempsize/3
		end
		Image.new path: 'crystals/galaxy2.png', y: $height - 150, z: -25, x: rand(0..$width - 50)
		Image.new path: 'crystals/galaxy3.png', y: 50, z: -25, x: rand(0..$width - 50), width: $height/10, height: $height/10
	}

	galaxy = Image.new path: 'crystals/galaxy1.png', y: 0, z: -25, width: timelabel.width * 2, height: timelabel.width
	galaxy.x, galaxy.y = $width/2 - galaxy.width/2, $height/2 - galaxy.height/2

	$spaceships.times do |temp|
		spacecrafts << Image.new(path: ['crystals/spacecraft1.png', 'crystals/spacecraft2.png',
					'crystals/spacecraft3.png', 'crystals/spacecraft4.png',
					'crystals/spacecraft5.png', 'crystals/spacecraft6.png'].sample,
					x: rand(0..$width), y: rand($height..$height + 2000), width: 25, height: 40, z: -15)
		fires[temp] = Image.new(path:
						['crystals/fireball1.png', 'crystals/fireball2.png',
						'crystals/fireball3.png', 'crystals/fireball4.png',
						'crystals/fireball5.png', 'crystals/fireball6.png'].sample, x: rand(0..$width), y: rand(0..$width), z: -15)
	end

	planets = {}
	$planets.times do |temp|
		size = rand(10..30)
		planets[temp] = planet = Image.new(path: ['crystals/planet1.png', 'crystals/planet2.png', 'crystals/planet3.png',
				'crystals/planet4.png', 'crystals/planet5.png', 'crystals/planet6.png'].sample,
				width: size, height: size, x: rand(0..$width), y: rand($height/2..$height), z: -20) ; planet.opacity = rand(0.5..1)
	end
	$comets.times do |temp|
		size = rand(2..10)
		comets[temp] = Image.new(path: ['crystals/comet1.png', 'crystals/comet2.png'].sample,
 						x: rand($width..$width + 700), y: rand(-700..0),
						z: -15, width: size, height: size, color: %w(yellow white #6ba3ff #ff6850).sample)
	end
	particles, particleswitch, randomparticles, hoverparticles1, hoverparticles2, hoverparticles3 = {}, true, {}, {}, {}, {}
	hoverparticles4, hoverparticles5, hoverparticles6 = {}, {}, {}
	magicparticles1, magicparticles2, magicparticles3, magicparticles4 = {}, {}, {}, {}
	magicparticles5, magicparticles6, magicparticles7, magicparticles8, flakehash, flakeparticleshash = {}, {}, {}, {}, {}, {}

	$particle.times do |temp| particles[temp] = generate.call end

	gradient = Rectangle.new color: %w(black black purple fuchsia), width: $width, height: $height, z: -25
	gradient.opacity = 0.2
	snow = nil
	($width/95).times do |temp| snow = Image.new(path: 'crystals/snow.png', y: $height - 10, x: temp * 100, z: -14) end
	($width/35).times do |temp| sparkles.push(static.call(4, -12)) end
	moon = Image.new path: 'crystals/moon.png', x: 0, y: $height - 80, width: 100, height: 100 , z: -20
	fireball = {}
	150.times do |temp| randomparticles[temp] = static.call(rand(4..8)) end
	$flakes.times do |temp|
		size = rand(25..35)
		flakehash[temp] = c = Image.new(path: ['crystals/flake1.png', 'crystals/flake2.png'].sample, x: rand(0..$width),
								y: rand(-1000..0), z: -10, width: size, height: size) ;  c.opacity = rand(0.3..0.7)
	end
	($flakes * 5).times do |temp| flakeparticleshash[temp] = magic.call(1) end
	$hoverparticles.times do |temp|
		tempsize = rand(8..15)
		hoverparticles1[temp] = static.call(tempsize, 2)
		tempsize = rand(8..15)
		hoverparticles2[temp] = static.call(tempsize, 2)
		tempsize = rand(8..15)
		hoverparticles3[temp] = static.call(tempsize, 2)
		hoverparticles4[temp], hoverparticles5[temp], hoverparticles6[temp] = magic.call(2), magic.call(2), magic.call(2)
	end

	$magicparticles.times do |temp|
		magicparticles1[temp], magicparticles2[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles3[temp], magicparticles4[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles5[temp], magicparticles6[temp] = static.call(rand(8..12)), static.call(rand(8..12))
		magicparticles7[temp], magicparticles8[temp] = static.call(rand(8..12)), static.call(rand(8..12))
	end

	magic1, magic2, magic3, magic4, magic5, magic6 = [], [], [], [], [], []
	rand(15..25).times do |temp|
		magic1 << magic.call(-5) ; magic2 << magic.call(-5) ; magic3 << magic.call(-5)
		magic4 << magic.call(-5) ; magic5 << magic.call(-5) ; magic6 << magic.call(-5)
 	end
	$staticmagic.times do static.call(rand(4..8)) end
	($spaceships * rand(12..15)).times do |temp|
		tempsize = rand(10..19)
		firepixels[temp] = magic.call(-15)
		fireball[temp] = img = Image.new path: 'crystals/light.png', x: rand(0..$width), z: -15, height: tempsize, width: tempsize ; img.opacity = 0
	end

	tempsize = rand(80..100)
	light = Image.new path: 'crystals/light.png', width: tempsize, height: tempsize, x: rand(100..$width - 100), y: 20, z: -20
	mercury, xflag = Image.new(path: ['crystals/planet3.png', 'crystals/planet5.png'].sample, width: 1, height: 1, x: light.x - light.width/2,
							y: light.y + light.height/2 - 5, z: -21, color: 'black'), 0
	i, spaceshiphover = 0, nil
	timelinebool, datelinebool, daylinebool = false, false, false

	on :mouse_move do |e|
		if timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y) then timelinebool = true else timelinebool = false end
		if datelabel.contains?(e.x, e.y) then datelinebool = true else datelinebool = false end
		if daylabel.contains?(e.x, e.y) then daylinebool = true else daylinebool = false end
		for val in flakehash.values do val.opacity -= 0.1 if val.contains?(e.x, e.y) end
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
		hoverparticles4[key].opacity = hoverparticles5[key].opacity = hoverparticles6[key].opacity = rand(0.7..1)
		hoverparticles1[key].x, hoverparticles1[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles2[key].x, hoverparticles2[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles3[key].x, hoverparticles3[key].y = rand(e.x - 5..e.x + 5), rand(e.y - 5..e.y + 5)
		hoverparticles4[key].x, hoverparticles4[key].y = rand(e.x - 10..e.x + 20), rand(e.y - 10..e.y + 20)
		hoverparticles5[key].x, hoverparticles5[key].y = rand(e.x - 10..e.x + 20), rand(e.y - 10..e.y + 20)
		hoverparticles6[key].x, hoverparticles6[key].y = rand(e.x - 10..e.x + 20), rand(e.y - 10..e.y + 20)
		hoverparticles1[key].color = hoverparticles2[key].color = hoverparticles3[key].color = 'white'
		hoverparticles4[key].color = hoverparticles5[key].color = hoverparticles6[key].color = 'white'
		for val in particles.values do val.opacity = 0 if val.contains?(e.x, e.y) end
		for val in spacecrafts do
			if val.contains?(e.x, e.y)
				spaceshiphover = val
				break
			end
		end
	end
	on :mouse_down do |e|
		if e.button == :left
			if customtext1.contains?(e.x, e.y) then customtext1drag = true
			elsif customtext2.contains?(e.x, e.y) then customtext2drag = true
			elsif datelabel.contains?(e.x, e.y)
				dateformatswitch += 1
				if dateformatswitch % 2 == 0 then dateformat = t.call('%D')
					else dateformat = t.call('%d/%m/%y') end
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
			bg.color = %w(green blue fuchsia purple teal #ff50a6 blue #00e3d5 #3ce3d4).sample(4)
		end
	end

	on :mouse_up do |e| customtext1drag, customtext2drag = false, false end
	on :mouse_scroll do |e|
		if e.delta_y == -1
			bg.opacity += 0.2 if bg.opacity <= 1
		end
		if e.delta_y == 1
			bg.opacity -= 0.2 if bg.opacity >= 0
			particles.values.each do |val| val.opacity = 0 end
			flakehash.values.each do |val| val.opacity = 0 end
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
				particles.values.each do |val| val.opacity = 0 end
				flakehash.values.each do |val| val.opacity = 0 end
			elsif bg.opacity <= 0
				bg.opacity = 1
				greetlabel.text = 'Press Space Again to Lower Brightness'
				greetlabel1.text = 'Press Space Again to Lower Brightness'
				greetlabel.x = $width/2 - greetlabel.width/2
				greetlabel1.x = $width/2 - greetlabel1.width/2
				greetlabel.opacity = greetlabel1.opacity = 1.5
			end
		end
		Thread.new { system('ruby', 'Subwindows/properties.rb', "#{colours}") } if 'cs'.include?(k.key)
		if k.key == 'up'
			bg.opacity += 0.2 if bg.opacity < 1
			particles.values.each do |val| val.opacity = 0 end
		end

		if k.key == 'down'
			bg.opacity -= 0.2 if bg.opacity > 0
			particles.values.each do |val| val.opacity = 0 end
			flakehash.values.each do |val| val.opacity = 0 end
		end

		if ['right', 'left'].include?(k.key)
			for key in 0...$hoverparticles
				hoverparticles1[key].opacity = hoverparticles2[key].opacity = hoverparticles3[key].opacity = rand(0.7..1)
				hoverparticles4[key].opacity = hoverparticles5[key].opacity = hoverparticles6[key].opacity = rand(0.7..1)
				hoverparticles1[key].x, hoverparticles1[key].y = rand(0..$width), rand(0..$height)
				hoverparticles2[key].x, hoverparticles2[key].y = rand(0..$width), rand(0..$height)
				hoverparticles3[key].x, hoverparticles3[key].y = rand(0..$width), rand(0..$height)
				hoverparticles4[key].x, hoverparticles4[key].y = rand(0..$width), rand(0..$height)
				hoverparticles5[key].x, hoverparticles5[key].y = rand(0..$width), rand(0..$height)
				hoverparticles6[key].x, hoverparticles6[key].y = rand(0..$width), rand(0..$height)
			end
		end
		exit if ['escape', 'q', 'p'].include?(k.key)
		Thread.new { system('ruby', 'main.rb') } if ['right shift', 'left shift'].include?(k.key)

		if ['left alt', 'right alt', 'right ctrl', 'left ctrl', 'tab'].include?(k.key)
			for val in spacecrafts do val.x, val.y = rand(0..$width), rand(0..$height + 1000) end
			for val in planets.values do val.x, val.y = rand(0..$width), rand($height/2..$height) end
			light.x, light.y = rand(100..$width - 100), 20
			mercury.x, mercury.y = light.x - light.width/2, light.y + light.height/2
			mercury.width, mercury.height = 1, 1
			movealpha = false
			customtext1.x, customtext1.y = $width/2 - customtext1.width/2, greetlabel.y - customtext1.height
			customtext2.x, customtext2.y = $width/2 - customtext2.width/2, greetlabel1.y + greetlabel1.height
			bg.random_color colours
		end

		Thread.new { system('ruby', 'Subwindows/about.rb') } if ['a', 'i'].include?(k.key)
	end

	air_direction = [-1, 0, 1].sample
	update do
		i += 1
		fireball.values.each do |val|
			val.r += 0.15 if val.r <= 1
			val.b += 0.08 if val.b <= 1
			val.g -= 0.1 if val.g <= 1
			val.opacity -= 0.025
			val.x += air_direction
		end
		firepixels.values.each do |val|
			val.x += air_direction * 1.5
			val.opacity -= 0.01
			val.random_color
		end
		if movealpha then customemove.opacity += 0.03 if customemove.opacity < 1 else customemove.opacity -= 0.05 if customemove.opacity > 0 end
		air_direction = [-1, 0, 1].sample if i % 600 == 0
		if spaceshiphover.y > 0 then spaceshiphover.y -= 10 else spaceshiphover = nil end if spaceshiphover
		ampm.text = t.call('%r')[-3..-1]
		if bg.opacity < 1
			for val in flakeparticleshash.values do val.x, val.y = rand(0..$width), rand(0..$height) ; val.random_color end
			crystals.values.each do |val|
				samplespark = sparkles.sample
				samplespark.x = rand(val.x..val.x + val.width)
				samplespark.y = rand(val.y..val.y + val.height)
			end
			if xflag != 1
				mercury.width -= 0.1
				mercury.height -= 0.1
			else
				mercury.width += 0.1
				mercury.height += 0.1
			end
			if mercury.x > light.x + light.width
				xflag = -1
				mercury.z = -20
			elsif mercury.x < light.x then xflag, mercury.z = 1, -21
			end
			mercury.x += xflag
			if (mercury.x >= light.x + light.width/3 and mercury.x <= light.x + light.width/2) and xflag == -1 then light.b = light.g = rand(0.6..1)
			else light.b = light.g = 1
			end
			particleswitch = false
			for val in comets.values
				val.x -= rand(1..2) + Math.sin(i/[-2, -1, 1, 2].sample)
				val.y += rand(1..2)
				if val.y >= $height + val.height
					val.x, val.y = rand($width..$width + 700), rand(-700..0)
					val.color, val.width, val.height = %w(yellow white #6ba3ff #ff6850).sample, rand(4..8), rand(4..8)
				end
			end
			engine = 0
			for c in spacecrafts[0..spacecrafts.size/3]
				c.y -= 3
				c.width, c.height = 12, 20
				fires[engine].x, fires[engine].y = c.x + c.width/2 + Math.sin(i) - 10, c.y + c.height + Math.cos(i)
				temp = rand(0...fireball.length)
					fireball[temp].opacity, fireball[temp].x = 1, rand(fires[engine].x..fires[engine].x + fires[engine].width - fireball[temp].width)
					fireball[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
					fireball[temp].color = '#00ff00'
					firepixels[temp].opacity = 1
					firepixels[temp].x = rand(fires[engine].x..fires[engine].x + fires[engine].width)
					firepixels[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
				if c.y < -c.height
					c.y = rand($height..$height + 1000)
					c.x = rand(0..$width)
					c.color = 'white'
				end
				engine += 1
			end
			for c in spacecrafts[spacecrafts.size/3 + 1..spacecrafts.size/2]
				c.y -= 7
				fires[engine].x, fires[engine].y = c.x + c.width/2 + Math.sin(i) - 10, c.y + c.height + Math.cos(i)
				temp = rand(0...fireball.length)
					fireball[temp].opacity, fireball[temp].x = 1, rand(fires[engine].x..fires[engine].x + fires[engine].width - fireball[temp].width)
					fireball[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
					fireball[temp].color = '#00ff00'
					firepixels[temp].x = rand(fires[engine].x..fires[engine].x + fires[engine].width)
					firepixels[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
				if c.y < -c.height
					c.y = rand($height..$height + 1000)
					c.x = rand(0..$width)
					c.color = 'white'
				end
				engine += 1
			end
			for c in spacecrafts[spacecrafts.size/2 + 1..-1]
				c.y -= 5
				c.width, c.height = 18, 30
				fires[engine].x, fires[engine].y = c.x + c.width/2 + Math.sin(i) - 10, c.y + c.height + Math.cos(i)
				temp = rand(0...fireball.length)
					fireball[temp].opacity, fireball[temp].x = 1, rand(fires[engine].x..fires[engine].x + fires[engine].width - fireball[temp].width)
					fireball[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
					fireball[temp].color = '#00ff00'
					firepixels[temp].x = rand(fires[engine].x..fires[engine].x + fires[engine].width)
					firepixels[temp].y = rand(fires[engine].y..fires[engine].y + fires[engine].height)
				if c.y < -c.height
					c.y = rand($height..$height + 1000)
					c.x = rand(0..$width)
					c.color = 'white'
				end
				engine += 1
			end
		else
			particleswitch = true
			flakehash.values.each do |val|
				if val.y < $height - val.height/2 and (val.x > -val.height and val.x < $width) and val.opacity > 0
					val.x += air_direction
					val.y += 1 + air_direction.abs
					psample = flakeparticleshash.values.sample
					psample.x, psample.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height +  10)
					psample.random_color('white')
				else
					val.opacity -= 0.005
					val.x, val.y, val.opacity = rand(0..$width), rand(-1000..0), rand(0.3..0.7) if i % 360 == 0
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

		for val in magicparticles1.values  do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles2.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles3.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles4.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles5.values  do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles6.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles7.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		for val in magicparticles8.values do val.x, val.y = rand(0..$width), rand(0..$height) if val.x < -val.width or val.y < -val.height end
		$hoverparticles.times do |key|
			hoverparticles1[key].y -= 1 if hoverparticles1[key].y > -20
			hoverparticles4[key].y += 1 if hoverparticles4[key].y > -20

			hoverparticles2[key].y += 1 if hoverparticles2[key].y < $height + 5

			hoverparticles3[key].y += 1 if hoverparticles3[key].y < $height + 5

			hoverparticles3[key].x += 1 if hoverparticles3[key].x < $width + 5
			hoverparticles6[key].x += 1 if hoverparticles6[key].x < $width + 5

			hoverparticles2[key].x -= 1 if hoverparticles2[key].x > -20
			hoverparticles5[key].x -= 1 if hoverparticles5[key].x > -20

			hoverparticles1[key].opacity -= 0.02
			hoverparticles2[key].opacity -= 0.02
			hoverparticles3[key].opacity -= 0.02
			hoverparticles4[key].opacity -= 0.03
			hoverparticles5[key].opacity -= 0.03
			hoverparticles6[key].opacity -= 0.03

			hoverparticles1[key].b -= 0.025 if hoverparticles1[key].b > 0.5
			hoverparticles1[key].g -= 0.01
			hoverparticles2[key].b -= 0.025
			hoverparticles2[key].g -= 0.01
			hoverparticles3[key].b -= 0.02
			hoverparticles3[key].g -= 0.01
		end
		$magicparticles.times do |key|
			magicparticles1[key].x -= 1
			magicparticles1[key].y -= 1
			magicparticles2[key].x += 1
			magicparticles2[key].y -= 1
			magicparticles3[key].x -= 1
			magicparticles3[key].y += 1
			magicparticles4[key].x += 1
			magicparticles4[key].y += 1
			magicparticles5[key].x -= 1
			magicparticles6[key].x += 1
			magicparticles7[key].y -= 1
			magicparticles8[key].y += 1
		end
		timelabel.text = t.call(timeformat)[0..-8]
		daylabel.text = t.call('%A')
		datelabel.text = dateformat
		randomparticles.values.sample.opacity = [0, 1].sample
		val.x = 0 if val.x > $width

		for val in magic1
			unless val.y <= -val.y
				val.y -= 4
				val.x += Math.cos(i/10)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if i % rand(1..10) == 0
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic2
			unless val.y <= -val.y
				val.y -= 5
				val.x += Math.sin(i/20)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if i % rand(1..10) == 0
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
				val.color = %w(yellow white #6ba3ff #ff6850).sample if i % rand(1..10) == 0
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic4
			unless val.y <= -val.y
				val.y -= 4
				val.x += Math.sin(i/12)
				val.color = %w(yellow white #6ba3ff #ff6850).sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		for val in magic5
			unless val.y <= -val.y
				val.y -= 2
				val.color = %w(yellow white #6ba3ff #ff6850).sample
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff #ff6850).sample(4), rand(1..2)
			end
		end
		for val in magic6
			unless val.y <= -val.y
				val.y -= 8
				val.x += Math.sin(i)
				val.color = %w(yellow white #6ba3ff #ff6850).sample if i % rand(1..10) == 0
			else
				val.y, val.x = rand($height..$height + 100), rand(1..$width - 1)
				val.color, val.size = %w(yellow white #6ba3ff).sample, rand(1..2)
			end
		end
		if particleswitch
			for val in particles.values
				unless val.y <= -val.height or val.opacity <= 0 then val.y -= 1
				else val.y, val.x, val.opacity = rand($height..$height + 1000), rand(0..$width - val.width/2), rand(0.1..0.3)
				end
			end
		end
	end
	show
end
main
