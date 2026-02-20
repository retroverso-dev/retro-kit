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

local config = {
  debug = true,
  locale = "en",
}

local function LoadLocaleFile(localeName)
  local file = GetCurrentResourceName() .. "/locales/" .. localeName .. ".json"
  return LoadResourceFile(GetCurrentResourceName(), file)
end

local function LoadLocale()
  local localeName = config.locale or "en"
  local localeData = LoadLocaleFile(localeName)

  if not localeData then
    print(("^3[retro-kit]^7 Locale '%s' not found, falling back to 'en'"):format(localeName))
    localeData = LoadLocaleFile("en")
  end

  if not localeData then
    print("^1[retro-kit]^7 Failed to load any locale file!")
    return
  end

  local locale = json.decode(localeData)

  if not locale then
    print(("^1[retro-kit]^7 Failed to parse locale '%s'"):format(localeName))
    return
  end

  return locale
end

local function Initialize()
  if config.debug then
    print(("Retro Kit initialized for player: %s"):format(source))
  end
end

RegisterNetEvent("retro-kit:init")
AddEventHandler("retro-kit:init", function()
  local src = source
  local config = RetroKitServer.config or {}
  local localeName = config.locale or "en"

  local localeData = LoadResourceFile(GetCurrentResourceName(), "locales/" .. localeName .. ".json")

  if not localeData then
    print(("^3[retro-kit]^7 Locale '%s' not found, falling back to 'en'"):format(localeName))
    localeData = LoadResourceFile(GetCurrentResourceName(), "locales/en.json")
  end

  if not localeData then
    print("^1[retro-kit]^7 Failed to load any locale file!")
    return
  end

  local locale = json.decode(localeData)

  if not locale then
    print(("^1[retro-kit]^7 Failed to parse locale '%s'"):format(localeName))
    return
  end

  TriggerClientEvent("retro-kit:setLocale", src, locale)

  if config.debug then
    print(("^2[retro-kit]^7 Locale '%s' (%s) sent to player %d"):format(localeName, locale.language or "?", src))
  end
end)

Initialize()