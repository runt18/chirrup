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
