# Make an instance of two and place it on the page.
elem = $("#main")[0]
params =
  width: 800
  height: 600

grid =
    width: 16
    height: 24

two = new Two(params).appendTo(elem)

size =
    width: params.width / grid.width
    height: params.height / grid.height

# two has convenience methods to create shapes.
# circle = two.makeCircle(72, 100, 50)
# rect = two.makeRectangle(213, 100, 100, 100)

for x in [0..params.height] by size.height
    line = two.makeLine(0, x, params.width, x)

for y in [0..params.width] by size.width
    line = two.makeLine(y, 0, y, params.height)

playhead = two.makeLine(100, 0, 100, params.height)
playhead.stroke = 'red'
playing = false
play_speed = 2

two.bind('update', (frameCount) ->
    if playhead.translation.x is params.width
        playhead.translation.x = 0
    playhead.translation.x += play_speed if playing
).play()

# The object returned has many stylable properties:
# circle.fill = "#FF8000"
# circle.stroke = "orangered" # Accepts all valid css color
# circle.linewidth = 5
# rect.fill = "rgb(0, 200, 255)"
# rect.opacity = 0.75
# rect.noStroke()

$('#main').on 'mousedown', (e) ->
    console.log(e)
    x = Math.floor(e.pageX / size.width) * size.width
    y = Math.floor(e.pageY / size.height) * size.height
    rect = two.makeRectangle(x + size.width / 2, y + size.height / 2, size.width, size.height)
    rect.fill = 'red'
    rect.noStroke()

buttons =
    play: $("#play")
    reset: $("#reset")

icon = buttons.play.find('i')

buttons.play.on 'click', (e) ->
    playing = !playing
    icon.toggleClass('glyphicon-play')
    icon.toggleClass('glyphicon-pause')

buttons.reset.on 'click', (e) ->
    playhead.translation.x = 0

# Don't forget to tell two to render everything
# to the screen
two.update()
