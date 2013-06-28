local EventEmitter = require("lua-events").EventEmitter

local slider = {}

function slider:new (base, touchobject, options)
  local base = base or {}
  local options = options or {}
  local limits = {
    left = options.left or 0,
    right = options.right or display.viewableContentWidth * .8
  }
  local position = options.position or "left"
  local startthreshold = options.startthreshold or 10
  local swipethreshold = options.swipethreshold or 75
  local moveobject = options.moveobject or touchobject

  local instance = EventEmitter:new(base)
  function instance:slide (leftorright)
    self:emit("slide", leftorright)
    if moveobject.x == limits[leftorright] then return end
    position = leftorright
    transition.to(moveobject, {
      time = 400,
      transition = easing.outExpo,
      x = limits[leftorright]
    })
  end

  local defaulttouch = touchobject.touch
  local sliding, scrolling, prev
  function touchobject:touch (event)

    -- desired behaviour:
    -- * start scrolling or sliding only when moved more than a certain threshold
    -- * no sliding while scrolling; no scrolling while sliding
    -- * only scrolling if in left position
    -- * when sliding, snap back to current position if not slided further than a certain threshold
    -- * when in right position, sliding to the left will do the nice sliding; any other movement,
    --   including tapping, will snap it back to the left position

    local function direction ()
      if event.x > event.xStart then return "right"
      else return "left" end
    end

    local distance = {}
    function distance._d (a, b) return math.abs(a - b) end
    function distance:x () return self._d(event.x, event.xStart) end
    function distance:y () return self._d(event.y, event.yStart) end

    if "began" == event.phase then
      sliding, scrolling = false, false
      defaulttouch(touchobject, event)

    elseif "moved" == event.phase then
      if not sliding and not scrolling
      and "left" == position
      and distance:y() > startthreshold then
        scrolling = true
      end
      if not scrolling and not sliding
      and direction() ~= position
      and distance:x() > startthreshold then
        sliding = true
      end

      if scrolling then
        defaulttouch(touchobject, event)
      elseif sliding
      and moveobject.x >= limits.left and moveobject.x <= limits.right then
        moveobject.x = moveobject.x + (event.x - prev)
      end

    elseif "ended" == event.phase or "canceled" == event.phase then
      if sliding then
        if distance:x() > swipethreshold then
          instance:slide(direction())
        else
          instance:slide(position)
        end
      elseif "right" == position then
        instance:slide("left")
      end
      sliding, scrolling = false, false
      defaulttouch(touchobject, event)
    end

    prev = event.x
    return true
  end

  return instance
end

return slider
