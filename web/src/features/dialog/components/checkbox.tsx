import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { ICheckbox } from "@/typings/dialog";
import { UseFormRegisterReturn } from "react-hook-form";

interface Props {
  row: ICheckbox;
  index: number;
  register: UseFormRegisterReturn;
}

const CheckboxField: React.FC<Props> = ({ row, index, register }) => {
  const id = `test.${index}.value`;

  return (
    <div className="flex items-center gap-3 py-1">
      <Checkbox
        id={id}
        defaultChecked={row.checked}
        disabled={row.disabled}
        required={row.required}
        className="h-5 w-5 shrink-0"
        {...register}
      />
      <Label
        htmlFor={id}
        className="text-sm font-medium leading-none cursor-pointer select-none"
      >
        {row.label}
      </Label>
    </div>
  );
};

export default CheckboxField;
