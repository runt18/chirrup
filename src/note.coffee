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
                @shape.fill = 'red'
                @shape.noStroke()
                @played = false

            @freq = ch.pitches[@pitch % NOTES_PER_OCTAVE].freq * (Math.floor(@pitch / NOTES_PER_OCTAVE) + 1)
            @sine = T('sin', {freq: @freq, mul: 0.5})

        end: -> @start + @duration

        play: ->
            T('perc', {r:500}, @sine).on('ended', -> this.pause()).bang().play()

        remove: ->
            two.remove(@shape) if @render
