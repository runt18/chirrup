Mode =
    ADD: 1
    RESIZE: 2
    MOVE: 3
    GROUP: 4

class App
    constructor: ->
        @notes = []
        @sharps = [1, 3, 6, 8, 10]
        @pitches = null
        @tempo = 128
        @preview = false
        @noteIdx = 0
        @mode = Mode.ADD
        @mousedown = false
        @selected = null
        @debug = false

        @cursor_map =
            add: 'pointer'
            move: 'move'
            resize: 'ew-resize'
            group: 'crosshair'

        @playhead = new Playhead(this, @tempo, icon)
        fields.tempo.val(@tempo)

        # TODO: could be a race condition here. Maybe make Async, shouldn't be
        # too slow
        $.getJSON 'data/pitches.json', (data) =>
            @pitches = data

    set_tempo: (@tempo) ->
        @playhead.set_speed(@tempo)

    remove_note: (note) ->
        note.remove()
        @notes.splice(@notes.indexOf(note), 1)

    screen_to_canvas: (pos) ->
        o = main.offset()
        pos.subtract(o.left + border.left, o.top + border.top)

    canvas_to_grid: (pos) ->
        new Vector(
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

    add_note: (pos) ->
        pos = @screen_to_grid(pos)
        start = pos.x
        pitch = grid.height - pos.y - 1
        console.log pitch

        if start >= 0
            note = new Note(pitch, start)
            @notes.push(note)
        else
            if @preview
                note = new Note(pitch, start, false)
                note.play()

    move_selected: (pos) ->
        return unless @selected?
        pos = @screen_to_grid(pos)
        @selected.shape.translation.set((pos.x + 0.5) * size.width, (pos.y + 0.5) * size.height)

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
