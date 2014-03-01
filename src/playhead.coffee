 class Playhead
    constructor: (@parent, @icon) ->
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
        return unless @playing

        if @time >= grid.width
            @time = 0

        next = @parent.next_note()

        if next and @time >= next.start and @time <= next.end()
            next.play()
            @parent.advance()

        @shape.translation.x = @time * size.width

        @time += @speed

    reset: ->
        @time = 0
