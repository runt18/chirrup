NOTES_PER_OCTAVE = 12
OCTAVES = 2
BEATS_PER_BAR = 4
BARS = 4
SUBDIVISIONS = 4
BEATS = BARS * BEATS_PER_BAR
SHARPS = [1, 3, 6, 8, 10]

# Number of rows and columns in the grid
grid =
    width: BEATS
    height: OCTAVES * NOTES_PER_OCTAVE

# Border width in pixels around the main note view
border =
    left: 50
    right: 0
    top: 50
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
audiolet = null
audio = null
main = body = icon = null
buttons = fields = {}

window.alert = (m) ->
    style =
        position: 'fixed'
        top: 10
        padding: 10
        zIndex: 2000
        borderRadius: 5
        fontWeight: 'bold'

    el = $('<div>')
    el.text(m).css(style).addClass('alert-danger').hide().appendTo('body')
    el.css('left', ($('body').width() - el.width()) / 2)
    el.fadeIn().delay(5000).fadeOut -> $(this).remove()
