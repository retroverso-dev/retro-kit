import { IColorInput } from "@/typings/dialog";
import { Control, useController } from "react-hook-form";
import { FormValues } from "../InputDialog";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { Pipette } from "lucide-react";
import React, { useState, useCallback } from "react";

interface Props {
  row: IColorInput;
  index: number;
  control: Control<FormValues>;
}

// ── Conversion utils ────────────────────────────────────────

function hexToRgb(hex: string): [number, number, number] {
  let h = hex.replace("#", "");
  if (h.length === 3)
    h = h
      .split("")
      .map((c) => c + c)
      .join("");
  const n = parseInt(h, 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
}

function rgbToHex(r: number, g: number, b: number): string {
  return (
    "#" +
    [r, g, b]
      .map((c) =>
        Math.max(0, Math.min(255, Math.round(c)))
          .toString(16)
          .padStart(2, "0"),
      )
      .join("")
  );
}

function rgbToHsl(r: number, g: number, b: number): [number, number, number] {
  r /= 255;
  g /= 255;
  b /= 255;
  const max = Math.max(r, g, b),
    min = Math.min(r, g, b);
  const l = (max + min) / 2;
  let h = 0,
    s = 0;
  if (max !== min) {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r:
        h = ((g - b) / d + (g < b ? 6 : 0)) / 6;
        break;
      case g:
        h = ((b - r) / d + 2) / 6;
        break;
      case b:
        h = ((r - g) / d + 4) / 6;
        break;
    }
  }
  return [Math.round(h * 360), Math.round(s * 100), Math.round(l * 100)];
}

function hslToRgb(h: number, s: number, l: number): [number, number, number] {
  h /= 360;
  s /= 100;
  l /= 100;
  if (s === 0) {
    const v = Math.round(l * 255);
    return [v, v, v];
  }
  const hue2rgb = (p: number, q: number, t: number) => {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  };
  const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  const p = 2 * l - q;
  return [
    Math.round(hue2rgb(p, q, h + 1 / 3) * 255),
    Math.round(hue2rgb(p, q, h) * 255),
    Math.round(hue2rgb(p, q, h - 1 / 3) * 255),
  ];
}

// ── Format helpers ──────────────────────────────────────────

type ColorFormat = IColorInput["format"];

function hexToFormat(hex: string, format: ColorFormat, alpha = 1): string {
  const [r, g, b] = hexToRgb(hex);
  const [h, s, l] = rgbToHsl(r, g, b);
  const a = Math.max(0, Math.min(1, alpha));

  switch (format) {
    case "hexa":
      return (
        hex +
        Math.round(a * 255)
          .toString(16)
          .padStart(2, "0")
      );
    case "rgb":
      return `rgb(${r}, ${g}, ${b})`;
    case "rgba":
      return `rgba(${r}, ${g}, ${b}, ${a})`;
    case "hsl":
      return `hsl(${h}, ${s}%, ${l}%)`;
    case "hsla":
      return `hsla(${h}, ${s}%, ${l}%, ${a})`;
    case "hex":
    default:
      return hex;
  }
}

function parseColorToHex(value: string): { hex: string; alpha: number } | null {
  if (!value) return null;
  const v = value.trim();

  // #RGB or #RRGGBB
  if (/^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/.test(v)) {
    return {
      hex: v.length === 4 ? "#" + v[1] + v[1] + v[2] + v[2] + v[3] + v[3] : v,
      alpha: 1,
    };
  }

  // #RRGGBBAA
  if (/^#([0-9A-Fa-f]{8})$/.test(v)) {
    const hex = v.slice(0, 7);
    const alpha = parseInt(v.slice(7, 9), 16) / 255;
    return { hex, alpha: Math.round(alpha * 100) / 100 };
  }

  // rgb(r, g, b)
  const rgbMatch = v.match(
    /^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+))?\s*\)$/,
  );
  if (rgbMatch) {
    const hex = rgbToHex(+rgbMatch[1], +rgbMatch[2], +rgbMatch[3]);
    return {
      hex,
      alpha: rgbMatch[4] !== undefined ? parseFloat(rgbMatch[4]) : 1,
    };
  }

  // hsl(h, s%, l%)
  const hslMatch = v.match(
    /^hsla?\(\s*(\d+)\s*,\s*(\d+)%\s*,\s*(\d+)%\s*(?:,\s*([\d.]+))?\s*\)$/,
  );
  if (hslMatch) {
    const [r, g, b] = hslToRgb(+hslMatch[1], +hslMatch[2], +hslMatch[3]);
    const hex = rgbToHex(r, g, b);
    return {
      hex,
      alpha: hslMatch[4] !== undefined ? parseFloat(hslMatch[4]) : 1,
    };
  }

  return null;
}

