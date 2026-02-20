import { useNuiEvent } from "./hooks/useNuiEvent";
import { fetchNui } from "./utils/fetchNui";
import { setClipboard } from "./utils/setClipboard";
import { isEnvBrowser } from "./utils/misc";
import Dev from "./features/dev";
import Notifications from "./features/notifications/NotificationWrapper";
import AlertDialogWrapper from "./features/dialog/AlertDialog";
import Progressbar from "./features/progress/Progressbar";
import CircleProgressbar from "./features/progress/CircleProgressbar";
import ContextMenu from "./features/menu/context/ContextMenu";
import TextUI from "./features/textui/TextUI";
import InputDialog from "./features/dialog/InputDialog";

function App() {
  useNuiEvent("setClipboard", (data: string) => {
    setClipboard(data);
  });

  fetchNui("init");

  return (
    <div className="m-auto container">
      <h1 className="text-4xl font-bold text-center">Retro Kit</h1>
      <Progressbar />
      <CircleProgressbar />
      <Notifications />
      <AlertDialogWrapper />
      <ContextMenu />
      <TextUI />
      <InputDialog />
      {isEnvBrowser() && <Dev />}
    </div>
  );
}

export default App;
