class Synth extends AudioletGroup
    constructor: (audiolet, freq) ->
        AudioletGroup.apply(this, [audiolet, 0, 1])

        @sine = new Sine(@audiolet, freq)
        @modulator = new Saw(@audiolet, freq * 2)
        @mulAdd = new MulAdd(@audiolet, freq / 2, freq)

        @gain = new Gain(@audiolet)
        cb = -> @audiolet.scheduler.addRelative(0, @remove.bind(this))
        @envelope = new Envelope(@audiolet, 1, [1, 1, 0], [0.5, 0.1], 3, cb.bind(this))

        @modulator.connect(@mulAdd)
        @mulAdd.connect(@sine)
        @envelope.connect(@gain, 0, 1)
        @sine.connect(@gain)
        @gain.connect(@outputs[0])

play_note = (freq) ->
    fs = new PSequence([freq], 1)
    audiolet.scheduler.play([fs], 1, ((f) ->
        synth = new Synth(audiolet, f)
        synth.connect(audiolet.output)
    ).bind(this))
