if not require("nixCatsUtils").enableForCategory("extra", true) then
  return {}
end

return {
  { import = "plugins.extra.editor" },
  { import = "plugins.extra.debug" },
  { import = "plugins.extra.languages" },
}
