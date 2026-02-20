import { Slider } from "@/components/ui/slider";
import { ISlider } from "@/typings/dialog";
import { Control, useController } from "react-hook-form";
import { FormValues } from "../InputDialog";
import { Field, FieldLabel } from "@/components/ui/field";

interface Props {
  row: ISlider;
  index: number;
  control: Control<FormValues>;
}

const SliderField: React.FC<Props> = ({ row, index, control }) => {
  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    defaultValue: row.default ?? row.min ?? 0,
  });

  const currentValue = Number(controller.field.value) || 0;
  const min = row.min ?? 0;
  const max = row.max ?? 100;
  const step = row.step ?? 1;

  return (
    <Field key={index}>
      <div className="flex items-center justify-between">
        <FieldLabel>{row.label}</FieldLabel>
        <span className="text-muted-foreground text-sm tabular-nums">
          {currentValue}
          <span className="text-muted-foreground/50">/{max}</span>
        </span>
      </div>
      <Slider
        value={[currentValue]}
        onValueChange={(val) => controller.field.onChange(val[0])}
        min={min}
        max={max}
        step={step}
        disabled={row.disabled}
      />
    </Field>
  );
};

export default SliderField;
