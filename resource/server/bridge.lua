-- ══════════════════════════════════════════
-- BRIDGE EXPORTS (server-side)
-- ══════════════════════════════════════════

exports("GetBridgeInventory", function()
  return Bridge and Bridge.inventory or nil
end)

exports("GetBridgeFramework", function()
  return Bridge and Bridge.framework or nil
end)