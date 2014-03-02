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

play_note = (freq) ->
    audiolet.scheduler.addAbsolute(0, (->
        synth = new Synth(audiolet, freq)
        synth.connect(audiolet.output)
    ).bind(this))
