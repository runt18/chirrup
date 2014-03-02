class TextLayer
    constructor: ->
        @font_size = 14

        @cvs = $('<canvas>')[0]
        @cvs.width = canvas.width
        @cvs.height = canvas.height

        @ctx = @cvs.getContext('2d')
        @ctx.font = "bold #{@font_size}px Arial"

    write: (s, x, y) ->
        @ctx.fillText(s, x, y + @font_size)

    appendTo: (el) ->
        $(@cvs).appendTo(el)
