# Input Dialog

Display a form dialog with multiple input types, validation, and structured data return.

## Server API

### Using `retro` global

```lua
local result = retro.dialog(player, data)
```

### Using exports

```lua
local result = exports['retro-kit']:TriggerDialog(player, data)
```

## Parameters

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |
| `data`    | `table`  | ✅       | —       | Dialog definition (see below)  |

## Return Value

The function **yields** until the player submits or cancels the dialog.

- **Submitted:** Returns an **indexed array** with the values of each field, in the same order as `rows`.
- **Cancelled:** Returns `nil`.

```lua
local result = retro.dialog(source, {
    heading = "Example",
    rows = {
        { type = "input", label = "Name" },
        { type = "number", label = "Age", default = 18 },
        { type = "checkbox", label = "Agree", checked = false },
    },
})

if result then
    local name  = result[1] -- string
    local age   = result[2] -- number
    local agree = result[3] -- boolean
end
```

## Dialog Data Properties

| Property      | Type     | Required | Default    | Description                           |
| ------------- | -------- | -------- | ---------- | ------------------------------------- |
| `heading`     | `string` | ❌       | `"Dialog"` | Title displayed at the top            |
| `description` | `string` | ❌       | `nil`      | Description displayed below the title |
| `rows`        | `table`  | ✅       | —          | Array of field definitions            |
| `options`     | `table`  | ❌       | `{}`       | Dialog options (see below)            |

## Dialog Options

| Property      | Type      | Required | Default | Description                                 |
| ------------- | --------- | -------- | ------- | ------------------------------------------- |
| `allowCancel` | `boolean` | ❌       | `true`  | Allow closing the dialog without submitting |

## Field Types

### Input

A standard text input field.

```lua
{
    type = "input",
    label = "Player Name",
    placeholder = "John Doe",
    required = true,
    icon = "User",
    default = "Default value",
    disabled = false,
    password = false,
    min = 3,
    max = 50,
    description = "Enter the player's full name",
}
```

| Property      | Type      | Required | Default | Description                                |
| ------------- | --------- | -------- | ------- | ------------------------------------------ |
| `type`        | `string`  | ✅       | —       | Must be `"input"`                          |
| `label`       | `string`  | ✅       | —       | Field label                                |
| `placeholder` | `string`  | ❌       | `nil`   | Placeholder text                           |
| `required`    | `boolean` | ❌       | `false` | Whether the field is required              |
| `icon`        | `string`  | ❌       | `nil`   | Lucide icon name (e.g. `"User"`, `"Lock"`) |
| `default`     | `string`  | ❌       | `nil`   | Default value                              |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                          |
| `password`    | `boolean` | ❌       | `false` | Mask input as password                     |
| `min`         | `number`  | ❌       | `nil`   | Minimum character length                   |
| `max`         | `number`  | ❌       | `nil`   | Maximum character length                   |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field        |

**Returns:** `string`

---

### Textarea

A multi-line text input.

```lua
{
    type = "textarea",
    label = "Description",
    placeholder = "Enter details...",
    required = true,
    default = "",
    disabled = false,
    max = 500,
    rows = 4,
    description = "Provide a detailed description",
}
```

| Property      | Type      | Required | Default | Description                         |
| ------------- | --------- | -------- | ------- | ----------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"textarea"`                |
| `label`       | `string`  | ✅       | —       | Field label                         |
| `placeholder` | `string`  | ❌       | `nil`   | Placeholder text                    |
| `required`    | `boolean` | ❌       | `false` | Whether the field is required       |
| `default`     | `string`  | ❌       | `nil`   | Default value                       |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                   |
| `max`         | `number`  | ❌       | `nil`   | Maximum character length            |
| `rows`        | `number`  | ❌       | `3`     | Number of visible text rows         |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field |

**Returns:** `string`

---

### Number

A numeric input with optional min/max/step constraints.

```lua
{
    type = "number",
    label = "Amount",
    default = 100,
    min = 0,
    max = 10000,
    step = 50,
    required = true,
    disabled = false,
    description = "Enter the fine amount",
}
```

| Property      | Type      | Required | Default | Description                         |
| ------------- | --------- | -------- | ------- | ----------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"number"`                  |
| `label`       | `string`  | ✅       | —       | Field label                         |
| `default`     | `number`  | ❌       | `nil`   | Default value                       |
| `min`         | `number`  | ❌       | `nil`   | Minimum value                       |
| `max`         | `number`  | ❌       | `nil`   | Maximum value                       |
| `step`        | `number`  | ❌       | `1`     | Step increment                      |
| `required`    | `boolean` | ❌       | `false` | Whether the field is required       |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                   |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field |

