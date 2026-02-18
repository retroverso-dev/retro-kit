import { debugData } from "@/utils/debugData";
import type { AlertProps } from "@/typings/alert";

export const debugAlert = () => {
  debugData<AlertProps>([
    {
      action: "sendAlert",

      data: {
        title: "Debug Alert",
        icon: "Bell",
        iconAnimation: "bounce",
        iconColor: "text-yellow-500",
        description:
          "This is a debug alert dialog triggered from the dev tools. This is a debug alert dialog triggered from the dev tools.",
        size: "lg",
        cancel: true,
        labels: {
          cancel: "Dismiss",
          confirm: "Confirm",
        },
      },
    },
  ]);
};
