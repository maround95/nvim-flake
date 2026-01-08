local boot_colorscheme = Utils.nixCats.getCatOrDefault("colorscheme", "nightfox")

local setup = {
  nightfox = function()
    require("nightfox.config").set_fox("nightfox")
    require("nightfox").load()
  end,
  terafox = function()
    require("nightfox.config").set_fox("terafox")
    require("nightfox").load()
  end,
  tokyonight = function()
    require("tokyonight").load()
  end,
}

return setup[boot_colorscheme] or boot_colorscheme
