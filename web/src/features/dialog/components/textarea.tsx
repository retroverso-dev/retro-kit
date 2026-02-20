import { ITextarea } from "@/typings/dialog";
import { UseFormRegisterReturn } from "react-hook-form";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Textarea } from "@/components/ui/textarea";

interface Props {
  row: ITextarea;
  index: number;
  register: UseFormRegisterReturn;
}

const TextareaField: React.FC<Props> = ({ row, index, register }) => {
  return (
    <Field key={index}>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      <Textarea
        {...register}
        placeholder={row.placeholder}
        disabled={row.disabled}
        maxLength={row.max}
        className="resize-none"
        defaultValue={row.default}
      />
    </Field>
  );
};

export default TextareaField;
