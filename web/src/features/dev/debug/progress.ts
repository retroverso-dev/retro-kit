import { debugData } from "@/utils/debugData";
import type {
  ProgressbarProps,
  CircleProgressbarProps,
} from "@/typings/progress";

export const debugProgressbar = () => {
  debugData<ProgressbarProps>([
    {
      action: "progress",
      data: {
        label: "Loading...",
        duration: 5000,
        position: "bottom",
        percent: true,
        canCancel: true,
      },
    },
  ]);
};

export const debugCircleProgressbar = () => {
  debugData<CircleProgressbarProps>([
    {
      action: "circleProgress",
      data: {
        label: "Processing...",
        duration: 5000,
        position: "middle",
        percent: true,
        canCancel: true,
      },
    },
  ]);
};
