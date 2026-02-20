import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { IInput } from "@/typings/dialog";
import { UseFormRegisterReturn } from "react-hook-form";
import { Eye, EyeOff } from "lucide-react";
import { useState } from "react";

interface Props {
  register: UseFormRegisterReturn;
  row: IInput;
  index: number;
}

const InputField: React.FC<Props> = ({ register, row, index }) => {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <Field key={index}>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      <div className="relative">
        <Input
          type={row.password && !showPassword ? "password" : "text"}
          placeholder={row.placeholder}
          defaultValue={row.default}
          disabled={row.disabled}
          className={row.password ? "pr-10" : ""}
          {...register}
        />
        {row.password && (
          <Button
            type="button"
            variant="ghost"
            size="icon"
            className="absolute right-0 top-0 h-full px-3 hover:bg-transparent"
            onClick={() => setShowPassword((prev) => !prev)}
            tabIndex={-1}
          >
            {showPassword ? (
              <EyeOff className="h-4 w-4 text-muted-foreground" />
            ) : (
              <Eye className="h-4 w-4 text-muted-foreground" />
            )}
          </Button>
        )}
      </div>
    </Field>
  );
};

export default InputField;
