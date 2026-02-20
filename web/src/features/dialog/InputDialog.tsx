import { useState } from "react";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { FieldGroup } from "@/components/ui/field";
import { Separator } from "@/components/ui/separator";
import { InputProps, OptionValue } from "@/typings/dialog";
import { useNuiEvent } from "@/hooks/useNuiEvent";
import { useFieldArray, useForm } from "react-hook-form";
import { fetchNui } from "@/utils/fetchNui";
import dayjs from "dayjs";
import CheckboxField from "./components/checkbox";
import React from "react";
import InputField from "./components/input";
import SelectField from "./components/select";
import NumberField from "./components/number";
import SliderField from "./components/slider";
import ColorField from "./components/color";
import TimeField from "./components/time";
import DateField from "./components/date";
import TextareaField from "./components/textarea";

export type FormValues = {
  test: {
    value: any;
  }[];
};

// Add this helper at the top of the file, before the component
function parseDateLocal(value: unknown): Date | undefined {
  if (!value) return undefined;
  if (value === true) return new Date();
  if (value instanceof Date) return value;
  if (typeof value === "number" && !isNaN(value)) return new Date(value);
  if (typeof value === "string") {
    const parts = value.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (parts) {
      return new Date(Number(parts[1]), Number(parts[2]) - 1, Number(parts[3]));
    }
    const d = new Date(value);
    return isNaN(d.getTime()) ? undefined : d;
  }
  return undefined;
}

const InputDialog: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [fields, setFields] = useState<InputProps>({
    heading: "",
    description: "",
    rows: [{ type: "input", label: "" }],
  });

  const form = useForm<{ test: { value: any }[] }>({});
  const fieldForm = useFieldArray({
    control: form.control,
    name: "test",
  });

  useNuiEvent<InputProps>("openDialog", (data) => {
    setFields(data);
    setVisible(true);

    data.rows.forEach((row, index) => {
      let defaultValue: any = null;

      if (row.type === "checkbox") {
        defaultValue = row.checked ?? false;
      } else if (row.type === "date") {
        const d = parseDateLocal(row.default);
        defaultValue = d ? d.getTime() : undefined;
      } else if (row.type === "date-range") {
        if (row.default === true) {
          const now = new Date().getTime();
          defaultValue = [now, now];
        } else if (Array.isArray(row.default)) {
          const from = parseDateLocal(row.default[0]);
          const to = parseDateLocal(row.default[1]);
          defaultValue =
            from && to ? [from.getTime(), to.getTime()] : undefined;
        }
      } else if (row.type === "time") {
        defaultValue = row.default ?? "";
      } else {
        defaultValue = row.default ?? null;
      }

      fieldForm.insert(index, { value: defaultValue });

      if (row.type === "select" || row.type === "multi-select") {
        row.options = row.options.map((option) =>
          !option.label ? { ...option, label: option.value } : option,
        ) as Array<OptionValue>;
      }
    });
  });

  useNuiEvent("closeInputDialog", async () => await handleClose(true));

  const handleClose = async (dontPost?: boolean) => {
    setVisible(false);
    await new Promise((resolve) => setTimeout(resolve, 200));
    form.reset();
    fieldForm.remove();
    if (dontPost) return;
    fetchNui("inputData");
  };

  const onSubmit = form.handleSubmit(async (data) => {
    setVisible(false);

    const values: any[] = [];
    for (let i = 0; i < fields.rows.length; i++) {
      const row = fields.rows[i];

      if (
        (row.type === "date" || row.type === "date-range") &&
        row.returnString
      ) {
        if (!data.test[i]) continue;
        data.test[i].value = dayjs(data.test[i].value).format(
          row.format || "DD/MM/YYYY",
        );
      }
    }
    Object.values(data.test).forEach((obj: { value: any }) =>
      values.push(obj.value),
    );
    await new Promise((resolve) => setTimeout(resolve, 200));
    form.reset();
    fieldForm.remove();
    fetchNui("inputData", values);
  });

  return (
    <div className="flex items-center">
      <AlertDialog open={visible} onOpenChange={setVisible}>
        <form onSubmit={onSubmit}>
          <AlertDialogContent className="text-center">
            <AlertDialogHeader className="items-center text-center">
              <AlertDialogTitle>Input Dialog</AlertDialogTitle>
              <AlertDialogDescription>
                This is an example of an input dialog. You can customize this
              </AlertDialogDescription>
            </AlertDialogHeader>
            <Separator className="my-4" />
            <FieldGroup className="max-h-125 flex flex-col gap-8 overflow-y-auto custom-scrollbar pb-4 px-4">
              {fieldForm.fields.map((item, index) => {
                const row = fields.rows[index];

                return (
                  <React.Fragment key={item.id}>
                    {row.type === "input" && (
                      <InputField
                        row={row}
                        index={index}
                        register={form.register(`test.${index}.value`, {
                          required: row.required,
                        })}
                      />
                    )}
                    {row.type === "checkbox" && (
                      <CheckboxField
                        row={row}
                        index={index}
                        register={form.register(`test.${index}.value`, {
                          required: row.required,
                        })}
                      />
                    )}
                    {(row.type === "select" || row.type === "multi-select") && (
                      <SelectField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    )}
                    {row.type === "number" && (
                      <NumberField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    )}
                    {row.type === "slider" && (
                      <SliderField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    )}
                    {row.type === "color" && (
                      <ColorField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    )}
                    {row.type === "time" && (
                      <TimeField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    )}
                    {row.type === "date" || row.type === "date-range" ? (
                      <DateField
                        row={row}
                        index={index}
                        control={form.control}
                      />
                    ) : null}
                    {row.type === "textarea" && (
                      <TextareaField
                        row={row}
                        index={index}
                        register={form.register(`test.${index}.value`, {
                          required: row.required,
                        })}
                      />
                    )}
                  </React.Fragment>
                );
              })}
            </FieldGroup>
            <Separator className="my-4" />
            <AlertDialogFooter className="justify-center sm:justify-center gap-4">
              <AlertDialogCancel
                variant="outline"
                onClick={() => handleClose()}
                disabled={fields.options?.allowCancel === false}
              >
                Cancel
              </AlertDialogCancel>
              <AlertDialogAction
                variant="default"
                type="button"
                onClick={onSubmit}
              >
                Confirm
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </form>
      </AlertDialog>
    </div>
  );
};

export default InputDialog;
