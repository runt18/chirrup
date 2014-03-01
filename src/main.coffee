$ ->
    main = $('#main')
    body = $('body')

    buttons =
        play: $("#play")
        reset: $("#reset")

    fields =
        tempo: $('#tempo')

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

    class Note
        constructor: (@pitch=0, @start=0, @duration=1, @velocity=100) ->
            @rect = new Rect((@start + 0.5) * size.width, (@pitch + 0.5) * size.height)
            @shape = two.makeRectangle(@rect.x, @rect.y, @rect.width, @rect.height)
            @shape.fill = 'red'
            @shape.noStroke()

        remove: ->
            two.remove(@shape)
            notes.splice(notes.indexOf(this), 1)

    class Vector
        constructor: (@x, @y) ->

    class Rect
        constructor: (@x, @y, @width=size.width, @height=size.height) ->

        intersects: (v) ->
            (@x < v.x < @x + @width) and (@y < v.y < @y + @height)

    class Playhead
        constructor: ->
            @playing = false
            @time = 0
            @speed = 0.02
            @shape = two.makeLine(@time, 0, @time, params.height)
            @shape.stroke = 'red'

        toggle: ->
            @playing = !@playing
            icon.toggleClass('glyphicon-play')
            icon.toggleClass('glyphicon-pause')

        progress: ->
            if @time >= grid.width
                @time = 0

            @shape.translation.x = @time * size.width

            @time += @speed if @playing

        reset: ->
            @time = 0

    class App
        constructor: ->
            @notes = []
            @playhead = new Playhead()
            @sharps = [1, 3, 6, 8, 10]
            @pitches = null
            @tempo = 128

            fields.tempo.val(@tempo)

            $.getJSON 'data/pitches.json', (data) =>
                @pitches = data


    two = new Two(params).appendTo(main[0])
    two.scene.translation.set(border.left, border.top)

    ch = new App()

    for y in [0..grid.height]
        line = two.makeLine(0, y * size.height, params.width, y * size.height)

    play_note = (freq) ->
        sine = T('sin', {freq:freq, mul:0.5})
        T('perc', {r:500}, sine).on('ended', -> this.pause()).bang().play()

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

        console.log ch.notes

    body.on 'keydown', (e) ->
        console.log e
        switch e.keyCode
            when 32 then ch.playhead.toggle()
            when 65 then play_note(200)

    icon = buttons.play.find('i')

    buttons.play.on 'click', (e) ->
        ch.playhead.toggle()
        return false

    buttons.reset.on 'click', (e) -> ch.playhead.reset()

    fields.tempo.on 'change', (e) -> ch.tempo = parseFloat(fields.tempo.val())

    two.update()
