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
