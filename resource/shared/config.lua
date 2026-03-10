Config = {}

Config.debug = false
Config.locale = "en"

Config.colors = {
  primary = "#E54646",
  secondary = "#911414",
}

Config.Bridge = {
  framework = "auto", -- "esx", "qbox", "qbcore", "vrp" or "auto"
  inventory = "auto", -- "qb-inventory", "ox_inventory", "es_extended",  or "auto"
  target = "auto", -- "qb", "ox", "none" or "auto"
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
