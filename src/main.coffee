class TextLayer
    constructor: ->
        @font_size = 14

        @cvs = $('<canvas>')[0]
        @cvs.width = canvas.width
        @cvs.height = canvas.height

        @ctx = @cvs.getContext('2d')
        @ctx.font = "bold #{@font_size}px Arial"

    write: (s, x, y) ->
        @ctx.fillText(s, x, y + @font_size)

    appendTo: (el) ->
        $(@cvs).appendTo(el)

$ ->
    # Grab main page elements
    main = $('#main')
    body = $('body')

    # Grab buttons
    bids = ['play', 'reset', 'preview', 'clear', 'metronome', 'quantize', 'undo', 'redo', 'open', 'save']
    buttons[bid] = $('#' + bid) for bid in bids

    # Grab fields
    fids = ['tempo', 'mode']
    fields[fid] = $('#' + fid) for fid in fids

    $('#controls button').tooltip()

    two.appendTo(main[0])
    two.scene.translation.set(border.left, border.top)

    ch = new App()

    audiolet = new Audiolet()

    audiolet.scheduler.addAbsolute 4, ->
        synth = new Synth(audiolet, 440)
        synth.connect(audiolet.output)

    tl = new TextLayer()
    tl.appendTo(main)
    for bar in [1..BARS]
        for beat in [1..BEATS_PER_BAR]
            tl.write("#{bar}.#{beat}", ((bar - 1) * 4 + beat) * size.width, 10)

    for note in [0...grid.height]
        abs_note = note % NOTES_PER_OCTAVE
        tl.ctx.fillStyle = if abs_note in SHARPS then 'white' else 'black'
        name = ch.pitches[abs_note].name
        name += 3 + Math.floor(note / NOTES_PER_OCTAVE)
        y = canvas.height + 5 - ((note + 1) * size.height)
        tl.write(name, 10, y)

    init = ->
        # Draw horizontal lines
        for y in [0..grid.height]
            yy = y * size.height
            two.makeLine(0, yy, piano_roll.width, yy)

        # Draw vertical lines
        for x in [0..grid.width]
            xx = x * size.width
            two.makeLine(xx, 0, xx, piano_roll.height)

        # Draw piano
        for y in [grid.height..1] by -1
            note = (grid.height - y) % 12
            rect = two.makeRectangle(-0.5 * size.width, (y - 0.5) * size.height, size.width, size.height)
            rect.fill = if note in SHARPS then 'black' else 'white'

    init()
    bind_events()
    two.update()
