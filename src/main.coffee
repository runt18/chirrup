class Note
    constructor: (@pitch=0, @start=0, @duration=1, @velocity=100) ->
        @rect = new Rect((@start + 0.5) * size.width, (@pitch + 0.5) * size.height)
        @shape = two.makeRectangle(@rect.x, @rect.y, @rect.width, @rect.height)
        @shape.fill = 'red'
        @shape.noStroke()

    render: ->

    remove: ->
        two.remove(@shape)
        notes.splice(notes.indexOf(this), 1)

class Vector
    constructor: (@x, @y) ->

class Rect
    constructor: (@x, @y, @width=size.width, @height=size.height) ->

    intersects: (v) ->
        debugger
        (@x < v.x < @x + @width) and (@y < v.y < @y + @height)

notes = []

main = $('#main')
body = $('body')

grid =
    width: 16
    height: 24

border =
    left: 50
    right: 0
    top: 0
    bottom: 0

params =
  width: 800 + border.left + border.right
  height: 600 + border.top + border.bottom

size =
    width: params.width / grid.width
    height: params.height / grid.height

two = new Two(params).appendTo(main[0])
two.scene.translation.set(border.left, border.top)

for y in [0..grid.height]
    line = two.makeLine(0, y * size.height, params.width, y * size.height)

sharps = [1, 3, 6, 8, 10]

note = 0
for y in [grid.height..0] by -1
    rect = two.makeRectangle(-size.width / 2, y * size.height - size.height / 2, size.width, size.height)
    rect.fill = if note % 12 in sharps then 'black' else 'white'
    note++

for x in [0..params.width] by size.width
    line = two.makeLine(x, 0, x, params.height)

playhead = two.makeLine(100, 0, 100, params.height)
playhead.stroke = 'red'
playing = false
play_speed = 2

two.bind('update', (frameCount) ->
    if playhead.translation.x is params.width
        playhead.translation.x = 0
    playhead.translation.x += play_speed if playing
).play()

main.on 'mousedown', (e) ->
    o = main.offset()

    screen = new Vector(
        e.pageX - o.left - border.left,
        e.pageY - o.top - border.top
    )

    for note in notes
        if note.rect.intersects(screen)
            note.remove()
            return

    start = Math.floor(screen.x / size.width)
    pitch = Math.floor(screen.y / size.height)

    if start >= 0
        note = new Note(pitch, start)
        notes.push(note)

    console.log notes

togglePlay = ->
    playing = !playing
    icon.toggleClass('glyphicon-play')
    icon.toggleClass('glyphicon-pause')

body.on 'keydown', (e) ->
    togglePlay() if e.keyCode is 32

buttons =
    play: $("#play")
    reset: $("#reset")

icon = buttons.play.find('i')

buttons.play.on 'click', (e) -> togglePlay()

buttons.reset.on 'click', (e) ->
    playhead.translation.x = 0

two.update()
