import { debugData } from "@/utils/debugData";
import type { InputProps } from "@/typings/dialog";

export const debugInput = () => {
  debugData<InputProps>([
    {
      action: "openDialog",
      data: {
        heading: "Police MDT",
        description: "Enter the details of the violation",
        options: {
          allowCancel: false,
        },
        rows: [
          {
            type: "input",
            label: "Suspect Name",
            description: "Full name of the suspect",
            placeholder: "Enter the suspect's name",
            default: "John Doe",
            required: true,
          },
          {
            type: "input",
            label: "Operator Password",
            description:
              "Enter your operator password to confirm the violation",
            placeholder: "Enter the operator password",
            default: "password123",
            password: true,
            required: true,
          },
          {
            type: "number",
            label: "Fine Amount",
            description: "The amount of the fine in dollars",
            placeholder: "Enter the fine amount",
            default: 100,
            min: 0,
          },
          {
            type: "select",
            label: "Violation Type",
            description: "Select the type of violation",
            options: [
              { value: "speeding", label: "Speeding" },
              { value: "parking", label: "Illegal Parking" },
              { value: "red_light", label: "Running Red Light" },
            ],
            required: true,
          },
          {
            type: "multi-select",
            label: "Additional Violations",
            description: "Select any additional violations",
            options: [
              { value: "reckless_driving", label: "Reckless Driving" },
              { value: " DUI", label: "DUI" },
              { value: "hit_and_run", label: "Hit and Run" },
            ],
            required: false,
          },
          {
            type: "checkbox",
            label: "Pay on Spot",
            checked: false,
          },
          {
            type: "slider",
            label: "Points on License",
            min: 0,
            max: 12,
            step: 1,
            default: 3,
          },
          {
            type: "color",
            label: "Car Color",
            description: "Select the color of the suspect's car",
            default: "#ff0000",
          },
          {
            type: "date",
            label: "Violation Date",
            description: "Select the date of the violation",
            default: "2024-01-01",
          },
          {
            type: "time",
            label: "Violation Time",
            description: "Select the time of the violation",
            default: "12:00",
          },
          {
            type: "date-range",
            label: "License Suspension Period",
            description: "Select the period of license suspension",
            default: ["2025-01-01", "2025-06-01"],
          },
          {
            type: "textarea",
            label: "Officer Notes",
            description: "Any additional notes about the violation",
            placeholder: "Enter any additional notes about the violation",
            default: "",
          },
        ],
      },
    },
  ]);
};