**Returns:** `number`

---

### Slider

A range slider with visual feedback.

```lua
{
    type = "slider",
    label = "Volume",
    default = 50,
    min = 0,
    max = 100,
    step = 5,
    disabled = false,
    description = "Adjust the volume level",
}
```

| Property      | Type      | Required | Default | Description                         |
| ------------- | --------- | -------- | ------- | ----------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"slider"`                  |
| `label`       | `string`  | ✅       | —       | Field label                         |
| `default`     | `number`  | ❌       | `0`     | Default value                       |
| `min`         | `number`  | ❌       | `0`     | Minimum value                       |
| `max`         | `number`  | ❌       | `100`   | Maximum value                       |
| `step`        | `number`  | ❌       | `1`     | Step increment                      |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                   |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field |

**Returns:** `number`

---

### Checkbox

A boolean toggle.

```lua
{
    type = "checkbox",
    label = "Accept Terms",
    checked = false,
    required = true,
    disabled = false,
    description = "You must accept to continue",
}
```

| Property      | Type      | Required | Default | Description                         |
| ------------- | --------- | -------- | ------- | ----------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"checkbox"`                |
| `label`       | `string`  | ✅       | —       | Field label                         |
| `checked`     | `boolean` | ❌       | `false` | Default checked state               |
| `required`    | `boolean` | ❌       | `false` | Whether the field must be checked   |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                   |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field |

**Returns:** `boolean`

---

### Select

A single-value dropdown selector.

```lua
{
    type = "select",
    label = "Department",
    placeholder = "Select a department",
    required = true,
    disabled = false,
    options = {
        { value = "lspd",  label = "LSPD" },
        { value = "bcso",  label = "BCSO" },
        { value = "ems",   label = "EMS" },
    },
    description = "Choose your department",
}
```

| Property      | Type      | Required | Default | Description                         |
| ------------- | --------- | -------- | ------- | ----------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"select"`                  |
| `label`       | `string`  | ✅       | —       | Field label                         |
| `placeholder` | `string`  | ❌       | `nil`   | Placeholder text                    |
| `required`    | `boolean` | ❌       | `false` | Whether the field is required       |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                   |
| `options`     | `table`   | ✅       | —       | Array of option objects (see below) |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field |

#### Option Object

| Property | Type     | Required | Default       | Description              |
| -------- | -------- | -------- | ------------- | ------------------------ |
| `value`  | `string` | ✅       | —             | Value returned on submit |
| `label`  | `string` | ❌       | same as value | Display label            |

**Returns:** `string` (the selected option's `value`)

---

### Multi-Select

A multi-value dropdown selector.

```lua
{
    type = "multi-select",
    label = "Certifications",
    placeholder = "Select certifications",
    required = true,
    disabled = false,
    options = {
        { value = "firearms",   label = "Firearms" },
        { value = "taser",      label = "Taser" },
        { value = "k9",         label = "K9 Unit" },
        { value = "helicopter", label = "Helicopter" },
    },
    description = "Select all applicable certifications",
}
```

| Property      | Type      | Required | Default | Description                                  |
| ------------- | --------- | -------- | ------- | -------------------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"multi-select"`                     |
| `label`       | `string`  | ✅       | —       | Field label                                  |
| `placeholder` | `string`  | ❌       | `nil`   | Placeholder text                             |
| `required`    | `boolean` | ❌       | `false` | Whether at least one option must be selected |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                            |
| `options`     | `table`   | ✅       | —       | Array of option objects (same as select)     |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field          |

**Returns:** `table` (array of selected `value` strings)

