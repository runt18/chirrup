# for note in ch.notes
#     if note.rect.intersects(screen)
#         note.remove()
#         return

cursor_map =
    add: 'pointer'
    move: 'move'
    resize: 'ew-resize'
    group: 'crosshair'

bind_events = ->
    two.bind('update', (frameCount) ->
        ch.playhead.progress()
    ).play()

    main.on 'mousedown', (e) ->
        ch.mousedown = true
        pos = new Vector(e.pageX, e.pageY)

        switch ch.mode
            when Mode.ADD
                ch.add_note(pos)
            when Mode.MOVE
                n = ch.note_at(pos)
                ch.selected = n if n?

    main.on 'mouseup', (e) ->
        ch.mousedown = false
        ch.selected = null

    main.on 'mousemove', (e) ->
        pos = new Vector(e.pageX, e.pageY)

        if ch.mousedown
            switch ch.mode
                when Mode.ADD
                    ch.add_note(pos)
                when Mode.MOVE
                    if ch.selected?
                        ch.selected.shape.translation.set(pos.x, pos.y)

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
        mode = fields.mode.val()
        main.css('cursor', cursor_map[mode])
        ch.set_mode(mode)

    fields.mode.trigger('change')
