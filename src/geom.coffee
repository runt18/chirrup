class Rect
    constructor: (@x, @y, @width=size.width, @height=size.height) ->

    intersects: (v) ->
        (@x <= v.x <= @x + @width) and (@y <= v.y <= @y + @height)
