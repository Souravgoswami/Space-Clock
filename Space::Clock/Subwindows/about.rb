#!/usr/bin/env ruby
require 'ruby2d'
$width, $height = 1200, 840
def main
	set title: 'About Space::Clock', background: 'black', width: $width, height: $height, resizable: true, fps_cap: 30
	bg = Rectangle.new width: $width, height: $height - 28, z: -10, color: %w(purple black black black) ; bg.opacity = 0.4
	file = File.open('instruction.txt').readlines
	file = file[11..-1]
	l, s, stars = 0, [], []
	10.times do |temp|
		size = rand(60..90)
		s << c = Image.new('crystals/1pixel_square.png', x: rand(0..$width), y: rand($height .. $height + 1500), z: -5, width: size, height: size)
		c.opacity = rand(0.1..0.3)
	end

	50.times do |temp|
		tempsize = rand(8..15)
		stars << Image.new( ['crystals/hoverstars.png', 'crystals/hoverstars1.png', 'crystals/hoverstars2.png', 'crystals/hoverstars3.png',
					'crystals/hoverstars4.png', 'crystals/hoverstars5.png', 'crystals/hoverstars6.png', 'crystals/hoverstars7.png',
					'crystals/hoverstars8.png', 'crystals/hoverstars9.png'].sample, x: rand(0..$width), y: rand(0..$height), width: tempsize, height: tempsize)
	end

	150.times do Square.new(x: rand(0..$width), y: rand(0..$height), z: -5, size: rand(1..2)) end

	chash = {}
	($width/30).times do |temp|
		tempsize = rand(20..50)
		chash[temp] = Image.new( 'crystals/crystal3.png', x: rand(0..$width), y: $height - tempsize - 29, z: 1, width: tempsize, height: tempsize,color: '#232323')
	end
	moon, mooncolor, moonbool = Image.new( 'crystals/moon.png', width: 100, height: 100, y: $height - 100),	mooncolor = [1,1,1,1], false
	blackhole = Image.new( 'crystals/blackhole.png', x: rand(100..$width - 100), y: rand(100..$height - 100), z: -10,
		color: %w(orange blue fuchsia purple yellow green).sample)

	text = {}
	for line in file
		text[l] = Text.new line.chomp, font: 'mage/MateSC-Regular.ttf', x: 5, y: l * 21, color: 'white', size: 17
		l += 1
	end

	i, block = -1, {}
	($width/76).times do |temp|
		block[temp] = Image.new 'crystals/block.png', x: i * 89, y: $height - 30, width: 89
		i += 1
	end
	Line.new x1: 0, x2: $width, y1: $height - 25, y2: $height - 25, width: 8, color: 'white'
	bstars, cstars = {}, {}
	120.times do |temp|
		bstars[temp] = Square.new x: rand(0..$width), y: rand($height - 120..$height - 30), color:  %w(yellow white #6ba3ff).sample, z: -5, size: 1
		cstars[temp] = Square.new x: rand(0..$width), y: rand($height - 17..$height - 1), color:  %w(yellow white #6ba3ff).sample, z: -5, size: 1
	end

	on :key_down do |k| exit! 0 if %w(escape return p q).include?(k.key) end

	on :mouse_move do |e|
		for val in s do val.opacity = 0 if val.contains?(e.x, e.y) end
		for val in text.values
			if val.contains?(e.x, e.y) then val.color = 'yellow'  else val.color = 'white' end
			if val.text.include?('www') and val.contains?(e.x, e.y) then val.color = 'red' end
		end
		for val in chash.values
			if val.contains?(e.x, e.y)
				val.color = 'white'
			else
				val.color = '#232323'
			end
		end
		if moon.contains?(e.x, e.y) then moonbool = true else moonbool = false end
	end

	on :mouse_up do |e|
		text.values.each do |val|
			if val.text.include?('www') and val.contains?(e.x, e.y) then Thread.new { system('xdg-open', val.text.strip) } end
		end
	end

	on :mouse_down do |e|
		text.values.each do |val|
			val.color = 'purple' if val.contains?(e.x, e.y)
			if val.text.include?('www') and val.contains?(e.x, e.y) then val.color = 'blue' end
		end
	end

	update do
		blackhole.rotate += 0.1
		if moonbool
			moon.color = mooncolor
			mooncolor[1] -= 0.015 if mooncolor[1] > 0
		else
			moon.color = mooncolor
			mooncolor[1] += 0.015 if mooncolor[1] < 1
		end
		s.each do |val|
			val.rotate += val.width/250.0
			unless val.y < -val.height or val.opacity <= 0 then val.y -= 1
				else val.x, val.y, val.opacity = rand(0..$width), rand($height .. $height + 1500), rand(0.1..0.3) end
		end
		chash.values.each do |val|
			unless val.x < -val.width then val.x -= 1 else val.x = rand($width..$width + 500) end
		end
		bstars.values.each do |val|
			unless val.x < -val.width
				val.x -= [2,3,4,5].sample
				val.opacity = [0, 1].sample if Time.now.strftime("%N")[0].to_i % 2 == 0
			else
				val.x, val.y, val.color = rand($width..$width + 100), rand($height - 120..$height - 30), %w(yellow white #6ba3ff).sample
			end
		end

		cstars.values.each do |val|
			unless val.x > $width + val.width
				val.x += [2,3,5].sample
			else
				val.x, val.y, val.color = rand(-100..0), rand($height - 17..$height - 1), %w(yellow white #6ba3ff).sample
			end
		end

		if Time.now.strftime("%N")[0].to_i % 2 == 0
			stars.sample.opacity = [0, 1].sample
			block.values.sample.color = 'random'
		end
	end
	show
end
main
