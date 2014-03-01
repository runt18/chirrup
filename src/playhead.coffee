 class Playhead
    constructor: (two, @icon) ->
        @playing = false
        @time = 0
        @speed = 0.02
        @shape = two.makeLine(@time, 0, @time, params.height)
        @shape.stroke = 'red'

    toggle: ->
        @playing = !@playing
        @icon.toggleClass('glyphicon-play')
        @icon.toggleClass('glyphicon-pause')

    progress: ->
        if @time >= grid.width
            @time = 0

        @shape.translation.x = @time * size.width

        @time += @speed if @playing

    reset: ->
        @time = 0
