#!/usr/bin/env ruby
%w(ruby2d open3).each { |g| require(g) }

PATH = File.expand_path('..', File.dirname(__FILE__))
FONT = File.join(PATH, 'mage', 'arima.otf')
ARGV.push('#FF50A6 #3CE3B4 #FFDC00 #FFDC60') if ARGV.empty?

def main
	$width, $height = 480, 843
	set title: "Info", width: $width, height: $height, resizable: true
	Rectangle.new color: ARGV[0].scan(/[a-zA-Z#0-9\s]/).join.split, width: $width, height: $height
	info = IO.readlines(File.join(PATH, 'config.conf'))

	query = ->(option) { info.select { |line| line.strip.start_with?(option.to_s) }[-1].to_s.split('=')[-1].to_s.strip }
	w, h = query.(:Width).to_i, query.(:Height).to_i
	borderstat = query.(:Borderless) == 'true'
	fullscreenstat = query.(:Fullscreen) == 'true'
	date = query.(:Date_Format).split('/')
	colourstat0, colourstat1, colourstat2, colourstat3 = query.(:Default_Colours).split(',').map(&:strip)
	spaceshipnum = colourstats =  query.(:Spaceships)
	l_stars = query.(:Static_Stars)
	l_planet = query.(:Planets)
	l_comet = query.(:Comets)
	l_square = query.(:Floating_Squares)
	magicparticlestat = query.(:Magic_Particles)
	flakes = query.(:Snow_Flakes)
	mouseparticlesstat = query.(:Mouse_Move_Particles)
	fontsize = query.(:Font_Size)
	customtext1 = query.(:Custom_Text_1)
	customsize1 = query.(:Custom_Text1_Size)
	customtext2 = query.(:Custom_Text_2)
	customsize2 = query.(:Custom_Text2_Size)
	customfontcolour = query.(:Custom_Font_Colour)
	fps = query.(:FPS)

	resolution = Text.new "Resolution (@#{fps} Frames/sec)", font: FONT, x: 5, y: 5
	widthbox = Rectangle.new x: resolution.x, y: resolution.x + resolution.height, width: $width/2 - 15, height: 40
	heightbox = Rectangle.new x: widthbox.x + widthbox.width + 20, y: resolution.x + resolution.height, width: $width/2 - 20, height: 40
	Text.new :Width, font: FONT, x: widthbox.x + widthbox.width/2 - 15, y: widthbox.y + widthbox.height, size: 15
	Text.new :x, font: FONT, x: widthbox.x + widthbox.width + 8, y: widthbox.y + widthbox.height, size: 15
	Text.new :Height, font: FONT, x: heightbox.x + heightbox.width/2 - 15, y: heightbox.y + heightbox.height, size: 15
	widthbox_l = Text.new w, font: FONT, size: 30, color: 'lime'
	widthbox_l.x, widthbox_l.y = widthbox.x + 5, widthbox.y - 3

	heightbox_l = Text.new h, font: FONT, size: 30, color: 'lime'
	heightbox_l.x, heightbox_l.y = heightbox.x + 5, heightbox.y - 3

	border_l = Text.new 'Borderless', font: FONT, x: resolution.x, y:heightbox_l.y + heightbox_l.height + 40
	borderbox = Square.new x: border_l.x + border_l.width + 5, y: border_l.y + 5, size: 20
	borderticked = Image.new File.join(PATH, 'crystals', 'ticked.png'), x: borderbox.x, y: borderbox.y
	borderticked.opacity = 0 unless borderstat

	fullscreen_l = Text.new 'Fullscreen', font: FONT, x: heightbox_l.x, y: heightbox_l.y + heightbox_l.height + 40
	fullscreenbox = Square.new x: fullscreen_l.x + fullscreen_l.width + 5, y: fullscreen_l.y + 5, size: 20
	fullscreenticked = Image.new File.join(PATH, 'crystals', 'ticked.png'), x: fullscreenbox.x, y: fullscreenbox.y
	fullscreenticked.opacity = 0 unless fullscreenstat

	timeformat_l = Text.new 'Time Format : ', font: FONT, x: border_l.x, y: fullscreenbox.y + fullscreenbox.height + 40

	timeformat1_l = Text.new "12 Hour", font: FONT, x: timeformat_l.x + timeformat_l.width + 10, y: timeformat_l.y
	timeformat1 = Square.new x: timeformat1_l.x + timeformat1_l.width + 5, y: timeformat1_l.y + 5, size: 20

	Image.new File.join(PATH, 'crystals', 'ticked.png'), x: timeformat1.x, y: timeformat1.y, z: 1

	timeformat2_l = Text.new '24 Hour : ', font: FONT, x: timeformat1.x + timeformat1.width + 40, y: timeformat_l.y
	Square.new x: timeformat2_l.x + timeformat2_l.width + 5, y: timeformat2_l.y + 5, size: 20

	dateformat_l = Text.new 'Date Format : ', font: FONT, x: resolution.x, y: timeformat_l.y + timeformat_l.height + 30
	dateformat = Rectangle.new x: resolution.x, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30
	dateformat1 = Rectangle.new x: dateformat.x + dateformat.width + 20, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30
	dateformat2 = Rectangle.new x: dateformat1.x + dateformat1.width + 20, y: dateformat_l.y + dateformat_l.height, width: 60, height: 30

	Text.new :/, font: FONT, x: dateformat.x + dateformat.width + 4, y: dateformat.y - 10, size: 32
	Text.new :/, font: FONT, x: dateformat1.x + dateformat1.width + 4, y: dateformat1.y - 10, size: 32

	Text.new date[0], font: FONT, x: dateformat.x + 10, y: dateformat.y, color: 'blue'
	Text.new date[1], font: FONT, x: dateformat1.x + 10, y: dateformat1.y, color: 'blue'
	Text.new date[2], font: FONT, x: dateformat2.x + 10, y: dateformat2.y, color: 'blue'

	colour_l = Text.new "Default Colours : ", font: FONT, x: dateformat_l.x, y: dateformat2.y + dateformat2.height + 30
	colourbox1 = Rectangle.new x: colour_l.x + 10, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat0
	colourbox2 = Rectangle.new x: colourbox1.x + colourbox1.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat1
	colourbox3 = Rectangle.new x: colourbox2.x + colourbox2.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat2
	colourbox4 = Rectangle.new x: colourbox3.x + colourbox3.width + 15, y: colour_l.y + colour_l.height, width: 100, height: 30, color: colourstat3

	Text.new colourstat0, font: FONT, x: colourbox1.x + 10, y: colourbox1.y, color: 'white'
	Text.new colourstat1, font: FONT, x: colourbox2.x + 10, y: colourbox1.y, color: 'white'
	Text.new colourstat2, font: FONT, x: colourbox3.x + 10, y: colourbox1.y, color: 'white'
	Text.new colourstat3, font: FONT, x: colourbox4.x + 10, y: colourbox1.y, color: 'white'

	spaceships_l = Text.new 'Spaceships     ', font: FONT, x: colour_l.x, y: colourbox4.y + colourbox4.height + 20
	spaceships = Rectangle.new x: spaceships_l.x + spaceships_l.width, y: spaceships_l.y, width: 60, height: 30
	Text.new spaceshipnum, font: FONT, x: spaceships.x + 5, y: spaceships.y, color: 'red'

	stars_l = Text.new 'Static Stars     ', font: FONT, x: spaceships.x + 80, y: colourbox4.y + colourbox4.height + 20
	stars = Rectangle.new x: stars_l.x + stars_l.width, y: spaceships_l.y, width: 60, height: 30
	Text.new l_stars, font: FONT, x: stars.x + 5, y: stars.y, color: 'red'

	planets_l = Text.new 'Planets     ', font: FONT, x: spaceships_l.x, y: spaceships_l.y + spaceships_l.height + 20
	planets = Rectangle.new x: planets_l.x + planets_l.width + 33, y: planets_l.y, width: 60, height: 30
	Text.new l_planet, font: FONT, x: planets.x + 5, y: planets.y, color: 'red'

	comets_l = Text.new 'Comets    ', font: FONT, x: planets.x + planets.width + 20, y: spaceships_l.y + spaceships_l.height + 20
	comets = Rectangle.new x: comets_l.x + comets_l.width + 38, y: comets_l.y, width: 60, height: 30
	Text.new l_comet, font: FONT, x: comets.x + 5, y: comets.y, color: 'red'

	squares_l = Text.new 'Squares     ', font: FONT, x: planets_l.x, y: comets.y + comets.height + 25
	squares = Rectangle.new x: squares_l.x + squares_l.width + 26, y: squares_l.y, width: 60, height: 30
	square = Text.new l_square, font: FONT, x: squares.x + 5, y: squares.y, color: 'red'

	magicparticles_l = Text.new 'Magics Stars  ', font: FONT, x: square.x + squares.width + 16, y: squares.y
	magicparticles = Rectangle.new x: magicparticles_l.x + magicparticles_l.width, y: squares_l.y, width: 60, height: 30
	Text.new magicparticlestat, font: FONT, x: magicparticles.x + 5, y: magicparticles.y, color: 'red'

	cursorparticles_l = Text.new 'Mouse Stars ', font: FONT, x: squares_l.x, y: magicparticles_l.y + magicparticles_l.height + 20
	cursorparticles = Rectangle.new x: cursorparticles_l.x + cursorparticles_l.width + 5, y: cursorparticles_l.y, width: 60, height: 30
	cursorparticle = Text.new mouseparticlesstat, font: FONT, x: cursorparticles.x + 5, y: cursorparticles.y, color: 'red'

	flakes_l = Text.new 'Snow Flakes  ', font: FONT, x: cursorparticles.x + cursorparticles.width + 20, y: cursorparticle.y
	flakes_ = Rectangle.new x: flakes_l.x + flakes_l.width + 5, y: flakes_l.y, width: 60, height: 30
	Text.new flakes, font: FONT, x: flakes_.x + 5, y: flakes_.y, color: 'red'

	c1 = Text.new "Custom Text 1: ", font: FONT, x: 5, y: cursorparticle.y + cursorparticle.height + 20
	Text.new customtext1, font: FONT, x: c1.x + c1.width, y: c1.y

	c2 = Text.new "Custom Text 2: ", font: FONT, x: 5, y: c1.y + c1.height + 20
	Text.new customtext2, font: FONT, x: c2.x + c2.width, y: c2.y

	c1 = Text.new "Custom Font Size ", font: FONT, x: 5, y: c2.y + c2.height + 20

	c1sq = Rectangle.new x: c1.x + c1.width + 5, y: c1.y, width: 60, height: 30
	Text.new customsize1, font: FONT, x: c1sq.x + 5, y: c1.y, color: 'fuchsia'

	c2sq = Rectangle.new x: c1sq.x + c1sq.width + 5, y: c1sq.y, width: 60, height: 30
	Text.new customsize2, font: FONT, x: c2sq.x + 5, y: c1sq.y, color: 'fuchsia'

	c3sq = Rectangle.new x: c2sq.x + c2sq.width + 5, y: c2sq.y, width: 60, height: 30
	Text.new fontsize, font: FONT, x: c3sq.x + 5, y: c2sq.y, color: 'fuchsia'

	c1 = Text.new "Custom Font Colour ", font: FONT, x: 5, y: c2sq.y + c2sq.height + 20
	fc = Rectangle.new x: c1.x + c1.width + 5 + 15, y: c1.y, width: 100, height: 30, color: customfontcolour
	c1 = Text.new customfontcolour, font: FONT, x: fc.x + 5, y: fc.y, color: 'white'

	Text.new ' Custom Font-1   Custom Font-2     Global Fonts', font: FONT, x: c1sq.x, y: c1sq.y - 15, size: 9

	close_touched = false
	close_ = Rectangle.new width: 60, height: 30, color: '#ff6db1'
	close_.x, close_.y = $width - close_.width - 5, $height - close_.height - 5
	Text.new 'Close', font: FONT, x: close_.x + 7, y: close_.y

	about_touched = false
	about = Rectangle.new width: 60, height: 30, color: '#ff6db1'
	about.x, about.y = close_.x, close_.y - about.height - 5
	about_l = Text.new 'About', font: FONT, x: about.x + 3, y: about.y

	quit_keys = %w(escape p q space return)

	on(:key_down) { |k| close if quit_keys.include?(k.key ) }

	on(:mouse_move) { |e| close_touched, about_touched = close_.contains?(e.x, e.y), about_l.contains?(e.x, e.y) }

	on :mouse_down do |e|
		exit if close_.contains?(e.x, e.y)
		Open3.pipeline_start("#{File.join(RbConfig::CONFIG['bindir'], 'ruby')} #{File.join(PATH, 'Subwindows', 'about.rb')}") if about.contains?(e.x, e.y)
	end

	update do
		close_touched ? (close_.opacity -= 0.05 if close_.opacity > 0.5) : (close_.opacity += 0.05 if close_.opacity < 1)
		about_touched ? (about.opacity -= 0.05 if about.opacity > 0.5) : (about.opacity += 0.05 if about.opacity < 1)
	end

end

main
show
