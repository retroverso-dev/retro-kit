import React, { Context, createContext, useContext, useState } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";

interface Colors {
  primary?: string;
  secondary?: string;
}

interface ConfigContextValue {
  colors: Colors;
}

const ConfigContext = createContext<ConfigContextValue | null>(null);

// ══════════════════════════════════════════
// COLOR CONVERSION UTILS
// ══════════════════════════════════════════

function parseHex(hex: string): string {
  let cleaned = hex.replace(/^#/, "");

  // Handle AARRGGBB format (e.g. "FFE54646")
  if (cleaned.length === 8 && /^[a-f\d]{8}$/i.test(cleaned)) {
    cleaned = cleaned.substring(2); // strip alpha prefix
  }

  // Handle shorthand (e.g. "F00")
  if (cleaned.length === 3) {
    cleaned = cleaned
      .split("")
      .map((c) => c + c)
      .join("");
  }

  return "#" + cleaned;
}

function hexToRgb(hex: string): [number, number, number] | null {
  const cleaned = parseHex(hex).replace(/^#/, "");
  const match = cleaned.match(/^([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i);
  if (!match) return null;

  return [
    parseInt(match[1], 16),
    parseInt(match[2], 16),
    parseInt(match[3], 16),
  ];
}

function rgbToHsl(r: number, g: number, b: number): [number, number, number] {
  r /= 255;
  g /= 255;
  b /= 255;

  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  const l = (max + min) / 2;

  if (max === min) {
    return [0, 0, Math.round(l * 100)];
  }

  const d = max - min;
  const s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

  let h = 0;
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

  return [Math.round(h * 360), Math.round(s * 100), Math.round(l * 100)];
}

function hexToHslString(hex: string): string | null {
  const rgb = hexToRgb(hex);
  if (!rgb) return null;
  const [h, s, l] = rgbToHsl(...rgb);
  return `${h} ${s}% ${l}%`;
}

function getContrastHsl(hex: string): string {
  const rgb = hexToRgb(hex);
  if (!rgb) return "0 0% 100%";

  const [r, g, b] = rgb.map((c) => {
    c /= 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  const luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

  return luminance > 0.4 ? "0 0% 9%" : "0 0% 98%";
}

// ══════════════════════════════════════════
// CSS VARIABLE INJECTION
// ══════════════════════════════════════════

function applyCssVariables(colors: Colors) {
  const root = document.documentElement;

  if (colors.primary) {
    const hsl = hexToHslString(colors.primary);
    if (hsl) {
      root.style.setProperty("--primary", hsl);
      root.style.setProperty(
        "--primary-foreground",
        getContrastHsl(colors.primary),
      );
    }
  }

  if (colors.secondary) {
    const hsl = hexToHslString(colors.secondary);
    if (hsl) {
      root.style.setProperty("--secondary", hsl);
      root.style.setProperty(
        "--secondary-foreground",
        getContrastHsl(colors.secondary),
      );
    }
  }
}

// ══════════════════════════════════════════
// PROVIDER
// ══════════════════════════════════════════

const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [colors, setColors] = useState<Colors>({});

  useNuiEvent<Colors>("setConfig", (data) => {
    const parsed: Colors = {
      primary: data.primary ? parseHex(data.primary) : undefined,
      secondary: data.secondary ? parseHex(data.secondary) : undefined,
    };

    setColors(parsed);
    applyCssVariables(parsed);
  });

  return (
    <ConfigContext.Provider value={{ colors }}>
      {children}
    </ConfigContext.Provider>
  );
};

export default ConfigProvider;
export const useConfig = () =>
  useContext<ConfigContextValue>(ConfigContext as Context<ConfigContextValue>);
