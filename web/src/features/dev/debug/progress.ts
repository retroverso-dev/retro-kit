import { debugData } from "@/utils/debugData";
import { ProgressbarProps, CircleProgressbarProps } from "@/typings/progress";

export const debugProgressbar = () => {
  debugData<ProgressbarProps>([
    {
      action: "progress",
      data: {
        label: "Using lockpick",
        duration: 5000,
        position: "top",
        percent: true,
      },
    },
  ]);
};

export const debugCircleProgressbar = () => {
  debugData<CircleProgressbarProps>([
    {
      action: "circleProgress",
      data: {
        label: "Using lockpick",
        duration: 5000,
        position: "bottom",
        percent: true,
      },
    },
  ]);
};
