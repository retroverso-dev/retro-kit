import { icons } from "lucide-react";
import { cn } from "@/lib/utils";
import type { ComponentType, CSSProperties } from "react";

export type IconName = keyof typeof icons;

const ANIMATION_CLASSES: Record<string, string> = {
  spin: "animate-spin",
  pulse: "animate-pulse",
  bounce: "animate-bounce",
  shake: "animate-shake",
};

interface Props {
  name: IconName;
  className?: string;
  style?: CSSProperties;
  color?: string;
  animation?: "spin" | "pulse" | "bounce" | "shake" | "none";
}

export function DynamicIcon({
  name,
  className,
  style,
  color,
  animation,
}: Props) {
  const Icon = icons[name] as ComponentType<{
    className?: string;
    style?: CSSProperties;
  }>;

  if (!Icon) {
    return null;
  }

  const animationClass =
    animation && animation !== "none"
      ? (ANIMATION_CLASSES[animation] ?? "")
      : "";

  return (
    <Icon className={cn(className, animationClass, color)} style={style} />
  );
}
