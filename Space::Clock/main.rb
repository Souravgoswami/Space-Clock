#!/usr/bin/ruby -w
# Written by Sourav Goswami thanks to Ruby2D.
# The GNU General Public License v3.0

PATH = File.dirname(__FILE__)
FONT = File.join(PATH, 'mage', 'arima.otf')
FONT2 = File.join(PATH, 'mage', 'MateSC-Regular.ttf')

begin
	%w(ruby2d securerandom open3).each { |el| require(el) }

 	file= File.readlines(File.join(PATH, 'config.conf'))
	conversion = ->(option) { file.select { |i| i.strip.start_with?(option.to_s) }[-1].to_s.split('=')[-1].to_s.strip }

	$width, $height= conversion.call(:Width).to_i, conversion.call(:Height).to_i
	$fps = conversion.call(:FPS).to_i
	$border = conversion.call(:Borderless) == 'true'
	$fullscreen = conversion.call(:Fullscreen) == 'true'
	$defaulttimeformat = conversion.call(:Time_Format).to_i
	$defaultdateformat = conversion.call(:Date_Format)
	$defaultcolours = conversion.call(:Default_Colours).split(',')
	$spaceships = conversion.call(:Spaceships).to_i
	$staticmagic = conversion.call(:Static_Stars).to_i
	$planets = conversion.call(:Planets).to_i
	$comets = conversion.call(:Comets).to_i
	$particle = conversion.call(:Floating_Squares).to_i
	$magicparticles = conversion.call(:Magic_Particles).to_i
	$flakes = conversion.call(:Snow_Flakes).to_i
	$hoverparticles = conversion.call(:Mouse_Move_Particles).to_i
	$fontsize = conversion.call(:Font_Size).to_i
	$customtext1 = conversion.call(:Custom_Text_1)
	$customsize1 = conversion.call(:Custom_Text1_Size).to_i
	$customtext2 = conversion.call(:Custom_Text_2)
	$customsize2 = conversion.call(:Custom_Text2_Size).to_i
	$customfont = conversion.call(:Custom_Font_Path)
	$customfontcolour = conversion.call(:Custom_Font_Colour)
	$customfont = FONT if $customfont.empty? || !File.readable?($customfont)

	$start_time = Time.new.strftime('%s').to_i

rescue LoadError
	warn "Uh Oh, Ruby2D is not installed. Please read the instruction.txt file in this directory"
	abort

rescue NoMethodError, Errno::ENOENT
	warn 'The config.conf file is either missing, or has wrong content. Generating a fresh config.conf file with default values.'
	Thread.new { puts Open3.capture2e('ruby', File.join(PATH, 'Subwindows', 'conf_generator.rb')) }
	warn 'Generated config.conf file with the default values'
	warn "Launching a new #{__FILE__} window"
	puts Open3.capture2e('ruby', __FILE__)
	warn "Exiting main #{__FILE__}"
	exit! 0
end

END {
	run_for = Time.new.strftime('%s').to_i - $start_time
	hour, minute, second = run_for / 3600, run_for % 3600 / 60, run_for % 60
	puts "Thanks for using Space::Clock for #{hour} hour#{hour == 1 ? '' : 's'}, #{minute} minute#{minute == 1 ? '' : 's'}, #{second} second#{second == 1 ? '': 's'}."
	puts 'Have a Good Day!!'
}

module Ruby2D
	define_method(:change_colour) do |colour = "##{SecureRandom.hex(3)}"|
		self.color, self.opacity = colour, opacity
	end
end

