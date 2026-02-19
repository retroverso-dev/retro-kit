import { TextUiProps } from "@/typings/textui";
import { debugData } from "@/utils/debugData";

export const debugTextUi = () => {
  debugData<TextUiProps>([
    {
      action: "textUi",
      data: {
        position: "right-center",
        content: [
          {
            text: "Open the door",
            uiKey: "E",
          },
          {
            text: "Pick up the item",
            uiKey: "F",
          },
          {
            text: 'Use "/emote" to dance',
          },
        ],
      },
    },
  ]);
};
