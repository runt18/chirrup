bind_events = ->
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
        pitch = grid.height - Math.floor(screen.y / size.height)

        if start >= 0
            note = new Note(pitch, start)
            ch.notes.push(note)
        else
            if ch.preview
                note = new Note(pitch, start, false)
                note.play()

        console.log ch.notes

    body.on 'keydown', (e) ->
        switch e.keyCode
            # Spacebar toggles playback
            when 32 then ch.playhead.toggle()
            # A plays a note
            when 65 then ch.notes[0].play()
            # TODO add musical typing

    buttons.play.on 'click', (e) ->
        ch.play()

    buttons.reset.on 'click', (e) ->
        ch.reset()
        ch.playhead.reset()

    buttons.preview.on 'click', (e) ->
        buttons.preview.toggleClass('btn-primary')
        ch.preview = !ch.preview

    buttons.clear.on 'click', (e) ->
        ch.clear()

    fields.tempo.on 'change', (e) ->
        ch.set_tempo(parseFloat(fields.tempo.val()))

    fields.mode.on 'change', (e) ->
        cs.set_mode(fields.mode.val())
