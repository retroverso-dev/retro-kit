import { Context, createContext, useContext, useState } from "react";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { debugData } from "@/utils/debugData";

debugData<Locale>([
  {
    action: "setLocale",
    data: {
      language: "English",
      ui: {
        cancel: "Cancel",
        close: "Close",
        confirm: "Confirm",
        inputPlaceholder: "Type here...",
      },
    },
  },
]);

interface Locale {
  language: string;
  ui: {
    cancel: string;
    confirm: string;
    close: string;
    inputPlaceholder: string;
  };
}

interface LocaleContextValue {
  locale: Locale;
  setLocale: (locale: Locale) => void;
}

const LocaleContext = createContext<LocaleContextValue | null>(null);

const LocaleProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [locale, setLocale] = useState<Locale>({
    language: "",
    ui: {
      cancel: "",
      close: "",
      confirm: "",
      inputPlaceholder: "",
    },
  });

  useNuiEvent("setLocale", async (data: Locale) => setLocale(data));
  return (
    <LocaleContext.Provider value={{ locale, setLocale }}>
      {children}
    </LocaleContext.Provider>
  );
};

export default LocaleProvider;

export const useLocales = () =>
  useContext<LocaleContextValue>(LocaleContext as Context<LocaleContextValue>);
