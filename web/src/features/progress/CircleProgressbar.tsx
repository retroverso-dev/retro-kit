import { useNuiEvent } from "@/hooks/useNuiEvent";
import { fetchNui } from "@/utils/fetchNui";
import { CircleProgressbarProps } from "@/typings/progress";
import { useEffect, useMemo, useRef, useState } from "react";

const CircleProgressbar: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [label, setLabel] = useState("");
  const [percent, setPercent] = useState(0);
  const [usePercent, setUsePercent] = useState(false);
  const [position, setPosition] = useState<"top" | "middle" | "bottom">(
    "middle",
  );

  const intervalRef = useRef<number | null>(null);
  const hideTimeoutRef = useRef<number | null>(null);
  const cancelledRef = useRef(false);

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

  // Lua tells NUI to cancel — just hide, no callback
  useNuiEvent("progressCancel", () => {
    cancelledRef.current = true;
    clearProgressInterval();
    clearHideTimeout();
    setVisible(false);
  });

  // Lua tells NUI to start circle progress
  useNuiEvent<CircleProgressbarProps>("circleProgress", (data) => {
    clearProgressInterval();
    clearHideTimeout();
    cancelledRef.current = false;

    const total = data.duration || 0;
    setVisible(true);
    setLabel(data.label || "");
    setUsePercent(!!data.percent);
    setPercent(0);
    setPosition(data.position || "middle");

    let elapsed = 0;
    intervalRef.current = window.setInterval(() => {
      if (cancelledRef.current) {
        clearProgressInterval();
        return;
      }

      elapsed += 100;

      const nextPercent =
        total > 0 ? Math.min(Math.round((elapsed / total) * 100), 100) : 100;

      setPercent(nextPercent);

      if (elapsed >= total) {
        clearProgressInterval();
        hideTimeoutRef.current = window.setTimeout(() => {
          setVisible(false);
          fetchNui("progressComplete", {});
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

  const size = 96;
  const stroke = 8;
  const radius = (size - stroke) / 2;
  const circumference = useMemo(() => 2 * Math.PI * radius, [radius]);
  const dashOffset = circumference - (percent / 100) * circumference;

  const positionClass =
    position === "top"
      ? "top-1/8"
      : position === "middle"
        ? "top-1/2"
        : "bottom-8";

  return (
    <div
      className={`${visible ? "block" : "hidden"} absolute ${positionClass} left-1/2 -translate-x-1/2 ${position !== "bottom" ? "-translate-y-1/2" : ""}`}
    >
      <div className="flex flex-col items-center gap-2">
        <div className="rounded-full bg-background border border-border p-2 shadow-sm">
          <div className="relative" style={{ width: size, height: size }}>
            <svg width={size} height={size} className="-rotate-90">
              <circle
                cx={size / 2}
                cy={size / 2}
                r={radius}
                fill="none"
                stroke="rgba(255,255,255,0.18)"
                strokeWidth={stroke}
              />
              <circle
                cx={size / 2}
                cy={size / 2}
                r={radius}
                fill="none"
                stroke="var(--primary)"
                strokeWidth={stroke}
                strokeLinecap="round"
                strokeDasharray={circumference}
                strokeDashoffset={dashOffset}
                style={{ transition: "stroke-dashoffset 100ms linear" }}
              />
            </svg>

            <div className="absolute inset-0 flex items-center justify-center text-sm font-bold text-foreground">
              {usePercent ? `${percent}%` : null}
            </div>
          </div>
        </div>

        {label ? (
          <p className="text-center text-sm font-semibold text-foreground">
            {label}
          </p>
        ) : null}
      </div>
    </div>
  );
};

export default CircleProgressbar;
