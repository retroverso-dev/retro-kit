export interface NotificationProps {
  style: "success" | "error" | "info" | "warning" | "default";
  title: string;
  description: string;
  duration?: number;
  showDuration?: boolean;
  icon?: string;
  iconAnimation?: "spin" | "pulse" | "bounce" | "shake" | "none";
  iconColor?: string;
  position:
    | "top-left"
    | "top-center"
    | "top-right"
    | "bottom-left"
    | "bottom-center"
    | "bottom-right";
}
