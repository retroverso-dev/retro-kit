import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { TooltipProvider } from "./components/ui/tooltip";
import { Toaster } from "@/components/ui/sonner";
import LocaleProvider from "./providers/LocaleProvider.tsx";

// Force dark mode for NUI
document.documentElement.classList.add("dark");

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <LocaleProvider>
      <TooltipProvider>
        <App />
        <Toaster />
      </TooltipProvider>
    </LocaleProvider>
  </StrictMode>,
);
