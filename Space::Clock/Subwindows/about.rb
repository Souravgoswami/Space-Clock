#!/usr/bin/env ruby
%w(ruby2d open3).each { |g| require(g) }

PATH = File.expand_path('..', File.dirname(__FILE__))
FONT = File.join(PATH, 'mage', 'arima.otf')
FONT2 = File.join(PATH, 'mage', 'MateSC-Regular.ttf')
$width, $height = 1200, 640

def main
	set title: 'About Space::Clock', background: 'black', width: $width, height: $height, resizable: true, fps_cap: 30, icon: File.join(PATH, %w(crystals icon.png))
	Rectangle.new width: $width, height: $height - 28, z: -10, color: %w(purple black black black), opacity: 0.4
	file = IO.readlines(File.join(PATH, 'instruction.txt')).tap { |f| f.replace(f[f.index { |l| l.strip == '-' * 3 }.next..-1]) }.join

	150.times { Square.new(x: rand(0..$width), y: rand(0..$height), z: -5, size: rand(1..2)) }
	stars = Array.new(50) { Image.new(File.join(PATH, 'crystals', 'hoverstars' + rand(1..10).to_s + '.png'), x: rand($width), y: rand($height), width: (t = rand(8..15)), height: t) }
	chash = Array.new($width/30) { Image.new(File.join(PATH, 'crystals', 'crystal3.png'), x: rand($width), y: $height - (t = rand(20..50)) - 29, z: 1, width: t, height: t,color: '#232323') }
	block = Array.new($width/76) { |temp| Image.new File.join(PATH, 'crystals', 'block.png'), x: temp * 89, y: $height - 30, width: 89 }

	moon, mooncolor, moonbool = Image.new(File.join(PATH, 'crystals', 'moon.png'), width: 100, height: 100, y: $height - 100),	mooncolor = [1,1,1,1], false
	blackhole = Image.new(File.join(PATH, 'crystals', 'blackhole.png'), x: rand(100..$width - 100), y: rand(100..$height - 100), z: -10,
		color: %w(orange blue fuchsia purple yellow green).sample)

	text, text_touched = file.each_line.map.with_index { |line, index| Text.new line.chomp, font: FONT2, x: 5, y: index * 21, color: '#FFFFFF', size: 17 }, false

	Line.new x1: 0, x2: $width, y1: $height - 25, y2: $height - 25, width: 8, color: '#FFFFFF'
	cstars = Array.new(120) { Square.new(x: rand(0..$width), y: rand($height - 120..$height - 30), color:  %w(#FFFF00 #FFFFFF #6ba3ff).sample, z: -5, size: 1) }

	on(:key_down) { |k| exit 0 if %w(escape return p q).include?(k.key) }

	on :mouse_move do |e|
		text.each { |val| val.contains?(e.x, e.y) ? (text_touched = val) && (break) : text_touched = nil }
		chash.each { |val| val.color = val.contains?(e.x, e.y) ? '#FFFFFF' : '#232323' }
		moonbool = moon.contains?(e.x, e.y)
	end

	on(:mouse_up) { |e| text.each { |val| Thread.new { puts Open3.capture2e('xdg-open', val.text.strip) } if val.text.include?('www') and val.contains?(e.x, e.y) } }
	on(:mouse_down) { |e| text.each { |val| val.color = '#FFFF00' if val.contains?(e.x, e.y) } }

	update do
		if text_touched
			text.each do |val|
				if val.equal?(text_touched)
					val.color, val.opacity = '#00FFFF', val.opacity - 0.1 if val.opacity > 0.6
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

		chash.each { |val| val.x = val.x < -val.width ? rand($width..$width + 500) : val.x - 1 }
		cstars.each_with_index { |v, i| v.x > $width + v.width ? (v.x, v.y, v.color = 0, rand($height - 150..$height - 1), %w(#FFFF00 #FFFFFF #6BA3FF).sample) : (v.x += i / 10.0) }

		moonbool ? (moon.g -= 0.015 if moon.g > 0) : (moon.g += 0.015 if moon.g < 1)
		stars.sample.opacity, block.sample.color = [0, 1].sample, [rand, rand, rand, 1] if Time.now.strftime("%N")[0].to_i % 2 == 0
		blackhole.rotate += 0.1
	end
end

main
show
