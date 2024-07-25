import { IsNumber, IsString, Length } from "class-validator";

export class UpdateLocationDto {
  @IsNumber()
  longitude: number;

  @IsString()
  latitude: number;
}
