import * as React from "react";
import { CheckIcon, ChevronDownIcon, X } from "lucide-react";
import { cn } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";

interface MultiSelectOption {
  value: string;
  label: string;
}

interface MultiSelectProps {
  options: MultiSelectOption[];
  value: string[];
  onValueChange: (value: string[]) => void;
  placeholder?: string;
  className?: string;
  disabled?: boolean;
}

function MultiSelect({
  options,
  value,
  onValueChange,
  placeholder = "Select...",
  className,
  disabled,
}: MultiSelectProps) {
  const [open, setOpen] = React.useState(false);
  const containerRef = React.useRef<HTMLDivElement>(null);

  const handleToggle = (optionValue: string) => {
    if (value.includes(optionValue)) {
      onValueChange(value.filter((v) => v !== optionValue));
    } else {
      onValueChange([...value, optionValue]);
    }
  };

  const handleRemove = (
    e: React.MouseEvent | React.KeyboardEvent,
    optionValue: string,
  ) => {
    e.stopPropagation();
    e.preventDefault();
    onValueChange(value.filter((v) => v !== optionValue));
  };

  // Close on click outside
  React.useEffect(() => {
    if (!open) return;

    const handleClickOutside = (e: MouseEvent) => {
      if (
        containerRef.current &&
        !containerRef.current.contains(e.target as Node)
      ) {
        setOpen(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [open]);

  const selectedLabels = value
    .map((v) => options.find((o) => o.value === v))
    .filter(Boolean) as MultiSelectOption[];

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        role="combobox"
        aria-expanded={open}
        disabled={disabled}
        onClick={() => setOpen((prev) => !prev)}
        className={cn(
          "border-input data-[placeholder]:text-muted-foreground [&_svg:not([class*='text-'])]:text-muted-foreground focus-visible:border-ring focus-visible:ring-ring/50 dark:bg-input/30 dark:hover:bg-input/50 flex min-h-9 w-full items-center justify-between gap-2 rounded-md border bg-transparent px-3 py-1.5 text-sm shadow-xs transition-[color,box-shadow] outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed disabled:opacity-50",
          className,
        )}
      >
        <div className="flex flex-1 flex-wrap items-center gap-1">
          {selectedLabels.length === 0 && (
            <span className="text-muted-foreground">{placeholder}</span>
          )}
          {selectedLabels.map((option) => (
            <Badge
              key={option.value}
              variant="secondary"
              className="gap-1 px-1.5 py-0 text-xs"
            >
              {option.label}
              <span
                role="button"
                tabIndex={0}
                className="hover:text-foreground cursor-pointer rounded-sm opacity-70 hover:opacity-100"
                onMouseDown={(e) => handleRemove(e, option.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") {
                    handleRemove(e, option.value);
                  }
                }}
              >
                <X className="size-3" />
              </span>
            </Badge>
          ))}
        </div>
        <ChevronDownIcon
          className={cn(
            "size-4 shrink-0 opacity-50 transition-transform",
            open && "rotate-180",
          )}
        />
      </button>

      {open && (
        <div className="bg-popover text-popover-foreground absolute z-50 mt-1 w-full overflow-hidden rounded-md border shadow-md animate-in fade-in-0 zoom-in-95">
          <div className="max-h-60 overflow-y-auto p-1">
            {options.map((option) => {
              const isSelected = value.includes(option.value);
              return (
                <button
                  key={option.value}
                  type="button"
                  className={cn(
                    "relative flex w-full cursor-default items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm outline-hidden select-none hover:bg-accent hover:text-accent-foreground",
                    isSelected && "bg-accent/50",
                  )}
                  onMouseDown={(e) => {
                    e.preventDefault();
                    handleToggle(option.value);
                  }}
                >
                  <span className="absolute right-2 flex size-3.5 items-center justify-center">
                    {isSelected && <CheckIcon className="size-4" />}
                  </span>
                  {option.label}
                </button>
              );
            })}
            {options.length === 0 && (
              <div className="text-muted-foreground py-6 text-center text-sm">
                No options found.
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export { MultiSelect, type MultiSelectOption, type MultiSelectProps };
