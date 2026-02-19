import { Card, CardContent } from "@/components/ui/card";
import { Kbd, KbdGroup } from "@/components/ui/kbd";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { TextUiProps } from "@/typings/textui";
import { useState } from "react";

const TextUI: React.FC = () => {
  const [data, setData] = useState<TextUiProps>({
    position: "right-center",
  });
  const [visible, setVisible] = useState(false);

  useNuiEvent<TextUiProps>("textUi", (data) => {
    if (!data.position) data.position = "right-center";
    setData(data);
    setVisible(true);
  });

  useNuiEvent("textUiHide", () => setVisible(false));

  if (!visible) return null;

  return (
    <>
      <Card
        className={`max-w-87.5 min-w-87.5 absolute ${data.position == "right-center" ? "right-10 top-1/2 -translate-y-1/2" : data.position == "left-center" ? "left-10 top-1/2 -translate-y-1/2" : data.position == "top-center" ? "top-10 left-1/2 -translate-x-1/2" : "bottom-10 left-1/2 -translate-x-1/2"}`}
      >
        <CardContent className="flex flex-col gap-4">
          {Array.isArray(data.content) ? (
            data.content.map((content, index) => (
              <div key={index} className="flex gap-2 items-center">
                {content.uiKey ? (
                  <>
                    <KbdGroup>
                      <Kbd className="w-8 h-8 bg-primary font-medium text-primary-foreground text-md">
                        {content.uiKey}
                      </Kbd>
                    </KbdGroup>
                    <p className="text-lg font-normal">- {content.text}</p>
                  </>
                ) : (
                  <p className="text-lg font-normal">{content.text}</p>
                )}
              </div>
            ))
          ) : (
            <div className="flex gap-2 items-center">
              {data.content?.uiKey ? (
                <>
                  <KbdGroup>
                    <Kbd className="w-8 h-8 bg-primary font-medium text-primary-foreground text-md">
                      {data.content?.uiKey}
                    </Kbd>
                  </KbdGroup>
                  <p className="text-lg font-normal">- {data.content?.text}</p>
                </>
              ) : (
                <p className="text-lg font-normal">{data.content?.text}</p>
              )}
            </div>
          )}
        </CardContent>
      </Card>
    </>
  );
};

export default TextUI;
