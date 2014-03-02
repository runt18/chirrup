makeTriangle = (x, y, w, h) ->
    hw = w / 2
    two.makePolygon(x - hw, -h, x + hw, -h, x, y)

class Playhead
    constructor: (@parent, tempo) ->
        @playing = false
        @colour = '#4CAE4C'
        @time = 0
        line = two.makeLine(@time, 0, @time, piano_roll.height)
        tri = makeTriangle(@time, 0, 10, 10)
        @shape = two.makeGroup(line, tri)
        @shape.stroke = @colour
        @shape.fill = @colour
        @shape.linewidth = 3
        @set_speed(tempo)

    set_speed: (tempo) ->
        # App runs at 60 FPS. Convert BPM to BPF by dividing by 60 * 60.
        @speed = tempo / 3600

    set_time: (@time) ->
        @update_shape()

    update_shape: ->
        @shape.translation.x = @time * size.width

    toggle: ->
        @playing = !@playing
        icon = buttons.play.find('i')
        icon.toggleClass('glyphicon-play')
        icon.toggleClass('glyphicon-pause')

    progress: ->
        return unless @playing

        if @time >= grid.width
            @time = 0

        @update_shape()

        @time += @speed

    reset: ->
        @time = 0
