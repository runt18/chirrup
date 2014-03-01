# Make an instance of two and place it on the page.
elem = $("#main")[0]
params =
  width: 285
  height: 200

two = new Two(params).appendTo(elem)

# two has convenience methods to create shapes.
circle = two.makeCircle(72, 100, 50)
rect = two.makeRectangle(213, 100, 100, 100)

# The object returned has many stylable properties:
circle.fill = "#FF8000"
circle.stroke = "orangered" # Accepts all valid css color
circle.linewidth = 5
rect.fill = "rgb(0, 200, 255)"
rect.opacity = 0.75
rect.noStroke()

# Don't forget to tell two to render everything
# to the screen
two.update()
