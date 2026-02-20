import { INumber } from "@/typings/dialog";
import { Control, useController } from "react-hook-form";
import { FormValues } from "../InputDialog";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Minus, Plus } from "lucide-react";

interface Props {
  row: INumber;
  index: number;
  control: Control<FormValues>;
}

const NumberField: React.FC<Props> = ({ row, index, control }) => {
  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    defaultValue: row.default ?? 0,
    rules: {
      required: row.required,
      min: row.min,
      max: row.max,
    },
  });

  const currentValue = Number(controller.field.value) || 0;
  const step = row.step ?? 1;

  const clamp = (val: number) => {
    let clamped = val;
    if (row.min !== undefined) clamped = Math.max(row.min, clamped);
    if (row.max !== undefined) clamped = Math.min(row.max, clamped);
    return clamped;
  };

  const increment = () => {
    controller.field.onChange(clamp(currentValue + step));
  };

  const decrement = () => {
    controller.field.onChange(clamp(currentValue - step));
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const raw = e.target.value;

    // Allow empty field while typing
    if (raw === "" || raw === "-") {
      controller.field.onChange(raw);
      return;
    }

    const parsed = Number(raw);
    if (!isNaN(parsed)) {
      controller.field.onChange(clamp(parsed));
    }
  };

  const handleBlur = () => {
    const parsed = Number(controller.field.value);
    if (
      isNaN(parsed) ||
      controller.field.value === "" ||
      controller.field.value === "-"
    ) {
      controller.field.onChange(row.default ?? row.min ?? 0);
    } else {
      controller.field.onChange(clamp(parsed));
    }
    controller.field.onBlur();
  };

  return (
    <Field key={index}>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      <div className="relative flex items-center">
        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="absolute left-0 h-full w-9 rounded-r-none border-r border-input hover:bg-accent"
          onClick={decrement}
          disabled={
            row.disabled || (row.min !== undefined && currentValue <= row.min)
          }
          tabIndex={-1}
        >
          <Minus className="size-3.5" />
        </Button>
        <Input
          type="text"
          inputMode="numeric"
          className="px-10 text-center [appearance:textfield] [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none"
          value={controller.field.value}
          onChange={handleInputChange}
          onBlur={handleBlur}
          disabled={row.disabled}
          placeholder={row.placeholder}
        />
        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="absolute right-0 h-full w-9 rounded-l-none border-l border-input hover:bg-accent"
          onClick={increment}
          disabled={
            row.disabled || (row.max !== undefined && currentValue >= row.max)
          }
          tabIndex={-1}
        >
          <Plus className="size-3.5" />
        </Button>
      </div>
    </Field>
  );
};

export default NumberField;
