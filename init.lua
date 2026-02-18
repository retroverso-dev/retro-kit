-- Validate resource name
local resourceName = GetCurrentResourceName()

if GetResourceState('retro-kit') ~= 'started' then
    local msg = ('^1[retro-kit] Resource "retro-kit" is not started. Make sure it is running before starting "%s".^0'):format(resourceName)
    print(msg)
    error(msg)
    return
end

-- Prevent loading init.lua from the retro-kit resource itself
if resourceName == 'retro-kit' then
    return
end

-- Prevent double initialization in the same resource
if _G.__RETRO_KIT_LOADED__ then
    local msg = ('^3[retro-kit] Warning: init.lua already loaded in "%s". Skipping duplicate initialization.^0'):format(resourceName)
    print(msg)
    return
end

_G.__RETRO_KIT_LOADED__ = true

-- Get retro-kit version
local version = GetResourceMetadata('retro-kit', 'version', 0) or 'unknown'
print(('^2[retro-kit] v%s loaded in resource "%s"^0'):format(version, resourceName))

-- Export retro-kit library namespace
---@class RetroKit
---@field version string
---@field resourceName string
retro = retro or {}
retro.version = version
retro.resourceName = 'retro-kit'

--- Send a notification via retro-kit NUI
---@param data { style: string, title: string, description: string, duration?: number, showDuration?: boolean, icon?: string, iconAnimation?: string, iconColor?: string, position?: string }
function retro.notify(data)
    exports['retro-kit']:notify(data)
end

--- Send an alert dialog via retro-kit NUI
---@param data { title: string, description: string, size?: string, cancel?: boolean, labels?: { cancel?: string, confirm?: string }, icon?: string, iconAnimation?: string, iconColor?: string }
---@param cb? fun(button: string) Callback when the alert is closed
function retro.alert(data, cb)
    exports['retro-kit']:alert(data, cb)
end