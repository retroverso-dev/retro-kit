import { IDateInput } from "@/typings/dialog";
import { Control, useController } from "react-hook-form";
import { FormValues } from "../InputDialog";
import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { Calendar } from "@/components/ui/calendar";
import { Button } from "@/components/ui/button";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { CalendarIcon } from "lucide-react";
import { format } from "date-fns";
import { type DateRange } from "react-day-picker";

// Converts dayjs/moment format tokens to date-fns tokens
function toDateFnsFormat(fmt: string): string {
  return fmt
    .replace(/YYYY/g, "yyyy")
    .replace(/YY/g, "yy")
    .replace(/DD/g, "dd")
    .replace(/D/g, "d");
}

interface Props {
  row: IDateInput;
  index: number;
  control: Control<FormValues>;
}

function parseDate(value: unknown): Date | undefined {
  if (!value) return undefined;
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

function getDefaultSingle(def: IDateInput["default"]): number | undefined {
  if (def === true) return new Date().getTime();
  if (typeof def === "string") {
    const d = parseDate(def);
    return d ? d.getTime() : undefined;
  }
  return undefined;
}

function getDefaultRange(
  def: IDateInput["default"],
): [number, number] | undefined {
  if (def === true) {
    const now = new Date().getTime();
    return [now, now];
  }
  if (Array.isArray(def) && def.length >= 2) {
    const from = parseDate(def[0]);
    const to = parseDate(def[1]);
    if (!from || !to) return undefined;
    return [from.getTime(), to.getTime()];
  }
  return undefined;
}

const SingleDateField: React.FC<{
  controller: ReturnType<typeof useController<any>>;
  row: IDateInput;
  minDate?: Date;
  maxDate?: Date;
}> = ({ controller, row, minDate, maxDate }) => {
  const selectedDate = parseDate(controller.field.value);

  const disabledMatcher = (date: Date) => {
    if (minDate && date < minDate) return true;
    if (maxDate && date > maxDate) return true;
    return false;
  };

  const calendarProps = {
    mode: "single" as const,
    selected: selectedDate,
    onSelect: (date: Date | undefined) => {
      controller.field.onChange(date ? date.getTime() : undefined);
    },
    disabled: row.disabled ? true : disabledMatcher,
    defaultMonth: selectedDate ?? minDate ?? new Date(),
  };

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          className="w-full justify-start px-2.5 font-normal"
          disabled={row.disabled}
        >
          <CalendarIcon className="mr-2 size-4" />
          {selectedDate ? (
            format(selectedDate, toDateFnsFormat(row.format || "PPP"))
          ) : (
            <span className="text-muted-foreground">
              {row.default || "Pick a date"}
            </span>
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0" align="start">
        {row.required ? (
          <Calendar {...calendarProps} required />
        ) : (
          <Calendar {...calendarProps} />
        )}
      </PopoverContent>
    </Popover>
  );
};

const RangeDateField: React.FC<{
  controller: ReturnType<typeof useController<any>>;
  row: IDateInput;
  minDate?: Date;
  maxDate?: Date;
}> = ({ controller, row, minDate, maxDate }) => {
  const rangeValue = controller.field.value as
    | [number | undefined, number | undefined]
    | undefined;

  const selectedRange: DateRange | undefined =
    rangeValue && rangeValue[0]
      ? {
          from: new Date(rangeValue[0]),
          to: rangeValue[1] ? new Date(rangeValue[1]) : undefined,
        }
      : undefined;

  const disabledMatcher = (date: Date) => {
    if (minDate && date < minDate) return true;
    if (maxDate && date > maxDate) return true;
    return false;
  };

  const dateFormat = toDateFnsFormat(row.format || "LLL dd, y");

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          className="w-full justify-start px-2.5 font-normal"
          disabled={row.disabled}
        >
          <CalendarIcon className="mr-2 size-4" />
          {selectedRange?.from ? (
            selectedRange.to ? (
              <>
                {format(selectedRange.from, dateFormat)} -{" "}
                {format(selectedRange.to, dateFormat)}
              </>
            ) : (
              format(selectedRange.from, dateFormat)
            )
          ) : (
            <span className="text-muted-foreground">
              {row.default || "Pick a date range"}
            </span>
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0" align="start">
        <Calendar
          mode="range"
          selected={selectedRange}
          onSelect={(range) => {
            if (!range) {
              controller.field.onChange(undefined);
              return;
            }
            controller.field.onChange([
              range.from ? range.from.getTime() : undefined,
              range.to ? range.to.getTime() : undefined,
            ]);
          }}
          disabled={row.disabled ? true : disabledMatcher}
          defaultMonth={selectedRange?.from ?? minDate ?? new Date()}
          numberOfMonths={2}
        />
      </PopoverContent>
    </Popover>
  );
};

const DateField: React.FC<Props> = ({ row, index, control }) => {
  const isRange = row.type === "date-range";

  const controller = useController({
    name: `test.${index}.value`,
    control: control,
    rules: { required: row.required },
    defaultValue: isRange
      ? getDefaultRange(row.default)
      : getDefaultSingle(row.default),
  });

  const minDate = row.min ? parseDate(row.min) : undefined;
  const maxDate = row.max ? parseDate(row.max) : undefined;

  return (
    <Field>
      <FieldLabel>{row.label}</FieldLabel>
      {row.description && (
        <FieldDescription className="text-left">
          {row.description}
        </FieldDescription>
      )}
      {!isRange && (
        <SingleDateField
          controller={controller}
          row={row}
          minDate={minDate}
          maxDate={maxDate}
        />
      )}

      {isRange && (
        <RangeDateField
          controller={controller}
          row={row}
          minDate={minDate}
          maxDate={maxDate}
        />
      )}
    </Field>
  );
};

export default DateField;
