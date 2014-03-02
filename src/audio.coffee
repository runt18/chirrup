class Synth extends AudioletGroup
    constructor: (audiolet, freq, dur) ->
        AudioletGroup.apply(this, [audiolet, 0, 1])

        @sine = new Sine(@audiolet, freq)
        @modulator = new Saw(@audiolet, freq * 2)
        @mulAdd = new MulAdd(@audiolet, freq / 2, freq)

        @gain = new Gain(@audiolet)
        cb = -> @audiolet.scheduler.addRelative(0, @remove.bind(this))
        @envelope = new Envelope(@audiolet, 1, [1, 1, 0], [dur, 0.01], 3, cb.bind(this))

        @modulator.connect(@mulAdd)
        @mulAdd.connect(@sine)
        @envelope.connect(@gain, 0, 1)
        @sine.connect(@gain)
        @gain.connect(@outputs[0])

class Audio
    play_note: (freq) ->
        console.log "Playing #{freq}"
        sine = new Sine(audiolet, freq)
        envelope = new Envelope(audiolet, 1, [1, 1, 0], [0.2, 0.01], 3)
        gain = new Gain(audiolet)
        envelope.connect(gain, 0, 1)
        sine.connect(gain)
        gain.connect(audiolet.output)
