#!/usr/bin/env ruby

file = File.open('config.conf', 'a+')
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
