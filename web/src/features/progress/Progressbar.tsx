import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Separator } from "@/components/ui/separator";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { ProgressbarProps } from "@/typings/progress";
import { useEffect, useRef, useState } from "react";

const Progressbar: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [label, setLabel] = useState("");
  const [percent, setPercent] = useState(0);
  const [usePercent, setUsePercent] = useState(false);
  const [position, setPosition] = useState<"top" | "middle" | "bottom">(
    "middle",
  );

  const intervalRef = useRef<number | null>(null);
  const hideTimeoutRef = useRef<number | null>(null);

  const clearProgressInterval = () => {
    if (intervalRef.current !== null) {
      window.clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
  };

  const clearHideTimeout = () => {
    if (hideTimeoutRef.current !== null) {
      window.clearTimeout(hideTimeoutRef.current);
      hideTimeoutRef.current = null;
    }
  };

  useNuiEvent("progressCancel", () => {
    clearProgressInterval();
    clearHideTimeout();
    setVisible(false);
  });

  useNuiEvent<ProgressbarProps>("progress", (data) => {
    clearProgressInterval();
    clearHideTimeout();

    const total = data.duration || 0;
    setVisible(true);
    setLabel(data.label || "");
    setUsePercent(!!data.percent);
    setPercent(0);
    setPosition(data.position || "middle");

    let elapsed = 0;
    intervalRef.current = window.setInterval(() => {
      elapsed += 100;

      const nextPercent =
        total > 0 ? Math.min(Math.round((elapsed / total) * 100), 100) : 100;

      setPercent(nextPercent);

      if (elapsed >= total) {
        clearProgressInterval();
        hideTimeoutRef.current = window.setTimeout(() => {
          setVisible(false);
        }, 150);
      }
    }, 100);
  });

  useEffect(() => {
    return () => {
      clearProgressInterval();
      clearHideTimeout();
    };
  }, []);

  return (
    <div className={visible ? "block" : "hidden"}>
      <Card
        className={`w-100 absolute ${position === "top" ? "top-1/8" : position === "middle" ? "top-1/2" : "bottom-1"} left-1/2 -translate-x-1/2 -translate-y-1/2`}
      >
        <CardHeader>
          <CardTitle className="text-center">{label}</CardTitle>
        </CardHeader>
        <Separator />
        <CardFooter>
          <Progress value={percent} className="h-2 w-full" />
          {usePercent && <p className="px-2 text-sm font-bold">{percent}%</p>}
        </CardFooter>
      </Card>
    </div>
  );
};

export default Progressbar;
