#!/usr/bin/env ruby
require 'ruby2d'
require 'open3'

$width, $height = 1200, 840

PATH = File.expand_path('..', File.dirname(__FILE__))
FONT = File.join(PATH, 'mage', 'arima.otf')
FONT2 = File.join(PATH, 'mage', 'MateSC-Regular.ttf')

def main
	set title: 'About Space::Clock', background: 'black', width: $width, height: $height, resizable: true, fps_cap: 30
	bg = Rectangle.new width: $width, height: $height - 28, z: -10, color: %w(purple black black black) ; bg.opacity = 0.4
	file = IO.readlines(File.join(PATH, 'instruction.txt'))[11..-1].join

	s = Array.new(10) do |temp|
		size = rand(60..90)
		Image.new(File.join(PATH, 'crystals', '1pixel_square.png'), x: rand(0..$width), y: rand($height .. $height + 1500), z: -5, width: size, height: size, opacity: rand(0.1..0.3))
	end

	stars = Array.new(50) do |temp|
		tempsize = rand(8..15)
		Image.new(File.join(PATH, 'crystals', 'hoverstars' + rand(1..10).to_s + '.png'), x: rand(0..$width), y: rand(0..$height), width: tempsize, height: tempsize)
	end

	150.times { Square.new(x: rand(0..$width), y: rand(0..$height), z: -5, size: rand(1..2)) }

	chash = Array.new($width/30) do |temp|
		tempsize = rand(20..50)
		Image.new(File.join(PATH, 'crystals', 'crystal3.png'), x: rand(0..$width), y: $height - tempsize - 29, z: 1, width: tempsize, height: tempsize,color: '#232323')
	end

	moon, mooncolor, moonbool = Image.new(File.join(PATH, 'crystals', 'moon.png'), width: 100, height: 100, y: $height - 100),	mooncolor = [1,1,1,1], false
	blackhole = Image.new(File.join(PATH, 'crystals', 'blackhole.png'), x: rand(100..$width - 100), y: rand(100..$height - 100), z: -10,
		color: %w(orange blue fuchsia purple yellow green).sample)

	text_touched = nil
	text = file.each_line.map.with_index { |line, index| Text.new line.chomp, font: FONT2, x: 5, y: index * 21, color: 'white', size: 17 }

	block = []
	block = Array.new($width/76) { |temp| Image.new File.join(PATH, 'crystals', 'block.png'), x: temp * 89, y: $height - 30, width: 89 }

	Line.new x1: 0, x2: $width, y1: $height - 25, y2: $height - 25, width: 8, color: 'white'
	cstars = Array.new(120) { Square.new(x: rand(0..$width), y: rand($height - 120..$height - 30), color:  %w(yellow white #6ba3ff).sample, z: -5, size: 1) }

	on :key_down do |k| exit 0 if %w(escape return p q).include?(k.key) end

	on :mouse_move do |e|
		s.each { |val| val.opacity = 0 if val.contains?(e.x, e.y) }

		text.each do |val|
			if val.contains?(e.x, e.y)
				text_touched = val
				break
			else
				text_touched = nil
			end
		end

		chash.each { |val| val.color = val.contains?(e.x, e.y) ? '#FFFFFF' : '#232323' }
		if moon.contains?(e.x, e.y) then moonbool = true else moonbool = false end
	end

	on :mouse_up do |e|
		text.each { |val| Thread.new { puts Open3.capture2e('xdg-open', val.text.strip) } if val.text.include?('www') and val.contains?(e.x, e.y) }
	end

	on :mouse_down do |e|
		text.each do |val|
			val.color = '#FFFF00' if val.contains?(e.x, e.y)
			if val.text.include?('www') and val.contains?(e.x, e.y) then val.color = '#FF00FF' end
		end
	end

	update do
		if text_touched
			text.each do |val|
				if val.equal?(text_touched)
					if val.text.include?('www')
						val.color, val.opacity = '#FFFF00', val.opacity - 0.1 if val.opacity > 0.6
					else
						val.color, val.opacity = '#00FFFF', val.opacity - 0.1 if val.opacity > 0.6
					end
				else
					val.opacity += 0.1 if val.opacity < 1
					val.color = '#FFFFFF'
				end
			end
		else
			text.each do |val|
				val.color, val.opacity = '#FFFFFF', val.opacity unless val.color == '#FFFFFF'
				val.opacity += 0.05 if val.opacity < 1
			end
		end

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

		chash.each { |val| val.x = val.x < -val.width ? rand($width..$width + 500) : val.x - 1 }

		cstars.each_with_index do |val, index|
			unless val.x > $width + val.width
				val.x += index / 10.0
			else
				val.x, val.y, val.color = 0, rand($height - 150..$height - 1), %w(#FFFF00 #FFFFFF #6BA3FF).sample
			end
		end

		if Time.now.strftime("%N")[0].to_i % 2 == 0
			stars.sample.opacity = [0, 1].sample
			block.sample.color = 'random'
		end
	end
end

main

show
