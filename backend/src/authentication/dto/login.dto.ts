import { Role } from "@prisma/client";
import { IsEnum, IsString, Length } from "class-validator";

export class LoginDto {
  @IsString()
  @Length(5, 10)
  email: string;

  @IsString()
  password: string;

  @IsEnum(Role)
  role: Role;
}