function getPlaceholder(format: ColorFormat): string {
  switch (format) {
    case "hexa":
      return "#000000ff";
    case "rgb":
      return "rgb(0, 0, 0)";
    case "rgba":
      return "rgba(0, 0, 0, 1)";
    case "hsl":
      return "hsl(0, 0%, 0%)";
    case "hsla":
      return "hsla(0, 0%, 0%, 1)";
    case "hex":
    default:
      return "#000000";
  }
}

function getDefaultValue(format: ColorFormat): string {
  return hexToFormat("#000000", format, 1);
}

// ── Component ───────────────────────────────────────────────

const ColorField: React.FC<Props> = ({ row, index, control }) => {
  const format = row.format ?? "hex";
  const hasAlpha = format === "hexa" || format === "rgba" || format === "hsla";

  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    defaultValue: row.default ?? getDefaultValue(format),
    rules: { required: row.required },
  });

  const parseInitial = useCallback(() => {
    const parsed = parseColorToHex(controller.field.value);
    return parsed ?? { hex: "#000000", alpha: 1 };
  }, []);

  const initial = parseInitial();
  const [hexInput, setHexInput] = useState(
    controller.field.value || getDefaultValue(format),
  );
  const [alpha, setAlpha] = useState(initial.alpha);
  const [previewHex, setPreviewHex] = useState(initial.hex);

  const updateValue = (hex: string, a: number) => {
    setPreviewHex(hex);
    setAlpha(a);
    const formatted = hexToFormat(hex, format, a);
    controller.field.onChange(formatted);
    setHexInput(formatted);
  };

  const handleTextChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setHexInput(val);

    const parsed = parseColorToHex(val);
    if (parsed) {
      setPreviewHex(parsed.hex);
      setAlpha(parsed.alpha);
      controller.field.onChange(val);
    }
  };

  const handleTextBlur = () => {
    const parsed = parseColorToHex(hexInput);
    if (!parsed) {
      // Revert to current value
      const current = parseColorToHex(controller.field.value);
      if (current) {
        setHexInput(controller.field.value);
        setPreviewHex(current.hex);
        setAlpha(current.alpha);
      } else {
        const def = getDefaultValue(format);
        setHexInput(def);
        setPreviewHex("#000000");
        setAlpha(1);
        controller.field.onChange(def);
      }
    }
    controller.field.onBlur();
  };

  const handleNativeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    updateValue(e.target.value, alpha);
  };

  const handleAlphaChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const a = parseFloat(e.target.value);
    if (!isNaN(a)) {
      updateValue(previewHex, a);
    }
  };

  return (
    <Field key={index}>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      <div className="flex flex-col gap-3">
        {/* Preview + Text input */}
        <div className="flex items-center gap-2">
          <div className="relative">
            {/* Checkerboard for alpha preview */}
            <div
              className="size-9 shrink-0 rounded-md cursor-pointer overflow-hidden"
              style={{
                backgroundImage:
                  "linear-gradient(45deg, #808080 25%, transparent 25%), linear-gradient(-45deg, #808080 25%, transparent 25%), linear-gradient(45deg, transparent 75%, #808080 75%), linear-gradient(-45deg, transparent 75%, #808080 75%)",
                backgroundSize: "8px 8px",
                backgroundPosition: "0 0, 0 4px, 4px -4px, -4px 0px",
              }}
            >
              <div
                className="size-full"
                style={{
                  backgroundColor: previewHex,
                  opacity: alpha,
                }}
              />
            </div>
            <input
              type="color"
              value={previewHex}
              onChange={handleNativeChange}
              disabled={row.disabled}
              className="absolute inset-0 size-full cursor-pointer opacity-0"
            />
          </div>
          <div className="relative flex-1">
            <Pipette className="text-muted-foreground absolute left-3 top-1/2 size-3.5 -translate-y-1/2" />
            <Input
              value={hexInput}
              onChange={handleTextChange}
              onBlur={handleTextBlur}
              disabled={row.disabled}
              placeholder={getPlaceholder(format)}
              className="pl-9 font-mono text-xs"
            />
          </div>
        </div>

        {/* Alpha slider */}
        {hasAlpha && (
          <div className="flex items-center gap-2">
            <span className="text-muted-foreground text-xs w-12 shrink-0">
              Alpha
            </span>
            <input
              type="range"
              min={0}
              max={1}
              step={0.01}
              value={alpha}
              onChange={handleAlphaChange}
              disabled={row.disabled}
              className="flex-1 h-2 rounded-full appearance-none cursor-pointer bg-linear-to-r from-transparent to-current"
              style={{ color: previewHex }}
            />
            <span className="text-muted-foreground text-xs tabular-nums w-10 text-right">
              {Math.round(alpha * 100)}%
            </span>
          </div>
        )}
      </div>
    </Field>
  );
};

export default ColorField;
