@onload = =>
  @rot = new Rotate(document.getElementById("page"))

class Rotate
  constructor: (el)->
    @el = el
    @container = @el.parentNode
    dim = @el.getBoundingClientRect()
    @origine =
      x0: dim.left + dim.width/2
      y0: dim.top + dim.height/2
    @container.onmousedown = @handleMouseDown
    # settings transform target once, @zyll
    @_transformVP = null
    for b in ['transform', 'webkitTransform', "MozTransform", 'msTransform', "OTransform"] when @el.style[b]?
      @_transformVP = b


  handleMouseDown: (ev)=>
    @container.onmousemove = @handleMouseMove
    @container.onmouseup = @handleMouseUp

  handleMouseMove: (ev)=>
    @coords =
      x: ev.clientX
      y: ev.clientY
    @rotateContent()

  handleMouseUp: =>
    @container.onmousemove = ->
    @container.onmouseup = ->
    

  rotateContent:=>
    vect =
      x: @coords.x - @origine.x0
      y: @coords.y - @origine.y0
    # vn represents the vector normalized
    n = @norme(vect)
    vn =
      x: vect.x / n
      y: vect.y / n
    # the dot product of vn and (1,0) gives cos(alpha)
    @alpha = Math.asin(vn.y)
    @beta = (@alpha + Math.PI/2) * @sign(vect.x)
    deg = @rad2deg(@beta)
    styleString = "rotate(#{deg}deg)"
    @el.style[@_transformVP] = styleString
    #@el.style.webkitTransform = styleString
    
  norme: (vect)->
    Math.sqrt(Math.pow(vect.x,2) + Math.pow(vect.y,2))

  rad2deg: (rad)->
    rad*360/(2*Math.PI)

  sign: (x)->
    x/Math.abs(x)
