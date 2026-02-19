export type TextUiPosition =
  | "right-center"
  | "left-center"
  | "top-center"
  | "bottom-center";

export type TextUiContent = {
  text?: string;
  uiKey?: string;
};

export interface TextUiProps {
  position?: TextUiPosition;
  content?: TextUiContent | TextUiContent[];
}