define_method(:main) do
	set title: "Space::Clock", resizable: true, width: $width, height: $height, borderless: $border, fullscreen: $fullscreen, fps_cap: $fps
	bg = Rectangle.new width: $width, height: $height, color: $defaultcolours, z: -10

	static = -> (size, z=-5) { Image.new(File.join(PATH, 'crystals', 'hoverstars' + rand(1..10).to_s + '.png'), x: rand($width), y: rand($height), width: size, height: size, z: z) }
	magic = proc { |z=-15, size=1| Square.new x: rand($width), y: rand($height), z: z, color: %w(#ffff00 #ffffff #6ba3ff).sample, size: size }
	t = proc { |format='%r'| Time.new.strftime(format) }

	timelabel = Text.new t.('%T:%N')[0..-8], font: FONT, size: $fontsize + 20
	timelabel.x, timelabel.y = $width/2 - timelabel.width/2, $height/2 - timelabel.height/2
	timeline = Line.new x1: timelabel.x + timelabel.width/2, x2: timelabel.x + timelabel.width/2,
			y1: timelabel.y + timelabel.height - 20, y2: timelabel.y + timelabel.height - 20, width: 3
	timelabelswitch = 1

	ampm = Text.new t.call('%r')[-2..-1], font: FONT
	ampm.x, ampm.y, ampm.opacity = timelabel.x + timelabel.width - 5, timelabel.y, 0

	timeformat = ('%T:%N') if $defaulttimeformat
	timeformat = '%I:%M:%S:%N' unless $defaulttimeformat
	ampm.opacity = 1 unless $defaulttimeformat

	daylabel = Text.new t.call('%A'), font: FONT, size: $fontsize
	daylabel.x, daylabel.y = $width/2 - daylabel.width/2, timelabel.y - daylabel.height

	datelabel = Text.new t.call('%d/%m/%y'), font: FONT, size: $fontsize
	datelabel.x, datelabel.y = $width/2 - datelabel.width/2, timelabel.y + timelabel.height

	dateformat = t.call($defaultdateformat)
	dateformatswitch = 1

	greetings = []
	generate_greetings = proc { |text = 'Greetings!', y = (datelabel.y + datelabel.height)|
		generated_text = Text.new(text, font: FONT2, size: 50, y: y)
		generated_text.x = $width / 2 - generated_text.width / 2
		greetings.push(generated_text)
		generated_text
	}

	generate_greetings.("Welcome to Space Clock", daylabel.y - 50)
	generate_greetings.("Welcome to Space Clock", datelabel.y + datelabel.height)

	greetflag = [-10.0, 10.0].sample

	customemove = Image.new  File.join(PATH, 'crystals', 'moveicon.png'), z: 1
	customemove.opacity, movealpha = 0, false

	customtext1 = Text.new $customtext1, font: $customfont, size: $customsize1, color: $customfontcolour
	customtext1.x, customtext1.y = $width/2 - customtext1.width/2, 0
	customtext1drag = false

	customtext2 = Text.new $customtext2, font: $customfont, size: $customsize2, color: $customfontcolour
	customtext2.x, customtext2.y = $width/2 - customtext2.width/2, $height - customtext2.height
	customtext2drag = false

	spacecrafts, fires, fireball, firepixels, comets, crystals = [], [], [], [], [], []
	spacecrafts_speed, spacecrafs_size = [], []
	particleswitch, randomparticles = true, []
	snowflakes1, snowflake_particles = [], []

	i, spaceshiphover = 0, nil

	Thread.new do
		$width./(35).times do |temp|
			tempsize = rand(30.0..40.0)
			Image.new(File.join(PATH, 'crystals', "crystal#{rand(1..4)}.png"), width: tempsize, height: tempsize, x: temp * tempsize,
				y: $height - tempsize - 8, z: -15)

			tempsize = rand(30.0..40.0)
			crystals[temp] = Image.new(File.join(PATH, 'crystals', 'crystal3.png'), width: tempsize, height: tempsize, x: temp * tempsize, y: $height - tempsize - 8,
				z: -15, color: %w(#ffff00 #00ffff #ffffff).sample)
		end

		$width./(150).times do
			tempsize = rand(14.0..16.0)
			Image.new(File.join(PATH, 'crystals', "specialstar#{rand(1..3)}.png"), x: rand($width), y: $height - tempsize * 1.3,
				z: -[15, 16].sample, width: tempsize, height: tempsize)
		end

		Image.new(File.join(PATH, 'crystals', 'galaxy2.png'), y: $height - 150, z: -25, x: rand($width - 50))
		Image.new(File.join(PATH, 'crystals', 'galaxy3.png'), y: 50, z: -25, x: rand($width - 50), width: $height/10, height: $height/10)
	end

	galaxy = Image.new(File.join(PATH, 'crystals', 'galaxy1.png'), y: 0, z: -25, width: timelabel.width * 2, height: timelabel.width)
	galaxy.x, galaxy.y = $width/2 - galaxy.width/2, $height/2 - galaxy.height/2

	fires = Array.new($spaceships) do |temp|
		speed = rand(3.0..10.0)
		img = Image.new(File.join(PATH, 'crystals', 'spacecraft' + rand(1..7).to_s + '.png'), x: rand($width), y: rand($height..$height + 2000), width: 25, height: 40, z: -15)
		spacecrafts.push(img)
		spacecrafts_speed.push(speed)

		spacecrafs_size.push(
			if speed <= 5.0 then [img.width/2, img.height/2]
			elsif speed <= 7.0 then [img.width/1.5, img.height/1.5]
			else [img.width, img.height]
			end
		)

		Image.new(File.join(PATH, 'crystals', 'fireball' + rand(1..6).to_s + '.png'), x: rand($width), y: rand($width), z: -15)
	end

	planets = Array.new($planets) do |temp|
			size = rand(10.0..30.0)
			Image.new(File.join(PATH, 'crystals', "#{%w(jupiter pinkie earth).sample}.png"), width: size, height: size, x: rand($width), y: rand($height/2..$height),
				z: -20, opacity: rand(0.5..1))
	end

	comets = Array.new($comets) do |temp|
		size = rand(2.0..10.0)
		Image.new(File.join(PATH, 'crystals', %w(comet1 comet2).sample + '.png'), x: rand($width..$width + 700), y: rand(-700..0), z: -15, width: size, height: size,
			color: %w(#ffff00 #ffffff #6ba3ff #ff6850).sample)
	end

	particles = Array.new($particle) { Image.new(File.join(PATH, 'crystals', '1pixel_square.png'), y: -10) }

	($width/99).times { |temp| Image.new(File.join(PATH, 'crystals', 'snow.png'), y: $height - 10, x: temp * 100, z: -14) }
	sparkles = Array.new($width / 35) { magic.call(-12) }

	($width/10).times { |temp| randomparticles[temp] = static.call(rand(4..8)) }
	Image.new(File.join(PATH, 'crystals', 'moon.png'), x: 0, y: $height - 80, width: 100, height: 100 , z: -20)

	snow_flake_speed = []
	snowflakes1 = Array.new($flakes) do |temp|
		size = rand(25.0..35.0)
		snow_flake_speed.push(rand(-1..1))
		Image.new(File.join(PATH, 'crystals', "#{%w(flake1 flake2).sample}.png"), x: rand($width), y: rand(-1000..0), z: -10, width: size, height: size, opacity: rand(0.3..0.7))
	end

	$hoverparticles = 1 if $hoverparticles <= 0
	hoverparticles, magicparticles = Array.new($hoverparticles) { static.(rand(8..15)) }, Array.new($magicparticles) { static.call(rand(8..15)) }
	snowflake_particles = Array.new($flakes * 2) { |temp| magic.(1) }

	speeds = []
	magics = Array.new(100) do |temp|
		speeds << rand(2.0..8.0)
		magic.call(-5, 2)
 	end

	$staticmagic.times { static.call(rand(4..8)) }

	fireball = Array.new($spaceships * rand(10..12)) do |temp|
		tempsize = rand(10..19)
		firepixels << magic.call(-15)
		Image.new(File.join(PATH, 'crystals', 'light.png'), x: rand($width), y: rand($height),
			z: -15, height: tempsize, width: tempsize, opacity: 0)
	end

	tempsize = rand(80..100)
	light = Image.new(File.join(PATH, 'crystals', 'light.png'), width: tempsize, height: tempsize, x: rand(100..$width - 100), y: 20, z: -20)
	mercury, xflag = Image.new(File.join(PATH, 'crystals', %w(pinkie earth).sample + '.png'), width: 1, height: 1, x: light.x - light.width/2,
							y: light.y + light.height/2 - 5, z: -21, color: '#000000'), 0

	touched_obj = nil

	on :mouse_move do |e|
		touched_obj = if datelabel.contains?(e.x, e.y) then datelabel
		elsif daylabel.contains?(e.x, e.y) then daylabel
		elsif timelabel.contains?(e.x, e.y) or ampm.contains?(e.x, e.y) then timelabel
		else nil
		end

		snowflakes1.each { |val| val.opacity = 0 if val.contains?(e.x, e.y) }

		if customtext1.contains?(e.x, e.y) and !customtext1.text.empty?
				customtext1.x, customtext1.y = e.x - customtext1.width/2, e.y - customtext1.height/2 if customtext1drag
				movealpha, customemove.x = true, customtext1.x + customtext1.width/2 - customemove.width/2
				customemove.y = customtext1.y + customtext1.height/2 - customemove.height/2

		elsif customtext2.contains?(e.x, e.y) and !customtext2.text.empty?
				customtext2.x, customtext2.y = e.x - customtext2.width/2, e.y - customtext2.height/2 if customtext2drag
				movealpha, customemove.x = true, customtext2.x + customtext2.width/2 - customemove.width/2
				customemove.y = customtext2.y + customtext2.height/2 - customemove.height/2

		else
			movealpha = false
		end

		el = hoverparticles.sample
		el.x, el.y, el.opacity = e.x, e.y, 1

		particles.each { |val| val.opacity = 0 if val.contains?(e.x, e.y) }
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
				timeformat, ampm.opacity = timelabelswitch % 2 == 0 ? ['%I:%M:%S:%N', 1] : ['%T:%N', 0]

			else
				mgp = magicparticles.sample
				mgp.x, mgp.y = e.x, e.y

				greetflag, time = e.x > $width / 2 ? 8 : -8, t.('%H').to_i

				generate_greetings.(
					if time >=  5 and time < 12 then "Good Morning!..."
					elsif time >=  12 and time < 16 then "Good Afternoon."
					elsif time >=  16 and time < 19 then "Good Evening!!..."
					else "Very Good Night" end,
					daylabel.y - 50)

				generate_greetings.(t.('%c'), datelabel.y + datelabel.height)
			end
		else
			bg.change_colour(4.times.map { "##{SecureRandom.hex(3)}" })
		end
	end

	on :mouse_up do |e| customtext1drag, customtext2drag = false, false end

	on :mouse_scroll do |e|
		bg.opacity += 0.2 if e.delta_y == -1 and bg.opacity <= 1

		if e.delta_y == 1
			bg.opacity -= 0.2 if bg.opacity >= 0
			particles.each { |val| val.opacity = 0 }
			snowflakes1.each { |val| val.opacity = 0 }
		end
	end

	on :key_down do |k|
		if k.key == 'space'
			greetflag = get(:mouse_x) > $width / 2 ? 8 : -8

			if bg.opacity > 0
				bg.opacity = 0
				generate_greetings.('Press Space Again to Restore Brightness', daylabel.y - 50)
				generate_greetings.('Press Space Again to Restore Brightness')

				particles.each { |val| val.opacity = 0 }
				snowflakes1.each { |val| val.opacity = 0 }

			elsif bg.opacity <= 0
				bg.opacity = 1
				generate_greetings.('Press Space Again to Reduce Brightness', daylabel.y - 50)
				generate_greetings.('Press Space Again to Reduce Brightness')
			end
		end

		Thread.new { puts Open3.capture2e('ruby', File.join(PATH, 'Subwindows', 'properties.rb'), "#{$defaultcolours}") } if %w(c s).include?(k.key)

		if k.key == 'up'
			bg.opacity += 0.2 if bg.opacity < 1
			particles.each { |val| val.opacity = 0 }
		end

		if k.key == 'down'
			bg.opacity -= 0.2 if bg.opacity > 0
			particles.each { |val| val.opacity = 0 }
			snowflakes1.each { |val| val.opacity = 0 }
		end

		hoverparticles.each { |el| el.x, el.y, el.opacity = rand($width), rand($height), 1 } if ['right', 'left'].include?(k.key)
		exit if ['escape', 'q', 'p'].include?(k.key)

		if ['right shift', 'left shift'].include?(k.key)
			puts  "Creating a new window for #{__FILE__}! Please wait!"
			Thread.new { puts Open3.capture2e('ruby', __FILE__) }
			puts "Happily opened another #{__FILE__}"
		end

		Thread.new { puts Open3.capture2e('ruby', File.join(PATH, 'Subwindows', 'about.rb')) } if ['a', 'i'].include?(k.key)

		if ['left alt', 'right alt', 'right ctrl', 'left ctrl', 'tab'].include?(k.key)
			spacecrafts.each { |val| val.x, val.y = rand($width), rand($height + 1000) }
			planets.each { |val| val.x, val.y = rand($width), rand($height/2..$height) }
			light.x, light.y = rand(100..$width - 100), 20
			mercury.x, mercury.y = light.x - light.width/2, light.y + light.height/2
			mercury.width, mercury.height = 1, 1
			movealpha = false
			customtext1.x, customtext1.y, customtext2.x, customtext2.y = $width/2 - customtext1.width/2, 0, $width/2 - customtext2.width/2, $height - customtext2.height
			bg.change_colour($defaultcolours)
		end
	end

	air_direction = [-1, 0, 1].sample

	update do
		magicparticles.each_with_index do |el, index|
			if !(el.x < -el.width || el.x > $width) && !(el.y < -el.height || el.y > $height)
				el.x += Math.sin(index)
				el.y += Math.cos(index)
				el.rotate += el.height / 10.0
			else
				el.x, el.y = rand($width), rand($height)
			end
		end

		hoverparticles.each_with_index do |el, index|
			el.x += Math.sin(index)
			el.y += Math.cos(index)
			el.rotate += el.width / 5.0
			el.opacity -= 0.01
		end

		i += 1
		air_direction = [-1, 0, 1].sample if i % ($fps * 5) == 0

		if movealpha
			customemove.opacity += 0.03 if customemove.opacity < 1
			customemove.rotate += 1
		else
			customemove.opacity -= 0.05 if customemove.opacity > 0
		end

		spaceshiphover.y > 0 ? (spaceshiphover.y -= spaceshiphover.height / 3.0) : (spaceshiphover = false) if spaceshiphover

		ampm.text = t.call[-3..-1]

		if bg.opacity < 1
			snowflake_particles[0..30].each { |val| val.x, val.y = rand($width), rand($height) }

			crystals.each do |val|
				samplespark = sparkles.sample
				samplespark.x, samplespark.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height)
			end

			if xflag != 1
				mercury.width -= 0.1
				mercury.height -= 0.1
			else
				mercury.width += 0.1
				mercury.height += 0.1
			end

			if mercury.x > light.x + light.width
				xflag, mercury.z = -1, -20
			elsif mercury.x < light.x
				xflag, mercury.z = 1, -21
			end

			mercury.x += xflag

			if (mercury.x >= light.x + light.width/3 and mercury.x <= light.x + light.width/2) and xflag == -1 then light.b = light.g = rand(0.6..1)
			else light.b = light.g = 1 end

			particleswitch = false

			for val in comets
				val.x -= rand(1..2) + Math.sin(i/[-2, -1, 1, 2].sample)
				val.y += rand(1..2)
				if val.y >= $height + val.height
					val.x, val.y = rand($width..$width + 700), rand(-700..0)
					val.color, val.width, val.height = %w(#ffff00 #ffffff #6ba3ff #ff6850).sample, rand(4..8), rand(4..8)
				end
			end

			index = 0
			while index < spacecrafts.size
				c = spacecrafts[index]
				c.y -= spacecrafts_speed[index]
				c.width, c.height = spacecrafs_size[index]

				fires[index].x, fires[index].y = c.x + c.width/2 + Math.sin(i) - 10, c.y + c.height + Math.cos(i)

				temp = rand(fireball.length - 1)
				fireball[temp].width = fireball[temp].height = rand(15.0..19.0)
				fireball[temp].opacity, fireball[temp].x = 1, rand(fires[index].x..fires[index].x + fires[index].width - fireball[temp].width)
				fireball[temp].y, fireball[temp].color = rand(fires[index].y..fires[index].y + fires[index].height), '#00ff00'

				firepixels[temp].opacity, firepixels[temp].x = 1, rand(fires[index].x..fires[index].x + fires[index].width)
				firepixels[temp].y = rand(fires[index].y..fires[index].y + fires[index].height)
				c.x, c.y = rand($width), rand($height..$height + 1000) if c.y < -c.height

				index += 1
			end

			fireball.each do |val|
				val.x += air_direction
				val.r += 0.15 if val.r <= 1
				val.b += 0.08 if val.b <= 1
				val.g -= 0.1 if val.g <= 1
				val.opacity -= 0.025
				val.width -= 0.25
				val.height -= 0.25
				val.color = '#ffffff' if val.opacity <= 0.5
			end

			firepixels.each do |val|
				val.x += air_direction * 1.5
				val.opacity -= 0.005
				val.change_colour
			end
		else
			particleswitch = true

			snowflakes1.each_with_index do |val, index|
				if val.y < $height - val.height/2 and (val.x > -val.height and val.x < $width) and val.opacity > 0
					val.x += air_direction
					val.y += snow_flake_speed[index] + air_direction.abs

					unless air_direction == 0 then val.rotate += air_direction * 3 else val.rotate += 1 end
					psample = snowflake_particles.sample
					psample.x, psample.y = rand(val.x..val.x + val.width), rand(val.y..val.y + val.height +  10)
					psample.change_colour('#FFFFFF')
				else
					val.opacity -= 0.005
					val.x, val.y, val.opacity = rand($width), rand(-1000..0), rand(0.3..0.7) if i % 420 == 0
					size = rand(25..35)
					val.width = val.height = size
				end
			end
		end

		if touched_obj
			timeline.x1 -= 10 if timeline.x1 > touched_obj.x
			timeline.x1 += 10 if timeline.x1 < touched_obj.x
			timeline.x2 += 10 if timeline.x2 < touched_obj.x + touched_obj.width
			timeline.x2 -= 10 if timeline.x2 > touched_obj.x + touched_obj.width
			timeline.y1 = timeline.y2 = touched_obj.y + touched_obj.height
			[datelabel, daylabel, timelabel].each\
				{ |el| el.equal?(touched_obj) ?  (el.r, el.b = el.r - 0.05, el.b - 0.05 if touched_obj.r > 0) : (el.r, el.b = el.r + 0.05, el.b + 0.05 if el.r < 1) }
		else
			timeline.x1 -=5 if timeline.x1 > $width / 2
			timeline.x1 +=5 if timeline.x1 < $width / 2
			timeline.x2 -=5 if timeline.x2 > $width / 2
			timeline.x2 +=5 if timeline.x2 < $width / 2
			[datelabel, daylabel, timelabel].each { |el| el.r, el.b = el.r + 0.05, el.b + 0.05 if el.r < 1 }
		end

		timelabel.text, daylabel.text, datelabel.text = t.(timeformat)[0..-8], t.('%A'), dateformat
		randomparticles.sample.opacity = [0, 1].sample

		magics.each_with_index do |val, index|
			val.x += Math.sin(i/speeds[index]) * 2
			val.y -= speeds[index]
			val.opacity = [0, 1].sample
			val.color, val.x, val.y = %w(#ffff00 #ffffff).sample, rand($width - val.width), $height if val.y < -val.height
		end

		if greetings.all? { |el| el.opacity <= 0 }
			greetings.each { |el| el.remove }
			greetings.clear
		else
			greetings.each_with_index do |el, index|
				el.x += greetflag if index.odd?
				el.x -= greetflag if index.even?
				el.opacity -= 0.015
			end
		end unless greetings.empty?

		for val in particles
			val.rotate += val.width/100.0

			unless val.y <= -val.height or val.opacity <= 0
				val.y -= 1
			else
				val.width = val.height = rand($width/15..$width/10)
				val.y, val.x, val.opacity = rand($height..$height + 1000), rand($width - val.width/2), rand(0.1..0.3)
			end
		end if particleswitch
	end
end

begin
	main
	show
end
