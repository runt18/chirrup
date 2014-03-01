$ ->
    main = $('#main')
    body = $('body')

    buttons =
        play: $("#play")
        reset: $("#reset")
        preview: $('#preview')

    fields =
        tempo: $('#tempo')

    icon = buttons.play.find('i')

    class Note
        constructor: (@pitch=0, @start=0, render=true, @duration=1, @velocity=100) ->
            if render
                @rect = new Rect((@start + 0.5) * size.width, (@pitch + 0.5) * size.height)
                @shape = two.makeRectangle(@rect.x, @rect.y, @rect.width, @rect.height)
                @shape.fill = 'red'
                @shape.noStroke()

        play: ->
            freq = ch.pitches[@pitch % 12].freq
            sine = T('sin', {freq:freq, mul:0.5})
            T('perc', {r:500}, sine).on('ended', -> this.pause()).bang().play()

        remove: ->
            two.remove(@shape)
            notes.splice(notes.indexOf(this), 1)

    class Vector
        constructor: (@x, @y) ->

    class Rect
        constructor: (@x, @y, @width=size.width, @height=size.height) ->

        intersects: (v) ->
            (@x < v.x < @x + @width) and (@y < v.y < @y + @height)

    class App
        constructor: ->
            @notes = []
            @playhead = new Playhead(two, icon)
            @sharps = [1, 3, 6, 8, 10]
            @pitches = null
            @tempo = 128
            @preview = false

            fields.tempo.val(@tempo)

            $.getJSON 'data/pitches.json', (data) =>
                @pitches = data

    two = new Two(params).appendTo(main[0])
    two.scene.translation.set(border.left, border.top)

    ch = new App()

    for y in [0..grid.height]
        line = two.makeLine(0, y * size.height, params.width, y * size.height)

    note = 0
    for y in [grid.height..0] by -1
        rect = two.makeRectangle(-size.width / 2, y * size.height - size.height / 2, size.width, size.height)
        rect.fill = if note % 12 in ch.sharps then 'black' else 'white'
        note++

    for x in [0..params.width] by size.width
        line = two.makeLine(x, 0, x, params.height)

    two.bind('update', (frameCount) ->
        ch.playhead.progress()
    ).play()

    main.on 'mousedown', (e) ->
        o = main.offset()

        screen = new Vector(
            e.pageX - o.left - border.left,
            e.pageY - o.top - border.top
        )

        for note in ch.notes
            if note.rect.intersects(screen)
                note.remove()
                return

        start = Math.floor(screen.x / size.width)
        pitch = Math.floor(screen.y / size.height)

        if start >= 0
            note = new Note(pitch, start)
            ch.notes.push(note)
        else
            if ch.preview
                note = new Note(pitch, start, false)
                note.play()

        console.log ch.notes

    body.on 'keydown', (e) ->
        console.log e
        switch e.keyCode
            when 32 then ch.playhead.toggle()
            when 65 then ch.notes[0].play()

    buttons.play.on 'click', (e) ->
        ch.playhead.toggle()
        return false

    buttons.reset.on 'click', (e) ->
        ch.playhead.reset()
        return false

    buttons.preview.on 'click', (e) ->
        buttons.preview.toggleClass('btn-primary')
        ch.preview = !ch.preview
        return false

    fields.tempo.on 'change', (e) -> ch.tempo = parseFloat(fields.tempo.val())

    two.update()
