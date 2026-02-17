import { useNuiEvent } from "./hooks/useNuiEvent";
import { fetchNui } from "./utils/fetchNui";
import { setClipboard } from "./utils/setClipboard";
import { isEnvBrowser } from "./utils/misc";
import Dev from "./features/dev";

function App() {
  useNuiEvent("setClipboard", (data: string) => {
    setClipboard(data);
  });

  fetchNui("init");

  return (
    <div className="m-auto container">
      <h1 className="text-4xl font-bold text-center">Retro Kit</h1>
      {isEnvBrowser() && <Dev />}
    </div>
  );
}

export default App;
