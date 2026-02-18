export interface AlertProps {
  title: string;
  description: string;
  size?: "sm" | "md" | "lg";
  cancel?: boolean;
  labels?: {
    cancel?: string;
    confirm?: string;
  };
  icon?: string;
  iconAnimation?: "spin" | "pulse" | "bounce" | "shake" | "none";
  iconColor?: string;
}