---

### Color

A color picker input.

```lua
{
    type = "color",
    label = "Vehicle Color",
    default = "#3b82f6",
    format = "hex",
    disabled = false,
    description = "Pick the vehicle's primary color",
}
```

| Property      | Type      | Required | Default | Description                                                  |
| ------------- | --------- | -------- | ------- | ------------------------------------------------------------ |
| `type`        | `string`  | ✅       | —       | Must be `"color"`                                            |
| `label`       | `string`  | ✅       | —       | Field label                                                  |
| `default`     | `string`  | ❌       | `nil`   | Default color value                                          |
| `format`      | `string`  | ❌       | `"hex"` | Return format: `"hex"`, `"rgb"`, `"rgba"`, `"hsl"`, `"hsla"` |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                                            |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field                          |

**Returns:** `string` (color in the specified format)

---

### Date

A date picker with popover calendar.

```lua
{
    type = "date",
    label = "Event Date",
    default = true, -- today
    min = "2024-01-01",
    max = "2026-12-31",
    returnString = true,
    format = "DD/MM/YYYY",
    disabled = false,
    description = "Select the event date",
}
```

| Property       | Type              | Required | Default        | Description                                         |
| -------------- | ----------------- | -------- | -------------- | --------------------------------------------------- |
| `type`         | `string`          | ✅       | —              | Must be `"date"`                                    |
| `label`        | `string`          | ✅       | —              | Field label                                         |
| `default`      | `boolean\|string` | ❌       | `nil`          | `true` for today, or a date string (`"YYYY-MM-DD"`) |
| `min`          | `string`          | ❌       | `nil`          | Minimum selectable date (`"YYYY-MM-DD"`)            |
| `max`          | `string`          | ❌       | `nil`          | Maximum selectable date (`"YYYY-MM-DD"`)            |
| `required`     | `boolean`         | ❌       | `false`        | Whether the field is required                       |
| `disabled`     | `boolean`         | ❌       | `false`        | Disable the field                                   |
| `returnString` | `boolean`         | ❌       | `false`        | Return formatted string instead of timestamp        |
| `format`       | `string`          | ❌       | `"DD/MM/YYYY"` | Date format (dayjs/moment tokens)                   |
| `placeholder`  | `string`          | ❌       | `nil`          | Placeholder text when no date is selected           |
| `description`  | `string`          | ❌       | `nil`          | Help text displayed below the field                 |

**Returns:**

- `returnString = true`: `string` (formatted date, e.g. `"20/02/2026"`)
- `returnString = false`: `number` (Unix timestamp in milliseconds)

---

### Date Range

A date range picker with popover dual calendar.

```lua
{
    type = "date-range",
    label = "Suspension Period",
    default = { "2025-01-01", "2025-06-01" },
    min = "2024-01-01",
    max = "2027-12-31",
    returnString = true,
    format = "DD/MM/YYYY",
    disabled = false,
    description = "Select the suspension start and end dates",
}
```

| Property       | Type             | Required | Default        | Description                                                |
| -------------- | ---------------- | -------- | -------------- | ---------------------------------------------------------- |
| `type`         | `string`         | ✅       | —              | Must be `"date-range"`                                     |
| `label`        | `string`         | ✅       | —              | Field label                                                |
| `default`      | `boolean\|table` | ❌       | `nil`          | `true` for today–today, or `{ "from", "to" }` date strings |
| `min`          | `string`         | ❌       | `nil`          | Minimum selectable date (`"YYYY-MM-DD"`)                   |
| `max`          | `string`         | ❌       | `nil`          | Maximum selectable date (`"YYYY-MM-DD"`)                   |
| `required`     | `boolean`        | ❌       | `false`        | Whether the field is required                              |
| `disabled`     | `boolean`        | ❌       | `false`        | Disable the field                                          |
| `returnString` | `boolean`        | ❌       | `false`        | Return formatted strings instead of timestamps             |
| `format`       | `string`         | ❌       | `"DD/MM/YYYY"` | Date format (dayjs/moment tokens)                          |
| `placeholder`  | `string`         | ❌       | `nil`          | Placeholder text when no range is selected                 |
| `description`  | `string`         | ❌       | `nil`          | Help text displayed below the field                        |

