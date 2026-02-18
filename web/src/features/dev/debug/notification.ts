import { debugData } from "@/utils/debugData";
import type { NotificationProps } from "@/typings/notifications";

export const debugNotify = () => {
  debugData<NotificationProps>([
    {
      action: "notify",
      data: {
        style: "success",
        title: "Debug Notification",
        description:
          "This is a debug notification triggered from the dev tools.",
        position: "top-left",
        icon: "Bell",
        duration: 10000,
        showDuration: true,
        iconAnimation: "bounce",
      },
    },
    {
      action: "notify",
      data: {
        style: "error",
        title: "Debug Error Notification",
        description:
          "This is a debug error notification triggered from the dev tools.",
        position: "top-center",
        icon: "Bell",
        iconAnimation: "shake",
        showDuration: true,
      },
    },
    {
      action: "notify",
      data: {
        style: "info",
        title: "Debug Info Notification",
        description:
          "This is a debug info notification triggered from the dev tools.",
        position: "top-right",
        icon: "Bell",
        iconAnimation: "spin",
        duration: 5000,
        showDuration: true,
      },
    },
    {
      action: "notify",
      data: {
        style: "warning",
        title: "Debug Warning Notification",
        description:
          "This is a debug warning notification triggered from the dev tools.",
        position: "bottom-center",
        icon: "Bell",
        iconAnimation: "pulse",
        showDuration: true,
      },
    },
    {
      action: "notify",
      data: {
        style: "default",
        title: "Debug Default Notification",
        description:
          "This is a debug default notification triggered from the dev tools.",
        position: "bottom-right",
        icon: "Bell",
        iconAnimation: "none",
      },
    },
  ]);
};
