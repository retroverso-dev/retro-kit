import { Button } from "@/components/ui/button";
import { DynamicIcon } from "@/components/ui/dynamic-icon";
import {
  Drawer,
  DrawerClose,
  DrawerContent,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerTitle,
  DrawerTrigger,
} from "@/components/ui/drawer";
import { debugAlert } from "./debug/alert";
import { debugNotify } from "./debug/notification";
import { debugProgressbar, debugCircleProgressbar } from "./debug/progress";
import { debugContext } from "./debug/context";
import { debugTextUi } from "./debug/textui";
import { debugInput } from "./debug/dialog";

const Dev: React.FC = () => {
  return (
    <div className="flex flex-col items-center justify-center">
      <Drawer direction="left">
        <DrawerTrigger asChild>
          <Button
            className="rounded-full absolute bottom-10 right-10 h-auto w-auto aspect-square p-2"
            variant="destructive"
          >
            <DynamicIcon name="Settings" className="size-5" />
          </Button>
        </DrawerTrigger>

        <DrawerContent>
          <DrawerHeader>
            <DrawerTitle>Dev Tools</DrawerTitle>
            <DrawerDescription>
              Tools and utilities for development and debugging.
            </DrawerDescription>
          </DrawerHeader>
          <div className="p-4">
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugNotify}
            >
              Test Notify
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugAlert}
            >
              Test Alert Dialog
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugProgressbar}
            >
              Test Progressbar
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugCircleProgressbar}
            >
              Test Circle Progressbar
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugContext}
            >
              Test Context Menu
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugTextUi}
            >
              Test Text UI
            </Button>
            <Button
              variant="outline"
              className="mb-2 w-full"
              onClick={debugInput}
            >
              Test Input Dialog
            </Button>
          </div>
          <DrawerFooter>
            <DrawerClose asChild>
              <Button variant="outline">Close</Button>
            </DrawerClose>
          </DrawerFooter>
        </DrawerContent>
      </Drawer>
    </div>
  );
};

export default Dev;
