#!/usr/bin/env ruby
require 'ruby2d'

def main
	$width, $height = 480, 843
	set title: "Info", width: $width, height: $height, resizable: true
	bg = Rectangle.new color: ARGV[0].scan(/[a-z,A-Z#0-9]/).join('').split(','), width: $width, height: $height
	info = File.open('config.conf', 'a+').readlines

	resolution = info[0][info[0].index('=') + 1..-1].chomp
	w, h = resolution[0..resolution.index('x') - 1].to_i, resolution[resolution.index('x') + 1..-1].to_i

	borderstat = info[1][info[1].index('=') + 1..-1].chomp == 'true'
	fullscreenstat = info[2][info[2].index('=') + 1..-1].chomp == 'true'
	timestat = info[3][info[3].index('=') + 1..-1].chomp == '12'
	date = info[4][info[4].index('=') + 1..-1].chomp.split('/')
	colourstats =  info[5][info[5].index('=') + 1.. - 1].split(',')
	colourstat0, colourstat1, colourstat2, colourstat3 = colourstats[0].chomp, colourstats[1].chomp, colourstats[2].chomp, colourstats[3].chomp
	spaceshipnum = colourstats =  info[6][info[6].index('=') + 1.. - 1].chomp
	l_stars = info[7][info[7].index('=') + 1.. - 1].chomp
	l_planet = info[8][info[8].index('=') + 1.. - 1].chomp
	l_comet = info[9][info[9].index('=') + 1.. - 1].chomp
	l_square = info[10][info[10].index('=') + 1.. - 1].chomp
	magicparticlestat = info[11][info[11].index('=') + 1..-1].to_i
	flakes = info[12][info[12].index('=') + 1..-1].to_i
	mouseparticlesstat = info[13][info[13].index('=') + 1..-1].to_i
	fontsize = info[14][info[14].index('=') + 1..-1].to_i
	customtext1 = info[15][info[15].index('=') + 1..-1].chomp
	customsize1 = info[16][info[16].index('=') + 1..-1].to_i
	customtext2 = info[17][info[17].index('=') + 1..-1].chomp
	customsize2 = info[18][info[18].index('=') + 1..-1].to_i
	customfont = info[19][info[19].index('=') + 1..-1].chomp
	customfontcolour = info[20][info[20].index('=') + 1..-1].chomp

	resolution = Text.new font: 'mage/arima.otf', text: :Resolution, x: 5, y: 5
	widthbox = Rectangle.new x: resolution.x, y: resolution.x + resolution.height, width: $width/2 - 15, height: 40
	heightbox = Rectangle.new x: widthbox.x + widthbox.width + 20, y: resolution.x + resolution.height, width: $width/2 - 20, height: 40
	Text.new font: 'mage/arima.otf', text: :Width, x: widthbox.x + widthbox.width/2 - 15, y: widthbox.y + widthbox.height, size: 15
	Text.new font: 'mage/arima.otf', text: :x, x: widthbox.x + widthbox.width + 8, y: widthbox.y + widthbox.height, size: 15
	Text.new font: 'mage/arima.otf', text: :Height, x: heightbox.x + heightbox.width/2 - 15, y: heightbox.y + heightbox.height, size: 15
	widthbox_l = Text.new font: 'mage/arima.otf', text: w, size: 30, color: 'lime'
	widthbox_l.x, widthbox_l.y = widthbox.x + 5, widthbox.y - 3

	heightbox_l = Text.new font: 'mage/arima.otf', text: h, size: 30, color: 'lime'
	heightbox_l.x, heightbox_l.y = heightbox.x + 5, heightbox.y - 3

	border_l = Text.new font: 'mage/arima.otf', x: resolution.x, y:heightbox_l.y + heightbox_l.height + 40, text: 'Borderless   '
	borderbox = Square.new x: border_l.x + border_l.width + 5, y: border_l.y + 5, size: 20
	borderticked = Image.new path: 'crystals/ticked.png', x: borderbox.x, y: borderbox.y
	borderticked.opacity = 0 unless borderstat

	fullscreen_l = Text.new font: 'mage/arima.otf', x: heightbox_l.x, y: heightbox_l.y + heightbox_l.height + 40, text: 'Fullscreen   '
	fullscreenbox = Square.new x: fullscreen_l.x + fullscreen_l.width + 5, y: fullscreen_l.y + 5, size: 20
	fullscreenticked = Image.new path: 'crystals/ticked.png', x: fullscreenbox.x, y: fullscreenbox.y
	fullscreenticked.opacity = 0 unless fullscreenstat

	timeformat_l = Text.new font: 'mage/arima.otf', x: border_l.x, y: fullscreenbox.y + fullscreenbox.height + 40, text: 'Time Format : '

	timeformat1_l = Text.new font: 'mage/arima.otf', x: timeformat_l.x + timeformat_l.width + 10, y: timeformat_l.y, text: "12 Hour"
	timeformat1 = Square.new x: timeformat1_l.x + timeformat1_l.width + 5, y: timeformat1_l.y + 5, size: 20

	timeformatticked = Image.new path: 'crystals/ticked.png', x: timeformat1.x, y: timeformat1.y, z: 1

	timeformat2_l = Text.new font: 'mage/arima.otf', x: timeformat1.x + timeformat1.width + 40, y: timeformat_l.y, text: '24 Hour : '
	timeformat2 = Square.new x: timeformat2_l.x + timeformat2_l.width + 5, y: timeformat2_l.y + 5, size: 20

	dateformat_l = Text.new font: 'mage/arima.otf', x: resolution.x, y: timeformat_l.y + timeformat_l.height + 30, text: 'Date Format : '
	dateformat = Rectangle.new x: resolution.x, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30
	dateformat1 = Rectangle.new x: dateformat.x + dateformat.width + 20, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30
	dateformat2 = Rectangle.new x: dateformat1.x + dateformat1.width + 20, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30

	Text.new font: 'mage/arima.otf', x: dateformat.x + dateformat.width + 4, y: dateformat.y - 10, text: :/, size: 32
	Text.new font: 'mage/arima.otf', x: dateformat1.x + dateformat1.width + 4, y: dateformat1.y - 10, text: :/, size: 32

	Text.new font: 'mage/arima.otf', x: dateformat.x + 10, y: dateformat.y, color: 'blue', text: date[0]
	Text.new font: 'mage/arima.otf', x: dateformat1.x + 10, y: dateformat1.y, color: 'blue', text: date[1]
	Text.new font: 'mage/arima.otf', x: dateformat2.x + 10, y: dateformat2.y, color: 'blue', text: date[2]

	colour_l = Text.new font: 'mage/arima.otf', x: dateformat_l.x, y: dateformat2.y + dateformat2.height + 30, text: "Default Colours : "
	colourbox1 = Rectangle.new x: colour_l.x + 10, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat0
	colourbox2 = Rectangle.new x: colourbox1.x + colourbox1.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat1
	colourbox3 = Rectangle.new x: colourbox2.x + colourbox2.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat2
	colourbox4 = Rectangle.new x: colourbox3.x + colourbox3.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat3

	colour0 = Text.new font: 'mage/arima.otf', text: colourstat0, x: colourbox1.x + 10, y: colourbox1.y, color: 'white'
	colour1 = Text.new font: 'mage/arima.otf', text: colourstat1, x: colourbox2.x + 10, y: colourbox1.y, color: 'white'
	colour2 = Text.new font: 'mage/arima.otf', text: colourstat2, x: colourbox3.x + 10, y: colourbox1.y, color: 'white'
	colour3 = Text.new font: 'mage/arima.otf', text: colourstat3, x: colourbox4.x + 10, y: colourbox1.y, color: 'white'

	spaceships_l = Text.new font: 'mage/arima.otf', x: colour_l.x, y: colourbox4.y + colourbox4.height + 20, text: 'Spaceships     '
	spaceships = Rectangle.new x: spaceships_l.x + spaceships_l.width, y: spaceships_l.y, width: 60, height: 30
	spaceship = Text.new font: 'mage/arima.otf', x: spaceships.x + 5, y: spaceships.y, text: spaceshipnum, color: 'red'

	stars_l = Text.new font: 'mage/arima.otf', x: spaceships.x + 80, y: colourbox4.y + colourbox4.height + 20, text: 'Static Stars     '
	stars = Rectangle.new x: stars_l.x + stars_l.width, y: spaceships_l.y, width: 60, height: 30
	star = Text.new font: 'mage/arima.otf', x: stars.x + 5, y: stars.y, text: l_stars, color: 'red'

	planets_l = Text.new font: 'mage/arima.otf', x: spaceships_l.x, y: spaceships_l.y + spaceships_l.height + 20, text: 'Planets     '
	planets = Rectangle.new x: planets_l.x + planets_l.width + 33, y: planets_l.y, width: 60, height: 30
	planet = Text.new font: 'mage/arima.otf', x: planets.x + 5, y: planets.y, text: l_planet, color: 'red'

	comets_l = Text.new font: 'mage/arima.otf', x: planets.x + planets.width + 20, y: spaceships_l.y + spaceships_l.height + 20, text: 'Comets     '
	comets = Rectangle.new x: comets_l.x + comets_l.width + 38, y: comets_l.y, width: 60, height: 30
	comet = Text.new font: 'mage/arima.otf', x: comets.x + 5, y: comets.y, text: l_comet, color: 'red'

	squares_l = Text.new font: 'mage/arima.otf', x: planets_l.x, y: comets.y + comets.height + 25, text: 'Squares     '
	squares = Rectangle.new x: squares_l.x + squares_l.width + 26, y: squares_l.y, width: 60, height: 30
	square = Text.new font: 'mage/arima.otf', x: squares.x + 5, y: squares.y, text: l_square, color: 'red'

	magicparticles_l = Text.new font: 'mage/arima.otf', x: square.x + squares.width + 16, y: squares.y, text: 'Magics Stars  '
	magicparticles = Rectangle.new x: magicparticles_l.x + magicparticles_l.width, y: squares_l.y, width: 60, height: 30
	magicparticle = Text.new font: 'mage/arima.otf', x: magicparticles.x + 5, y: magicparticles.y, text: magicparticlestat, color: 'red'

	cursorparticles_l = Text.new font: 'mage/arima.otf', x: squares_l.x, y: magicparticles_l.y + magicparticles_l.height + 20, text: 'Mouse Stars '
	cursorparticles = Rectangle.new x: cursorparticles_l.x + cursorparticles_l.width + 5, y: cursorparticles_l.y, width: 60, height: 30
	cursorparticle = Text.new font: 'mage/arima.otf', x: cursorparticles.x + 5, y: cursorparticles.y, text: mouseparticlesstat, color: 'red'

	flakes_l = Text.new font: 'mage/arima.otf', x: cursorparticles.x + cursorparticles.width + 20, y: cursorparticle.y, text: 'Snow Flakes  '
	flakes_ = Rectangle.new x: flakes_l.x + flakes_l.width + 5, y: flakes_l.y, width: 60, height: 30
	flake = Text.new font: 'mage/arima.otf', x: flakes_.x + 5, y: flakes_.y, text: flakes, color: 'red'

	c1 = Text.new font: 'mage/arima.otf', x: 5, text: "Custom Text 1: ", y: cursorparticle.y + cursorparticle.height + 20
	Text.new font: 'mage/arima.otf', x: c1.x + c1.width, y: c1.y, text: customtext1

	c2 = Text.new font: 'mage/arima.otf', x: 5, text: "Custom Text 2: ", y: c1.y + c1.height + 20
	Text.new font: 'mage/arima.otf', x: c2.x + c2.width, y: c2.y, text: customtext2

	c1 = Text.new font: 'mage/arima.otf', x: 5, text: "Custom Font Size ", y: c2.y + c2.height + 20

	c1sq = Rectangle.new x: c1.x + c1.width + 5, y: c1.y, width: 60, height: 30
	c1size = Text.new font: 'mage/arima.otf', x: c1sq.x + 5, text: customsize1, y: c1.y, color: 'fuchsia'

	c2sq = Rectangle.new x: c1sq.x + c1sq.width + 5, y: c1sq.y, width: 60, height: 30
	c2size = Text.new font: 'mage/arima.otf', x: c2sq.x + 5, text: customsize2, y: c1sq.y, color: 'fuchsia'

	c3sq = Rectangle.new x: c2sq.x + c2sq.width + 5, y: c2sq.y, width: 60, height: 30
	c3size = Text.new font: 'mage/arima.otf', x: c3sq.x + 5, text: fontsize, y: c2sq.y, color: 'fuchsia'

	c1 = Text.new font: 'mage/arima.otf', x: 5, text: "Custom Font Colour ", y: c2sq.y + c2sq.height + 20
	fc = Rectangle.new x: c1.x + c1.width + 5 + 15, y: c1.y, width: 100, height: 30, color: customfontcolour
	c1 = Text.new font: 'mage/arima.otf', x: fc.x + 5, text: customfontcolour, y: fc.y, color: 'white'

	Text.new font: 'mage/arima.otf', x: c1sq.x, y: c1sq.y - 15, size: 9, text: ' Custom Font-1   Custom Font-2     Global Fonts'



	close_ = Rectangle.new width: 60, height: 30, color: '#ff6db1'
	close_.x, close_.y = $width - close_.width - 5, $height - close_.height - 5
	close_l = Text.new font: 'mage/arima.otf', x: close_.x + 7, y: close_.y, text: :Close

	about = Rectangle.new width: 60, height: 30, color: '#ff6db1'
	about.x, about.y = close_.x, close_.y - about.height - 5
	about_l = Text.new font: 'mage/arima.otf', x: about.x + 3, y: about.y, text: :About



	quit_keys = %w(escape p q space return)
	on :key_down do |k| exit if quit_keys.include?(k.key ) end
	on :mouse_move do |e|
		if close_.contains?(e.x, e.y) then close_.color = '#ba6dff' else close_.color = '#ff6db1' end
		if about_l.contains?(e.x, e.y) then about.color = '#ba6dff' else about.color = '#ff6db1' end
	end
	on :mouse_down do |e|
		exit if close_.contains?(e.x, e.y)
		Thread.new { system('ruby', 'Subwindows/about.rb') }
	end

	show
end
main
