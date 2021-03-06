class Note
    constructor: (@pitch=0, @start=0, @render=true, @duration=1, @velocity=100) ->
        @border = 6

        if @render
            @rect = new Rect(
                @start * size.width,
                (grid.height - @pitch - 1) * size.height,
                size.width - @border,
                size.height - @border
            )
            @shape = two.makeRectangle(@rect.x + size.width / 2, @rect.y + size.height / 2, @rect.width, @rect.height)
            @shape.fill = '#EC0013'
            @shape.stroke = '#333'
            @played = false

            @update_freq()

    @pitch_to_freq: (pitch) ->
        ch.pitches[pitch % NOTES_PER_OCTAVE].freq * (Math.floor(pitch / NOTES_PER_OCTAVE) + 1)

    update_freq: ->
        @freq = Note.pitch_to_freq(@pitch)

    set_start: (x) ->
        @rect.x = x * size.width
        @shape.translation.x = (x + 0.5) * size.width
        @start = x

    set_pitch: (x) ->
        @rect.y = @pitch * size.height
        @shape.translation.y = (x + 0.5) * size.height
        @pitch = x
        @update_freq()

    set_duration: (x) ->
        @rect.width = x
        left = (x - @start - 0.5) * size.width - @border / 2
        @shape.vertices[0].x = @shape.vertices[3].x = left
        @duration = x

    end: -> @start + @duration

    remove: ->
        two.remove(@shape) if @render

    export: ->
        props = ['duration', 'frequency', 'pitch', 'start', 'velocity']
        o = {}
        for prop in props
            o[prop] = this[prop]

        return o

