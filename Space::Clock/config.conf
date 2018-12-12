#!/usr/bin/env ruby

BEGIN { file = File.open('config.conf', 'a+') }

file.truncate(0)
file.write <<EOF
# This is the configuration file for the Space::Clock
# Configure below texts to fit your own needs!

# Width for the Space::Clock window
Width = 1200

# Height for the Space::Clock window
Height = 620

# Would you like to have a borderless window? (available options: true/false. Default false)
Borderless = false

# Full screen window? (available options: true/false. Default false)
Fullscreen=false

# Updating time for the Space::Clock window (default: 0, won't show anything)
FPS = 50

# The default time format (available options: 12 Hr. and 24 Hr.)
Time_Format = 12

# Date format (%d => date, %m => month, %y => year)
Date_Format = %d/%m/%y

# Default colours for the background
Default_Colours = #0050a6,purple,aqua,#ff50a6

# The total number of spaceships (default: 0)
Spaceships = 10

# The total number of background still stars (default: 0)
Static_Stars = 50

# The total number of planets (default 0)
Planets = 3

# Flying comets (default: 0)
Comets = 4

# Floating squares in the default screen (default 0)
Floating_Squares = 12

# The floating and moving partitcles (default 0)
Magic_Particles = 12

# The number of snow flakes (default: 0)
Snow_Flakes = 25

# The number of objects drawn while moving the mouse on the Space::Clock window (default 1)
Mouse_Move_Particles = 40

# Font size for the Space::Clock
Font_Size = 60

# Add your own custom message here (You can drag it and place it anywhere on the Space::Clock window)
# Default: empty text
Custom_Text_1 =

# Size for the custom text (if you have one) (default: 0)
Custom_Text1_Size = 80

# Add your second custom message here (You can drag this as well) (default: empty)
Custom_Text_2 =

# Size for the  custom text 2 (default: 0)
Custom_Text2_Size =80

# The custom font path of your choice (default: ./mage/arima.otf)
Custom_Font_Path = mage/arima.otf

# Colour for the custom fonts
Custom_Font_Colour = #3ce3b4

# If you corrupted the file, don't worry, Space::Clock will automatically regenerate this for you
EOF

END { file.close }
