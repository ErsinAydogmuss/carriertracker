import { IsBoolean, IsNumber, IsString } from "class-validator";

export class UpdateStatusDto {
  @IsString()
  isReady: string;
}
