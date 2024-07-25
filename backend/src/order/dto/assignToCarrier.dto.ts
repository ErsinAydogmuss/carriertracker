import { IsNumber } from "class-validator";

export class AssignToCarrierDto {
  @IsNumber()
  orderId: number;

  @IsNumber()
  adminId: number;

  @IsNumber()
  carrierId: number;
}
