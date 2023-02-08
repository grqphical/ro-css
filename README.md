# ro-css
A CSS Parser made for Roblox

## How to Use
Either copy the source from ro-css.lua or add the toolbox model (https://www.roblox.com/library/12415105266/RoCSS) to your project. Then in a local script require the library and use this piece of code to parse any CSS code:
```lua
local module = require(MODULE_LOCATION)

module.ParseCSS(CSS_AS_STRING)
```

To apply the CSS to UI just add a string attribute called **Class** to whatever UI element you want (Make sure it's placed in StarterGUI) and ro-css should automatically apply the CSS to it. For example if you created a CSS block of:
```css
.foobar {
  background-color: rgb(1,1,1);
}
```

ro-css will apply it to any element with the Class "foobar"

Here are the available properties:
```lua
{
		["anchor-point"] = "AnchorPoint",
		["background-color"] = "BackgroundColor3",
		["transparency"] = "BackgroundTransparency",
		["border-color"] = "BorderColor3",
		["border-size"] = "BorderSizePixel",
		["position"] = "Position",
		["rotation"] = "Rotation",
		["size"] = "Size",
		["z-index"] = "ZIndex",
		["text-color"] = "TextColor3",
		["text-size"] = "TextSize",
		["text-stroke-color"] = "TextStrokeColor3",
		["text-stroke-transparency"] = "TextStrokeTransparency",
		["text-transparency"] = "TextTransparency",
		["image-color"] = "ImageColor3",
		["image-offset"] = "ImageRectOffset",
		["image-size"] = "ImageRectSize",
		["placeholder-text-color"] = "PlaceholderColor3"
		
}
```

## Notes

MAKE SURE TO ADD SEMICOLONS TO THE END OF EVERY LINE ELSE IT WILL NOT PARSE CORRECTLY
