bind_events = ->
    two.bind('update', (frameCount) ->
        ch.playhead.progress()
    ).play()

    main.on 'mousedown', (e) ->
        ch.mousedown = true
        pos = new Two.Vector(e.pageX, e.pageY)

        ch.debug_click(pos)

        switch ch.mode
            when Mode.ADD
                ch.add_note_screen(pos)
            when Mode.REMOVE
                ch.remove_note(ch.note_at(pos))
            when Mode.MOVE, Mode.RESIZE
                n = ch.note_at(pos)
                ch.selected = n if n?

    main.on 'mouseup', (e) ->
        ch.mousedown = false
        ch.selected = null

    main.on 'mousemove', (e) ->
        pos = new Two.Vector(e.pageX, e.pageY)

        return unless ch.mousedown

        switch ch.mode
            when Mode.ADD then ch.add_note_screen(pos)
            when Mode.REMOVE then ch.remove_note(ch.note_at(pos))
            when Mode.RESIZE then ch.resize_selected(pos)
            when Mode.MOVE then ch.move_selected(pos)

    body.on 'keydown', (e) ->
        # console.log e.keyCode
        switch e.keyCode
            # Spacebar toggles playback
            when 32 then ch.playhead.toggle()
            # A plays a note
            when 65 then audio.play_note(200)
            # Z sets mode to ADD
            when 90 then ch.set_mode('add')
            # X sets mode to REMOVE
            when 88 then ch.set_mode('remove')
            # C sets mode to RESIZE
            when 67 then ch.set_mode('resize')
            # V sets mode to ADD
            when 86 then ch.set_mode('move')
            # B sets mode to RESIZE
            when 66 then ch.set_mode('group')

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

    buttons.save.on 'click', (e) ->
        filename = fields.filename.val()

        unless filename
            alert 'Please name this project'
            return

        data =
            notes: (n.export() for n in ch.notes)

        localStorage["ch-#{filename}"] = JSON.stringify(data)

    buttons.open.on 'click', (e) ->
        filename = fields.filename.val()

        unless filename
            alert 'Choose a project to open'
            return

        s = localStorage["ch-#{filename}"]

        if s
            data = JSON.parse(s)
            for note in data.notes
                ch.add_note(new Two.Vector(note.time, note.pitch))
        else
            alert "#{filename} doesn't exist"

    fields.tempo.on 'change', (e) ->
        ch.set_tempo(parseFloat(fields.tempo.val()))

    fields.mode.on 'change', (e) ->
        ch.set_mode(fields.mode.val())

    fields.mode.trigger('change')
