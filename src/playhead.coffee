 class Playhead
    constructor: (@parent, tempo) ->
        @playing = false
        @time = 0
        @shape = two.makeLine(@time, 0, @time, piano_roll.height)
        @shape.stroke = 'red'
        @set_speed(tempo)

    set_speed: (tempo) ->
        # App runs at 60 FPS. Convert BPM to BPF by dividing by 60 * 60.
        @speed = tempo / 3600

    toggle: ->
        @playing = !@playing
        icon = buttons.play.find('i')
        icon.toggleClass('glyphicon-play')
        icon.toggleClass('glyphicon-pause')

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