**Returns:**

- `returnString = true`: `table` with `{ "formatted_from", "formatted_to" }`
- `returnString = false`: `table` with `{ timestamp_from, timestamp_to }`

---

### Time

A time input field.

```lua
{
    type = "time",
    label = "Start Time",
    default = "14:30",
    disabled = false,
    description = "Select the start time",
}
```

| Property      | Type      | Required | Default | Description                                    |
| ------------- | --------- | -------- | ------- | ---------------------------------------------- |
| `type`        | `string`  | ✅       | —       | Must be `"time"`                               |
| `label`       | `string`  | ✅       | —       | Field label                                    |
| `default`     | `string`  | ❌       | `nil`   | Default time value (`"HH:mm"` or `"HH:mm:ss"`) |
| `required`    | `boolean` | ❌       | `false` | Whether the field is required                  |
| `disabled`    | `boolean` | ❌       | `false` | Disable the field                              |
| `description` | `string`  | ❌       | `nil`   | Help text displayed below the field            |

**Returns:** `string` (time in `"HH:mm:ss"` format)

## Date Format Tokens

The `format` property for date and date-range fields uses dayjs/moment-style tokens. These are automatically converted internally.

| Token  | Description    | Example |
| ------ | -------------- | ------- |
| `YYYY` | 4-digit year   | `2026`  |
| `YY`   | 2-digit year   | `26`    |
| `MM`   | Month (padded) | `02`    |
| `DD`   | Day (padded)   | `20`    |
| `D`    | Day (no pad)   | `5`     |

## Examples

### Simple Text Input

```lua
local result = retro.dialog(source, {
    heading = "What's your name?",
    rows = {
        {
            type = "input",
            label = "Name",
            placeholder = "Enter your name",
            required = true,
        },
    },
})

if result then
    print("Player name: " .. result[1])
end
```

### Form with Multiple Fields

```lua
local result = retro.dialog(source, {
    heading = "Character Creation",
    description = "Fill in your character details.",
    options = { allowCancel = true },
    rows = {
        {
            type = "input",
            label = "First Name",
            placeholder = "John",
            required = true,
            icon = "User",
        },
        {
            type = "input",
            label = "Last Name",
            placeholder = "Doe",
            required = true,
            icon = "User",
        },
        {
            type = "number",
            label = "Age",
            default = 25,
            min = 18,
            max = 80,
        },
        {
            type = "select",
            label = "Gender",
            required = true,
            options = {
                { value = "male",   label = "Male" },
                { value = "female", label = "Female" },
            },
        },
    },
})

if result then
    local firstName = result[1]
    local lastName  = result[2]
    local age       = result[3]
    local gender    = result[4]
    print(("%s %s, age %d, %s"):format(firstName, lastName, age, gender))
end
```

### Police Report Form

```lua
local result = retro.dialog(source, {
    heading = "Police Report",
    description = "Fill in the violation report details.",
    options = { allowCancel = true },
    rows = {
        {
            type = "input",
            label = "Suspect Name",
            placeholder = "John Doe",
            required = true,
            icon = "User",
        },
        {
            type = "select",
            label = "Violation Type",
            placeholder = "Select violation",
            required = true,
            options = {
                { value = "speeding",         label = "Speeding" },
                { value = "red_light",        label = "Red Light" },
                { value = "reckless_driving", label = "Reckless Driving" },
                { value = "dui",              label = "DUI" },
            },
        },
        {
            type = "textarea",
            label = "Incident Description",
            placeholder = "Describe the incident...",
            max = 500,
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
            type = "date",
            label = "Violation Date",
            default = true,
            returnString = true,
            format = "DD/MM/YYYY",
        },
        {
            type = "time",
            label = "Violation Time",
            default = "14:30",
        },
        {
            type = "checkbox",
            label = "Paid on Spot",
            checked = false,
        },
    },
})

if result then
    local report = {
        suspect     = result[1],
        violation   = result[2],
        description = result[3],
        fine        = result[4],
        date        = result[5],
        time        = result[6],
        paidOnSpot  = result[7],
    }
    -- Process the report...
end
```

