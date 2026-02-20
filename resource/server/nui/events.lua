-- This file is part of Retro Kit.
-- 
-- Retro Kit is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- Retro Kit is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with Retro Kit.  If not, see <http://www.gnu.org/licenses/>.

local function LoadLocale(localeName)
  localeName = localeName or "en"

  local localeData = LoadResourceFile(GetCurrentResourceName(), "locales/" .. localeName .. ".json")

  if not localeData then
    print(("^3[retro-kit]^7 Locale '%s' not found, falling back to 'en'"):format(localeName))
    localeData = LoadResourceFile(GetCurrentResourceName(), "locales/en.json")
  end

  if not localeData then
    print("^1[retro-kit]^7 Failed to load any locale file!")
    return nil
  end

  local locale = json.decode(localeData)

  if not locale then
    print(("^1[retro-kit]^7 Failed to parse locale '%s'"):format(localeName))
    return nil
  end

  return locale
end

RegisterNetEvent("retro-kit:init")
AddEventHandler("retro-kit:init", function()
  local src = source
  local config = RetroKitServer.config or {}

  -- Load locale
  local locale = LoadLocale(config.locale)

  -- Build NUI config payload
  local nuiConfig = {
    locale = locale,
    colors = config.colors or {},
  }

  TriggerClientEvent("retro-kit:initData", src, nuiConfig)

  if config.debug then
    local localeName = config.locale or "en"
    local langLabel = locale and locale.language or "?"
    print(("^2[retro-kit]^7 Init data sent to player %d (locale: %s [%s], colors: primary=%s, secondary=%s)"):format(
      src,
      localeName,
      langLabel,
      config.colors and config.colors.primary or "default",
      config.colors and config.colors.secondary or "default"
    ))
  end
end)