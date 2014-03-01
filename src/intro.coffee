# Number of rows and columns in the grid
grid =
    width: 16
    height: 12

# Border width in pixels around the main note view
border =
    left: 50
    right: 0
    top: 20
    bottom: 0

piano_roll =
    width: 800
    height: 600

# Size of the entire rendering canvas
canvas =
    width: piano_roll.width + border.left + border.right
    height: piano_roll.height + border.top + border.bottom

# Size of a single note cell in the grid
size =
    width: piano_roll.width / grid.width
    height: piano_roll.height / grid.height

two = new Two(canvas)
ch = null
main = body = icon = null
buttons = fields = {}
