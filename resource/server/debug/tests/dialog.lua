return function(tests, ui)

  -- ══════════════════════════════════════════
  -- LOGGING UTILS
  -- ══════════════════════════════════════════

  local fieldLabels = {
    full = {
      "Suspect Name", "Operator Password", "Incident Description",
      "Violation Type", "Additional Violations", "Fine Amount ($)",
      "Severity Level", "Pay on Spot", "Violation Date",
      "License Suspension Period", "Violation Time", "Vehicle Color",
    },
    simple = { "Your Name" },
    number = { "Quantity", "Quality (%)" },
    color  = { "Primary Color", "Secondary Color (RGBA)" },
    date   = { "Event Date", "Event Time", "Event Period" },
  }

  local currentVariant = "full"

  local function formatValue(v)
    if v == nil then
      return "nil"
    end

    if type(v) == "boolean" then
      return v and "^2true^7" or "^1false^7"
    end

    if type(v) == "table" then
      local parts = {}
      for _, item in ipairs(v) do
        parts[#parts + 1] = tostring(item)
      end
      return "[ " .. table.concat(parts, ", ") .. " ]"
    end

    return tostring(v)
  end

  local function logDialogResult(src, result, heading)
    if not result then
      print(("^1[retro-kit]^7 Dialog '%s' cancelled by player %d"):format(heading, src))
      ui.notify(src, {
        style = "warning",
        title = "Cancelled",
        description = ("'%s' was cancelled."):format(heading),
        icon = "XCircle",
        duration = 3000,
      })
      return
    end

    local labels = fieldLabels[currentVariant] or {}
    local count = type(result) == "table" and #result or 0

    print(("^2[retro-kit]^7 Dialog '%s' submitted by player %d (%d fields):"):format(heading, src, count))
    print("  ┌──────────────────────────────────────────────")

    if type(result) == "table" then
      for i, v in ipairs(result) do
        local label = labels[i] or ("Field " .. i)
        local typeTag = type(v)

        if type(v) == "table" then
          typeTag = "table[" .. #v .. "]"
        end

        print(("  │ ^3[%d]^7 %-30s ^8(%s)^7 = %s"):format(i, label, typeTag, formatValue(v)))
      end
    else
      print(("  │ ^3[raw]^7 %s"):format(formatValue(result)))
    end

    print("  └──────────────────────────────────────────────")

    local lines = {}
    if type(result) == "table" then
      for i, v in ipairs(result) do
        local label = labels[i] or ("Field " .. i)
        lines[#lines + 1] = ("%s: %s"):format(label, formatValue(v):gsub("%^%d", ""))
      end
    end

    ui.notify(src, {
      style = "success",
      title = ("'%s' Submitted"):format(heading),
      description = #lines > 0
        and table.concat(lines, "\n")
        or ("Received %d field(s)."):format(count),
      icon = "CheckCircle",
      iconAnimation = "bounce",
      duration = 8000,
    })
  end

  -- ══════════════════════════════════════════
  -- DIALOG VARIANTS
  -- ══════════════════════════════════════════

  local variants = {
    full = function(src)
      local result = ui.dialog(src, {
        heading = "Police Report",
        description = "Fill in the details of the violation report.",
        options = {
          allowCancel = true,
        },
        rows = {
          {
            type = "input",
            label = "Suspect Name",
            placeholder = "John Doe",
            required = true,
            icon = "User",
          },
          {
            type = "input",
            label = "Operator Password",
            placeholder = "Enter your password",
            password = true,
            required = true,
            icon = "Lock",
          },
          {
            type = "textarea",
            label = "Incident Description",
            placeholder = "Describe the incident in detail...",
            max = 500,
          },
          {
            type = "select",
            label = "Violation Type",
            placeholder = "Select violation",
            required = true,
            options = {
              { value = "speeding",          label = "Speeding" },
              { value = "red_light",         label = "Red Light" },
              { value = "reckless_driving",  label = "Reckless Driving" },
              { value = "dui",               label = "DUI" },
              { value = "hit_and_run",       label = "Hit and Run" },
            },
          },
          {
            type = "multi-select",
            label = "Additional Violations",
            placeholder = "Select additional violations",
            options = {
              { value = "no_license",        label = "No License" },
              { value = "expired_plates",    label = "Expired Plates" },
              { value = "tinted_windows",    label = "Tinted Windows" },
              { value = "illegal_mods",      label = "Illegal Modifications" },
              { value = "no_insurance",      label = "No Insurance" },
            },
          },
          {
            type = "number",
            label = "Fine Amount ($)",
            default = 500,
            min = 0,
            max = 50000,
            step = 100,
          },
          {
            type = "slider",
            label = "Severity Level",
            default = 3,
            min = 1,
            max = 10,
            step = 1,
          },
          {
            type = "checkbox",
            label = "Pay on Spot",
            checked = false,
          },
          {
            type = "date",
            label = "Violation Date",
            default = true,
            returnString = true,
            format = "DD/MM/YYYY",
          },
          {
            type = "date-range",
            label = "License Suspension Period",
            default = { "2025-01-01", "2025-06-01" },
            returnString = true,
            format = "DD/MM/YYYY",
          },
          {
            type = "time",
            label = "Violation Time",
            default = "14:30",
          },
          {
            type = "color",
            label = "Vehicle Color",
            default = "#3b82f6",
            format = "hex",
          },
        },
      })

      logDialogResult(src, result, "Police Report")
    end,

    simple = function(src)
      local result = ui.dialog(src, {
        heading = "Quick Input",
        description = "Enter a value below.",
        rows = {
          {
            type = "input",
            label = "Your Name",
            placeholder = "Enter your name",
            required = true,
          },
        },
      })

      logDialogResult(src, result, "Quick Input")
    end,

    number = function(src)
      local result = ui.dialog(src, {
        heading = "Set Amount",
        description = "Configure the values below.",
        rows = {
          {
            type = "number",
            label = "Quantity",
            default = 1,
            min = 1,
            max = 100,
            step = 1,
          },
          {
            type = "slider",
            label = "Quality (%)",
            default = 50,
            min = 0,
            max = 100,
            step = 5,
          },
        },
      })

      logDialogResult(src, result, "Set Amount")
    end,

    color = function(src)
      local result = ui.dialog(src, {
        heading = "Pick a Color",
        description = "Choose a color for your vehicle.",
        rows = {
          {
            type = "color",
            label = "Primary Color",
            default = "#ef4444",
            format = "hex",
          },
          {
            type = "color",
            label = "Secondary Color (RGBA)",
            default = "rgba(59, 130, 246, 0.8)",
            format = "rgba",
          },
        },
      })

      logDialogResult(src, result, "Pick a Color")
    end,

    date = function(src)
      local result = ui.dialog(src, {
        heading = "Schedule Event",
        description = "Pick a date and time.",
        rows = {
          {
            type = "date",
            label = "Event Date",
            default = true,
            returnString = true,
            format = "DD/MM/YYYY",
          },
          {
            type = "time",
            label = "Event Time",
            default = "18:00",
          },
          {
            type = "date-range",
            label = "Event Period",
            returnString = true,
            format = "DD/MM/YYYY",
          },
        },
      })

      logDialogResult(src, result, "Schedule Event")
    end,
  }

  -- ══════════════════════════════════════════
  -- REGISTER
  -- ══════════════════════════════════════════

  tests["dialog"] = function(src, args)
    local variant = (args[2] or "full"):lower()
    currentVariant = variant
    local handler = variants[variant] or variants["full"]
    if not variants[variant] then currentVariant = "full" end
    handler(src)
  end

  tests["input"] = tests["dialog"]

end