class Vector
    constructor: (@x, @y) ->

    add: (x, y) -> new Vector(@x + x, @y + y)

    subtract: (x, y) -> @add(-x, -y)

class Rect
    constructor: (@x, @y, @width=size.width, @height=size.height) ->

    intersects: (v) ->
        (@x <= v.x <= @x + @width) and (@y <= v.y <= @y + @height)
