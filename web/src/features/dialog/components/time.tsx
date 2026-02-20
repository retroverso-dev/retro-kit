import { Control, useController } from "react-hook-form";
import { ITimeInput } from "@/typings/dialog";
import { FormValues } from "../InputDialog";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";

interface Props {
  control: Control<FormValues>;
  row: ITimeInput;
  index: number;
}

const TimeField: React.FC<Props> = ({ control, row, index }) => {
  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    rules: { required: row.required },
  });

  return (
    <Field>
      <FieldLabel htmlFor="time-picker">{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      <Input
        type="time"
        id="time-picker"
        step="1"
        {...controller.field}
        defaultValue={row.default}
        className="bg-background appearance-none [&::-webkit-calendar-picker-indicator]:hidden [&::-webkit-calendar-picker-indicator]:appearance-none"
      />
    </Field>
  );
};

export default TimeField;
