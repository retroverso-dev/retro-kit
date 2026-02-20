if GetResourceState('retro-kit') ~= 'started' then
  return
end

local thisResource = GetCurrentResourceName()
if thisResource == 'retro-kit' then
  return
end

if _G.__RETRO_KIT_LOADED__ then
  return
end
_G.__RETRO_KIT_LOADED__ = true

local function import(path)
  local chunkSource = LoadResourceFile('retro-kit', path)
  if not chunkSource then
    error(('[retro-kit] import failed, file not found: %s'):format(path))
  end

  local chunk, loadErr = load(chunkSource, ('@@retro-kit/%s'):format(path))
  if not chunk then
    error(('[retro-kit] import failed, load error on %s: %s'):format(path, loadErr))
  end

  return chunk()
end

import('imports/bootstrap.lua')
import('imports/ui.lua')
import('imports/bridge.lua')