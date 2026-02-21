-- ══════════════════════════════════════════
-- BRIDGE EXPORTS (client-side)
-- ══════════════════════════════════════════

exports("GetBridgeTarget", function()
  return Bridge and Bridge.target or nil
end)

exports("GetBridgeFramework", function()
  return Bridge and Bridge.framework or nil
end)

exports("GetBridgeInventory", function()
  return Bridge and Bridge.inventory or nil
end)