$ ->
    # Grab main page elements
    main = $('#main')
    body = $('body')

    # Grab buttons
    bids = ['play', 'reset', 'preview', 'clear', 'metronome', 'quantize', 'undo', 'redo', 'open', 'save']
    buttons[bid] = $('#' + bid) for bid in bids

    # Grab fields
    fids = ['tempo']
    fields[fid] = $('#' + fid) for fid in fids

    # TODO: refactor this
    icon = buttons.play.find('i')

    class App
        constructor: ->
            @notes = []
            @sharps = [1, 3, 6, 8, 10]
            @pitches = null
            @tempo = 128
            @preview = false
            @noteIdx = 0

            @playhead = new Playhead(this, @tempo, icon)
            fields.tempo.val(@tempo)

            $.getJSON 'data/pitches.json', (data) =>
                @pitches = data

        set_tempo: (@tempo) ->
            @playhead.set_speed(@tempo)

        remove_note: (note) ->
            note.remove()
            @notes.splice(@notes.indexOf(note), 1)

        clear: ->
            console.log @notes
            for note in @notes
                note.remove()

            @notes = []

        play: ->
            @playhead.toggle()
            @notes = _.sortBy(@notes, (note) -> note.start)

        next_note: ->
            if @notes.length is 0 then null else @notes[@noteIdx]

        advance: ->
            @noteIdx++
            @reset() if @noteIdx >= @notes.length

        reset: ->
            @noteIdx = 0

    two.appendTo(main[0])
    two.scene.translation.set(border.left, border.top)

    ch = new App()

    init = ->
        # Draw horizontal lines
        for y in [0..grid.height]
            line = two.makeLine(0, y * size.height, params.width, y * size.height)

        # Draw vertical lines
        for x in [0..params.width] by size.width
            line = two.makeLine(x, 0, x, params.height)

        # Draw piano
        for y in [grid.height..0] by -1
            note = (grid.height - y) % 12
            rect = two.makeRectangle(-size.width / 2, y * size.height - size.height / 2, size.width, size.height)
            rect.fill = if note in ch.sharps then 'black' else 'white'

    init()
    bind_events()
    two.update()
