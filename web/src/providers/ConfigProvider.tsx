import React, {
  Context,
  createContext,
  useContext,
  useRef,
  useState,
} from "react";
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

  if (cleaned.length === 8 && /^[a-f\d]{8}$/i.test(cleaned)) {
    cleaned = cleaned.substring(2);
  }

  if (cleaned.length === 3) {
    cleaned = cleaned
      .split("")
      .map((c) => c + c)
      .join("");
  }

  return "#" + cleaned.toLowerCase();
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

function hexToRgba(hex: string): string | null {
  const rgb = hexToRgb(hex);
  if (!rgb) return null;
  return `rgba(${rgb[0]}, ${rgb[1]}, ${rgb[2]}, 1)`;
}

function getContrastRgba(hex: string): string {
  const rgb = hexToRgb(hex);
  if (!rgb) return "rgba(255, 255, 255, 1)";

  const [r, g, b] = rgb.map((c) => {
    c /= 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  const luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

  return luminance > 0.4 ? "rgba(9, 9, 11, 1)" : "rgba(255, 255, 255, 1)";
}

// ══════════════════════════════════════════
// CSS INJECTION VIA <style> TAG
// ══════════════════════════════════════════

const STYLE_ID = "retro-kit-config-colors";

function applyCssVariables(colors: Colors) {
  let existing = document.getElementById(STYLE_ID);

  if (!existing) {
    existing = document.createElement("style");
    existing.id = STYLE_ID;
    document.head.appendChild(existing);
  }

  const vars: string[] = [];

  if (colors.primary) {
    const hex = parseHex(colors.primary);
    const rgba = hexToRgba(hex);
    const fg = getContrastRgba(hex);
    if (rgba) {
      vars.push(`--primary: ${rgba}`);
      vars.push(`--primary-foreground: ${fg}`);
      vars.push(`--ring: ${rgba}`);
    }
  }

  if (colors.secondary) {
    const hex = parseHex(colors.secondary);
    const rgba = hexToRgba(hex);
    const fg = getContrastRgba(hex);
    if (rgba) {
      vars.push(`--secondary: ${rgba}`);
      vars.push(`--secondary-foreground: ${fg}`);
    }
  }

  if (vars.length === 0) return;

  const declarations = vars.map((v) => `  ${v} !important;`).join("\n");

  existing.textContent = `
:root,
:root.dark,
.dark {
${declarations}
}
`;
}

// ══════════════════════════════════════════
// PROVIDER
// ══════════════════════════════════════════

const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [colors, setColors] = useState<Colors>({});
  const applied = useRef(false);

  useNuiEvent<Colors>("setConfig", (data) => {
    if (!data) return;

    const parsed: Colors = {};

    if (data.primary) {
      parsed.primary = parseHex(data.primary);
    }

    if (data.secondary) {
      parsed.secondary = parseHex(data.secondary);
    }

    if (!parsed.primary && !parsed.secondary) return;

    setColors(parsed);
    applyCssVariables(parsed);
    applied.current = true;
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
