Config = {}

Config.debug = true
Config.locale = "pt-br"

Config.colors = {
  primary = "#E54646",
  secondary = "#911414",
}

Config.Bridge = {
  framework = "qbcore", -- "esx", "qbox", "qbcore", "vrpex", "creative" or "auto"
  inventory = "ox_inventory", -- "esx_inventoryhud", "qb-inventory", "ox_inventory" or "auto"
  target = "ox_target", -- "qb", "ox", "none" or "auto"
}

Config.notification = {
  defaultDuration = 5000,
  defaultPosition = "top-right",
}
Config.alert = {
  defaultSize = "md",
  icon = "Bell"
}

return Config
