# coronasdk-slider

Turn a display object into a sliding panel

## Usage

### 1. Install
Setup [lua-loader](https://github.com/wscherphof/lua-loader) and then just `npm install coronasdk-slider`

### 2. Require
```lua
local Slider = require("coronasdk-slider")
```

### 3. Have fun
```lua
local panel = display.newRect(...)
local slidingpanel = Slider:new({}, panel)
slidingpanel.on("slide") = function (position)
  if "left" == position then print("panel closed") end
  if "right" == position then print("panel open") end
end
```
Now the user can swipe your panel. But you can also let it swipe by code, e.g. when the user taps a certain button: `slidingpanel.slide("left")` or `slidingpanel.slide("right")`

Happen to have a TableView widget that you want to slide? Do this:
```lua
local tableview = widget.newTableView(...)
local view = tableview[2] -- yes, it's dirty
local slidingpanel = Slider:new({}, view, {moveobject = tableview})
```

## License
[GNU Lesser General Public License (LGPL)](http://www.gnu.org/licenses/lgpl-3.0.txt)
