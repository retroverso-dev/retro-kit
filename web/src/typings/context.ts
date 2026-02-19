export interface Option {
  menu?: string;
  title?: string;
  description?: string;
  arrow?: boolean;
  image?: string;
  icon?: string;
  iconColor?: string;
  iconAnimation?: "spin" | "pulse" | "bounce" | "shake" | "none";
  progress?: number;
  colorScheme?: string;
  readOnly?: boolean;
  metadata?:
    | string[]
    | { [key: string]: any }
    | { label: string; value: any; progress?: number; colorScheme?: string }[];
  disabled?: boolean;
  event?: string;
  serverEvent?: string;
  args?: any;
}

export interface Options {
  [key: string]: Option;
}

export interface ContextMenuProps {
  title: string;
  description?: string;
  menu?: string;
  canClose?: boolean;
  options: Options | Option[];
}
