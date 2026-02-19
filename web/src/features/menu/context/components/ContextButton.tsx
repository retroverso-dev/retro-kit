import { Button } from "@/components/ui/button";
import { DynamicIcon, type IconName } from "@/components/ui/dynamic-icon";
import { Progress } from "@/components/ui/progress";
import { ContextMenuProps, Option } from "@/typings/context";
import { fetchNui } from "@/utils/fetchNui";
import { ChevronRight } from "lucide-react";

interface ContextButtonProps {
  option: [string, Option];
}

const openMenu = (id: string | undefined) => {
  fetchNui<ContextMenuProps>("openContext", { id: id, back: false });
};

const clickContext = (id: string) => {
  fetchNui("clickContext", { id: id });
};

const ContextButton: React.FC<ContextButtonProps> = ({ option }) => {
  const button = option[1];
  const buttonKey = option[0];

  const renderMetadata = () => {
    if (!button.metadata) return null;

    // String array: ["Label 1", "Label 2"]
    if (Array.isArray(button.metadata)) {
      return (
        <div className="flex flex-col gap-1 w-full mt-1">
          {button.metadata.map((item, i) => {
            if (typeof item === "string") {
              return (
                <span
                  key={i}
                  className="text-xs text-muted-foreground text-left"
                >
                  {item}
                </span>
              );
            }

            // Array of { label, value, progress?, colorScheme? }
            const meta = item as {
              label: string;
              value: any;
              progress?: number;
              colorScheme?: string;
            };

            return (
              <div key={i} className="flex flex-col gap-0.5 w-full">
                <div className="flex items-center justify-between">
                  <span className="text-xs text-muted-foreground">
                    {meta.label}
                  </span>
                  {meta.progress === undefined && (
                    <span className="text-xs text-foreground font-medium">
                      {String(meta.value)}
                    </span>
                  )}
                </div>
                {meta.progress !== undefined && (
                  <Progress
                    value={meta.progress}
                    className="h-1.5"
                    indicatorStyle={{
                      backgroundColor: meta.colorScheme || undefined,
                    }}
                  />
                )}
              </div>
            );
          })}
        </div>
      );
    }

    // Object: { key: value }
    if (
      typeof button.metadata === "object" &&
      !Array.isArray(button.metadata)
    ) {
      return (
        <div className="flex flex-col gap-1 w-full mt-1">
          {Object.entries(button.metadata).map(([label, value]) => (
            <div key={label} className="flex items-center justify-between">
              <span className="text-xs text-muted-foreground">{label}</span>
              <span className="text-xs text-foreground font-medium">
                {String(value)}
              </span>
            </div>
          ))}
        </div>
      );
    }

    return null;
  };

  return (
    <Button
      className="w-full flex flex-col items-stretch h-auto gap-0 py-2 px-3"
      variant="outline"
      disabled={button.disabled}
      onClick={
        !button.disabled && !button.readOnly
          ? button.menu
            ? () => openMenu(button.menu)
            : () => clickContext(buttonKey)
          : undefined
      }
    >
      <div className="flex items-center gap-3 w-full">
        {/* Icon */}
        {button.icon && (
          <div className="shrink-0">
            <DynamicIcon
              name={button.icon as IconName}
              className="size-5"
              color={button.iconColor}
              animation={button.iconAnimation}
            />
          </div>
        )}

        {/* Image */}
        {button.image && !button.icon && (
          <img
            src={button.image}
            alt={button.title || ""}
            className="size-8 rounded-md object-cover shrink-0"
          />
        )}

        {/* Title + Description */}
        <div className="flex flex-col items-start flex-1 min-w-0">
          {button.title && (
            <span className="text-sm font-medium truncate w-full text-left">
              {button.title}
            </span>
          )}
          {button.description && (
            <span className="text-xs text-muted-foreground truncate w-full text-left">
              {button.description}
            </span>
          )}
        </div>

        {/* Arrow for submenu */}
        {button.arrow !== false && button.menu && (
          <ChevronRight className="size-4 shrink-0 text-muted-foreground" />
        )}
      </div>

      {/* Top-level progress */}
      {button.progress !== undefined && (
        <div className="w-full mt-2">
          <Progress
            value={button.progress}
            className="h-1.5"
            indicatorStyle={{
              backgroundColor: button.colorScheme || undefined,
            }}
          />
        </div>
      )}

      {/* Metadata */}
      {renderMetadata()}
    </Button>
  );
};

export default ContextButton;
