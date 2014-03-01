grid =
    width: 16
    height: 12

border =
    left: 50
    right: 0
    top: 0
    bottom: 0

params =
  width: 800 + border.left + border.right
  height: 600 + border.top + border.bottom

size =
    width: params.width / grid.width
    height: params.height / grid.height

two = new Two(params)
ch = null
main = body = icon = null
buttons = fields = {}
