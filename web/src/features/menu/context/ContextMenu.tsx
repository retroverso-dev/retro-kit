import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DynamicIcon } from "@/components/ui/dynamic-icon";
import ContextButton from "./components/ContextButton";
import { fetchNui } from "@/utils/fetchNui";
import { ContextMenuProps } from "@/typings/context";
import { useEffect, useState } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";

const openMenu = (id: string | undefined) => {
  fetchNui<ContextMenuProps>("openContext", { id: id, back: true });
};

const ContextMenu: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [contextMenu, setContextMenu] = useState<ContextMenuProps>({
    title: "",
    options: { "": { description: "", metadata: [] } },
  });

  const closeContext = () => {
    if (contextMenu.canClose === false) return;
    setVisible(false);
    fetchNui("closeContext");
  };

  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (["Escape"].includes(e.code)) closeContext();
    };

    window.addEventListener("keydown", keyHandler);

    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible]);

  useNuiEvent("hideContext", () => setVisible(false));

  useNuiEvent<ContextMenuProps>("showContext", async (data) => {
    if (visible) {
      setVisible(false);
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    setContextMenu(data);
    setVisible(true);
  });

  return (
    <Card
      className={`${visible ? "fixed" : "hidden"} bg-background w-100 absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2`}
    >
      <CardHeader>
        <div className="flex flex-row columns-3 gap-4 w-full items-center justify-between">
          <Button
            size="icon"
            variant="outline"
            onClick={() => openMenu(contextMenu.menu)}
          >
            <DynamicIcon name="ChevronLeft" />
          </Button>
          <div>
            <CardTitle>{contextMenu.title}</CardTitle>
          </div>
          {contextMenu.canClose && (
            <Button size="icon" onClick={closeContext}>
              <DynamicIcon name="X" />
            </Button>
          )}
        </div>
        <CardDescription>{contextMenu.description}</CardDescription>
      </CardHeader>
      <CardContent className="max-h-125 flex flex-col gap-2 overflow-y-auto custom-scrollbar">
        {Object.entries(contextMenu.options).map((option, index) => (
          <ContextButton key={index} option={option} />
        ))}
      </CardContent>
    </Card>
  );
};

export default ContextMenu;
