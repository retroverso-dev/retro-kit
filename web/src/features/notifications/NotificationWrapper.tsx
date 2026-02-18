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
  if (iconName && iconName in icons) {
    return buildIcon(
      iconName as keyof typeof icons,
      className,
      color,
      animation,
    );
  }

  const defaultIcon = STYLE_DEFAULT_ICONS[style] ?? STYLE_DEFAULT_ICONS.default;
  return buildIcon(defaultIcon, className, color, animation);
}

const PROGRESS_INTERVAL = 50;

function DurationToast({
  title,
  description,
  duration,
  icon,
  progressColor,
}: {
  title: string;
  description: string;
  duration: number;
  icon: React.ReactNode;
  progressColor: string;
}) {
  const [progress, setProgress] = useState(100);

  useEffect(() => {
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
  }, [duration]);

  return (
    <div
      className="flex flex-col gap-3 w-89 rounded-lg border border-border p-3 shadow-lg"
      style={{ background: "rgba(0, 0, 0, 0.7)" }}
    >
      <div className="flex items-start gap-3">
        <div className="mt-0.5 shrink-0">{icon}</div>
        <div className="flex flex-col gap-0.5">
          <p className="text-sm font-semibold text-foreground">{title}</p>
          <p className="text-sm text-muted-foreground">{description}</p>
        </div>
      </div>
      <Progress
        value={progress}
        className="h-1"
        indicatorStyle={{ backgroundColor: progressColor }}
      />
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

    // Use custom toast when showDuration is true for full-width progress
    if (data.showDuration) {
      toast.custom(
        () => (
          <DurationToast
            title={data.title}
            description={data.description}
            duration={duration}
            icon={icon}
            progressColor={progressColor}
          />
        ),
        {
          duration,
          position: data.position,
          unstyled: true,
        },
      );
      return;
    }

    const options = {
      description: data.description,
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
