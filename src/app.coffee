Mode =
    ADD: 1
    REMOVE: 2
    RESIZE: 3
    MOVE: 4
    GROUP: 5

class App
    constructor: ->
        @notes = []
        @pitches = null
        @tempo = 128
        @preview = true
        @noteIdx = 0
        @mode = Mode.ADD
        @mousedown = false
        @selected = null
        @debug = false

        @cursor_map =
            add: 'pointer'
            remove: 'pointer'
            move: 'move'
            resize: 'ew-resize'
            group: 'crosshair'

        @playhead = new Playhead(this, @tempo, icon)
        fields.tempo.val(@tempo)

        $.ajax
            type: 'GET',
            url: 'data/pitches.json',
            dataType: 'json'
            async: false
            success: (data) => @pitches = data

        if @preview
            fields.preview.addClass('btn-primary')

    set_tempo: (@tempo) ->
        @playhead.set_speed(@tempo)

    remove_note: (note) ->
        return unless note?
        note.remove()
        @notes.splice(@notes.indexOf(note), 1)

    screen_to_canvas: (pos) ->
        o = main.offset()
        new Two.Vector().sub(pos, new Two.Vector(o.left + border.left, o.top + border.top))

    canvas_to_grid: (pos) ->
        new Two.Vector(
            Math.floor(pos.x / size.width),
            Math.floor(pos.y / size.height)
        )

    screen_to_grid: (pos) ->
        @canvas_to_grid(@screen_to_canvas(pos))

    debug_click: (pos) ->
        pos = @screen_to_canvas(pos)
        if @debug
            c = two.makeCircle(pos.x, pos.y, 20)
            c.fill = 'green'

    add_note_screen: (pos) ->
        pos = @screen_to_grid(pos)
        pos.y = grid.height - pos.y - 1
        @add_note(pos)

    add_note: (pos) ->
        if pos.x >= 0 and pos.y >= 0
            note = new Note(pos.y, pos.x)
            @notes.push(note)
        else if pos.x >= 0 and pos.y < 0
            @playhead.set_time(pos.x)
        else if pos.x < 0 and pos.y >= 0
            if @preview
                audio.play_note(Note.pitch_to_freq(pos.y))

    move_selected: (pos) ->
        return unless @selected?
        pos = @screen_to_grid(pos)
        @selected.set_start(pos.x)
        @selected.set_pitch(pos.y)

    resize_selected: (pos) ->
        return unless @selected?
        pos = @screen_to_grid(pos)
        @selected.set_duration(pos.x)

    clear: ->
        console.log @notes
        for note in @notes
            note.remove()

        @notes = []

    play: ->
        @playhead.toggle()
        iterations = 1
        freqs = (0 for x in [1..grid.width])
        for note in @notes
            freqs[note.start] = note.freq
        frequencies = new PSequence(freqs, iterations, Math.ceil(@playhead.time))
        duration = @tempo / (60 * 4)

        audiolet.scheduler.play([frequencies], duration, ((freq) ->
            synth = new Synth(audiolet, freq, duration / 2)
            synth.connect(audiolet.output)
        ).bind(this))

    next_note: ->
        if @notes.length is 0 then null else @notes[@noteIdx]

    advance: ->
        @noteIdx++
        @reset() if @noteIdx >= @notes.length

    reset: ->
        @noteIdx = 0

    set_mode: (str) ->
        @mode = Mode[str.toUpperCase()]
        fields.mode.val(str)
        main.css('cursor', @cursor_map[str])

    note_at: (v) ->
        v = @screen_to_canvas(v)
        for note in @notes
            # console.log "Checking (#{v.x}, #{v.y}) against (#{note.rect.x}, #{note.rect.y})"
            if note.rect.intersects(v)
                return note

        return null
