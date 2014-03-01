 class Note
        constructor: (@pitch=0, @start=0, @render=true, @duration=1, @velocity=100) ->
            if @render
                @rect = new Rect((@start + 0.5) * size.width, (grid.height - @pitch + 0.5) * size.height)
                @shape = two.makeRectangle(@rect.x, @rect.y, @rect.width, @rect.height)
                @shape.fill = 'red'
                @shape.noStroke()
                @played = false

            @freq = ch.pitches[@pitch % 12].freq
            @sine = T('sin', {freq: @freq, mul: 0.5})

        end: -> @start + @duration

        play: ->
            T('perc', {r:500}, @sine).on('ended', -> this.pause()).bang().play()

        remove: ->
            two.remove(@shape) if @render
