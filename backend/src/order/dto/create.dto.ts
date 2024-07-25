import { IsArray, IsEnum, IsNumber, IsString } from "class-validator";

export class CreateOrderDto {
  @IsArray()
  product: string;

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;

  @IsNumber()
  userId: number;
}
