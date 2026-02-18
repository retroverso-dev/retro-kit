import { useNuiEvent } from "@/hooks/useNuiEvent";
import { toast } from "sonner";
import type { NotificationProps } from "@/typings/notifications";
import { DynamicIcon } from "@/components/ui/dynamic-icon";
import { icons } from "lucide-react";
import { Progress } from "@/components/ui/progress";
import { useEffect, useState } from "react";

const STYLE_COLORS: Record<string, string> = {
  success: "#22c55e",
  error: "#ef4444",
  info: "#3b82f6",
  default: "#3b82f6",
  warning: "#eab308",
};

const STYLE_DEFAULT_ICONS: Record<string, keyof typeof icons> = {
  success: "CircleCheck",
  error: "OctagonX",
  info: "Info",
  default: "Info",
  warning: "TriangleAlert",
};

function getStyleColor(style: string): string {
  return STYLE_COLORS[style] ?? STYLE_COLORS.default;
}

function buildIcon(
  name: keyof typeof icons,
  className?: string,
  hexColor?: string,
  animation?: "spin" | "pulse" | "bounce" | "shake" | "none",
) {
  return (
    <DynamicIcon
      name={name}
      className={className}
      style={hexColor ? { color: hexColor } : undefined}
      animation={animation || "none"}
    />
  );
}

function resolveIcon(
  style: string,
  iconName?: string,
  className?: string,
  color?: string,
  animation?: "spin" | "pulse" | "bounce" | "shake" | "none",
) {
  // Custom icon name passed
  if (iconName && iconName in icons) {
    return buildIcon(
      iconName as keyof typeof icons,
      className,
      color,
      animation,
    );
  }

  // No custom icon — use the default icon for this style, with color + animation
  const defaultIcon = STYLE_DEFAULT_ICONS[style] ?? STYLE_DEFAULT_ICONS.default;
  return buildIcon(defaultIcon, className, color, animation);
}

const PROGRESS_INTERVAL = 50; // ms between progress updates

function ToastDescription({
  description,
  duration,
  showDuration,
  color,
}: {
  description: string;
  duration: number;
  showDuration: boolean;
  color: string;
}) {
  const [progress, setProgress] = useState(100);

  useEffect(() => {
    if (!showDuration) return;

    const startTime = Date.now();

    const interval = setInterval(() => {
      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, 100 - (elapsed / duration) * 100);
      setProgress(remaining);

      if (remaining <= 0) {
        clearInterval(interval);
      }
    }, PROGRESS_INTERVAL);

    return () => clearInterval(interval);
  }, [duration, showDuration]);

  return (
    <div className="flex flex-col gap-2 w-full">
      <span>{description}</span>
      {showDuration && (
        <Progress
          value={progress}
          className="h-1"
          indicatorStyle={{ backgroundColor: color }}
        />
      )}
    </div>
  );
}

const Notifications: React.FC = () => {
  useNuiEvent<NotificationProps>("notify", (data) => {
    const styleColor = getStyleColor(data.style);
    const iconColor = data.iconColor ?? styleColor;
    const progressColor = styleColor;

    const icon = resolveIcon(
      data.style,
      data.icon,
      "size-4",
      iconColor,
      data.iconAnimation,
    );
    const duration = data.duration ?? 5000;

    const description = data.showDuration ? (
      <ToastDescription
        description={data.description}
        duration={duration}
        showDuration={true}
        color={progressColor}
      />
    ) : (
      data.description
    );

    const options = {
      description,
      duration,
      position: data.position,
      icon,
    } as const;

    switch (data.style) {
      case "success":
        toast.success(data.title, options);
        break;
      case "error":
        toast.error(data.title, options);
        break;
      case "info":
        toast.info(data.title, options);
        break;
      case "warning":
        toast.warning(data.title, options);
        break;
      default:
        toast(data.title, options);
        break;
    }
  });

  return null;
};

export default Notifications;
