import { IsNumber } from "class-validator";

export class UpdateCarrierDto {
  @IsNumber()
  orderId: number;
}
