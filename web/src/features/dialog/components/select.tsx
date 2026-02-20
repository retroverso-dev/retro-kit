import { ISelect } from "@/typings/dialog";
import { Control, useController } from "react-hook-form";
import { FormValues } from "../InputDialog";
import { Field, FieldLabel, FieldDescription } from "@/components/ui/field";
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from "@/components/ui/select";
import { MultiSelect } from "@/components/ui/multi-select";
import React from "react";

interface Props {
  row: ISelect;
  index: number;
  control: Control<FormValues>;
}

const SelectField: React.FC<Props> = ({ row, index, control }) => {
  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    rules: { required: row.required },
    defaultValue: row.type === "multi-select" ? [] : "",
  });

  return (
    <Field key={index}>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}

      {row.type === "select" && (
        <Select
          value={controller.field.value ?? ""}
          onValueChange={(val) => controller.field.onChange(val)}
        >
          <SelectTrigger className="w-full">
            <SelectValue placeholder={row.placeholder} />
          </SelectTrigger>
          <SelectContent>
            {row.options.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label || option.value}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      )}

      {row.type === "multi-select" && (
        <MultiSelect
          options={row.options.map((o) => ({
            value: o.value,
            label: o.label || o.value,
          }))}
          value={controller.field.value ?? []}
          onValueChange={(val) => controller.field.onChange(val)}
          placeholder={row.placeholder}
        />
      )}
    </Field>
  );
};

export default SelectField;
