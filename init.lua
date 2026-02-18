if GetResourceState('retro-kit') ~= 'started' then
  return
end

local resourceName = GetCurrentResourceName()

if resourceName == 'retro-kit' then
    return
end

if _G.__RETRO_KIT_LOADED__ then
    local msg = ('^3[retro-kit] Warning: init.lua already loaded in "%s". Skipping duplicate initialization.^0'):format(resourceName)
    print(msg)
    return
end

_G.__RETRO_KIT_LOADED__ = true

local version = GetResourceMetadata('retro-kit', 'version', 0) or 'unknown'
print(('^2[retro-kit] v%s loaded in resource "%s"^0'):format(version, resourceName))


---@class RetroKit
---@field version string
---@field resourceName string
retro = retro or {}
retro.version = version
retro.resourceName = 'retro-kit'


---@param player number
---@param data { style?: string, title?: string, description?: string, duration?: number, showDuration?: boolean, icon?: string, iconAnimation?: string, iconColor?: string, position?: string }
function retro.notify(player, data)
    data = data or {}

    return exports['retro-kit']:TriggerNotification(
        player,
        data.title or "Notification",
        data.description or "",
        data.style or "info",
        {
            duration = data.duration,
            showDuration = data.showDuration,
            icon = data.icon,
            iconAnimation = data.iconAnimation,
            iconColor = data.iconColor,
            position = data.position
        }
    )
end


---@param player number
---@param data { title?: string, description?: string, size?: string, cancel?: boolean, labels?: { cancel?: string, confirm?: string }, icon?: string, iconAnimation?: string, iconColor?: string }
function retro.alert(player, data)
    data = data or {}

    return exports['retro-kit']:TriggerAlert(
        player,
        data.title or "Alert",
        data.description or "",
        {
            size = data.size,
            cancel = data.cancel,
            labels = data.labels,
            icon = data.icon,
            iconAnimation = data.iconAnimation,
            iconColor = data.iconColor
        }
    )
end