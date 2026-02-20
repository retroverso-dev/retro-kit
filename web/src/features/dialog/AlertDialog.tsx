import { useState } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import type { AlertProps } from "@/typings/alert";
import {
  AlertDialog,
  AlertDialogContent,
  AlertDialogHeader,
  AlertDialogMedia,
  AlertDialogTitle,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogCancel,
  AlertDialogAction,
} from "@/components/ui/alert-dialog";
import { DynamicIcon } from "@/components/ui/dynamic-icon";
import { fetchNui } from "@/utils/fetchNui";
import { useLocales } from "@/providers/LocaleProvider";

const AlertDialogWrapper = () => {
  const { locale } = useLocales();
  const [opened, setOpened] = useState(false);
  const [dialogData, setDialogData] = useState<AlertProps>({
    title: "",
    description: "",
    icon: undefined,
    iconAnimation: undefined,
    iconColor: undefined,
    cancel: false,
    labels: {
      cancel: "Cancel",
      confirm: "OK",
    },
  });

  const closeAlert = (button: string) => {
    setOpened(false);
    fetchNui("closeAlert", button);
  };

  useNuiEvent("sendAlert", (data: AlertProps) => {
    setDialogData(data);
    setOpened(true);
  });

  useNuiEvent("closeAlertDialog", () => {
    setOpened(false);
  });
  return (
    <div className="flex items-center">
      <AlertDialog open={opened} onOpenChange={setOpened}>
        <AlertDialogContent className="text-center" size="sm">
          <AlertDialogHeader className="items-center text-center">
            {dialogData.icon && (
              <AlertDialogMedia>
                <DynamicIcon
                  // eslint-disable-next-line @typescript-eslint/no-explicit-any
                  name={dialogData.icon as any}
                  color={dialogData.iconColor}
                  animation={dialogData.iconAnimation}
                />
              </AlertDialogMedia>
            )}
            <AlertDialogTitle>{dialogData.title}</AlertDialogTitle>
            <AlertDialogDescription>
              {dialogData.description}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter className="justify-center sm:justify-center">
            {dialogData.cancel && (
              <AlertDialogCancel
                variant="outline"
                size={undefined}
                onClick={() => closeAlert("cancel")}
              >
                {dialogData.labels?.cancel || locale.ui.cancel}
              </AlertDialogCancel>
            )}
            <AlertDialogAction
              size={undefined}
              variant={undefined}
              onClick={() => closeAlert("confirm")}
            >
              {dialogData.labels?.confirm || locale.ui.confirm}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
};

export default AlertDialogWrapper;
