import { ContextMenuProps } from "@/typings/context";
import { debugData } from "@/utils/debugData";

export const debugContext = () => {
  debugData<ContextMenuProps>([
    {
      action: "showContext",
      data: {
        title: "Vehicle Status",
        description: "Check your vehicle's status and manage it.",
        canClose: true,
        options: [
          { title: "Empty button", description: "This option has no action." },
          {
            title: "Engine Health",
            description: "Current engine health: 75%",
            metadata: [{ label: "Health", value: "75%" }],
            progress: 75,
            icon: "Heart",
            iconColor: "#ff4d4d",
            iconAnimation: "pulse",
          },
          {
            title: "Fuel Level",
            description: "Current fuel level: 40%",
            metadata: [{ label: "Fuel", value: "40%" }],
            progress: 40,
            icon: "Fuel",
            iconColor: "yellow",
            iconAnimation: "pulse",
          },
          {
            title: "Open Submenu",
            description: "This option opens a submenu.",
            metadata: [{ label: "Submenu", value: "Open" }],
            icon: "ChevronRight",
            iconColor: "#4d94ff",
            iconAnimation: "pulse",
          },
          {
            title: "Disabled Option",
            description: "This option is disabled and cannot be selected.",
            disabled: true,
          },
          {
            title: "Read-Only Option",
            description:
              "This option is read-only and cannot be interacted with.",
            readOnly: true,
          },
          {
            title: "Option with Array Metadata",
            description: "This option has an array of metadata.",
            metadata: ["Metadata Item 1", "Metadata Item 2", "Metadata Item 3"],
          },
          {
            title: "Option with Object Metadata",
            description: "This option has an object as metadata.",
            metadata: { label: "Object Metadata", value: "Value" },
          },
          {
            title: "Option with Detailed Object Metadata",
            description:
              "This option has an array of detailed metadata objects.",
            metadata: [
              { label: "Detail 1", value: "Value 1" },
              { label: "Detail 2", value: "Value 2" },
              { label: "Detail 3", value: "Value 3" },
            ],
          },
          {
            title: "Option with Progress",
            description: "This option shows a progress bar.",
            progress: 60,
            colorScheme: "blue",
          },
          {
            title: "Option with Icon",
            description: "This option has an icon.",
            icon: "Star",
            iconColor: "gold",
            iconAnimation: "spin",
          },
          {
            title: "Option with Submenu",
            description: "This option opens another submenu.",
            menu: "submenu1",
          },
        ],
      },
    },
  ]);
};
