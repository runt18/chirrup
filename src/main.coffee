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
            yy = y * size.height
            two.makeLine(0, yy, params.width, yy)

        # Draw vertical lines
        for x in [0..grid.width]
            xx = x * size.width
            two.makeLine(xx, 0, xx, params.height)

        # Draw piano
        for y in [grid.height..0] by -1
            note = (grid.height - y) % 12
            rect = two.makeRectangle(-0.5 * size.width, (y - 0.5) * size.height, size.width, size.height)
            rect.fill = if note in ch.sharps then 'black' else 'white'

    init()
    bind_events()
    two.update()