### Date and Time Selection

```lua
local result = retro.dialog(source, {
    heading = "Schedule Event",
    description = "Pick the event date, time, and duration.",
    rows = {
        {
            type = "date",
            label = "Event Date",
            default = true,
            min = "2025-01-01",
            max = "2026-12-31",
            returnString = true,
            format = "DD/MM/YYYY",
        },
        {
            type = "time",
            label = "Start Time",
            default = "18:00",
        },
        {
            type = "date-range",
            label = "Registration Period",
            default = { "2025-06-01", "2025-06-15" },
            returnString = true,
            format = "DD/MM/YYYY",
        },
    },
})

if result then
    local eventDate   = result[1] -- "20/02/2026"
    local startTime   = result[2] -- "18:00:00"
    local regPeriod   = result[3] -- { "01/06/2025", "15/06/2025" }

    print(("Event on %s at %s"):format(eventDate, startTime))
    print(("Registration: %s to %s"):format(regPeriod[1], regPeriod[2]))
end
```

### Color Selection

```lua
local result = retro.dialog(source, {
    heading = "Vehicle Customization",
    description = "Choose your vehicle colors.",
    rows = {
        {
            type = "color",
            label = "Primary Color",
            default = "#3b82f6",
            format = "hex",
        },
        {
            type = "color",
            label = "Secondary Color",
            default = "#ef4444",
            format = "rgb",
        },
        {
            type = "color",
            label = "Neon Color",
            default = "rgba(139, 92, 246, 0.8)",
            format = "rgba",
        },
    },
})

if result then
    local primary   = result[1] -- "#3b82f6"
    local secondary = result[2] -- "rgb(239, 68, 68)"
    local neon      = result[3] -- "rgba(139, 92, 246, 0.8)"
end
```

### Using Exports

```lua
local result = exports['retro-kit']:TriggerDialog(source, {
    heading = "Quick Input",
    rows = {
        {
            type = "input",
            label = "Reason",
            placeholder = "Enter a reason",
            required = true,
        },
    },
})

if result then
    print("Reason: " .. result[1])
end
```

## Flow Diagram

```
Server                    Client (Lua)              NUI (React)
  │                           │                         │
  │  retro.dialog(player, {}) │                         │
  │  (creates promise)        │                         │
  │                           │                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:openDialog"  │── SendNUIMessage ──────>│
  │                           │   "openDialog"          │  (form renders)
  │                           │                         │
  │                           │                         │  [Player fills form]
  │                           │                         │  [Player clicks Submit]
  │                           │                         │
  │                           │<── NUI Callback ────────│
  │                           │    "inputData"          │  (form data array)
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:dialogResult"│                         │
  │                           │                         │
  │  (promise resolves)       │                         │
  │  result = { ... }         │                         │
  │                           │                         │
  │       — CANCEL —          │                         │
  │                           │                         │
  │                           │                         │  [Player presses ESC]
  │                           │<── NUI Callback ────────│
  │                           │    "inputData"          │  (nil)
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:dialogResult"│                         │
  │                           │                         │
  │  (promise resolves)       │                         │
  │  result = nil             │                         │
```

## Important Notes

- **The function yields.** `retro.dialog` blocks the current thread until the player submits or cancels. Use it inside a `Citizen.CreateThread` or event handler.
- **Results are indexed by position.** The returned array follows the same order as the `rows` definition.
- **Date strings use dayjs/moment tokens.** Internally converted for display. Tokens like `DD`, `MM`, `YYYY` are supported.
- **Dates are timezone-aware.** Strings in `YYYY-MM-DD` format are parsed as local dates to avoid UTC offset issues.
- **`returnString` affects date return types.** When `false` (default), dates return as Unix timestamps in milliseconds. When `true`, they return as formatted strings.
- **Only one dialog per player.** Opening a new dialog while one is active will replace the pending promise.
- **`allowCancel = true`** (default) allows the player to close the dialog with ESC or the close button. Set to `false` to force submission.
