import { Role } from "@prisma/client";
import { IsEmail, IsEnum, IsString, Length } from "class-validator";

export class RegisterDto {
  @IsString()
  @Length(5, 10)
  name: string;

  @IsString()
  @Length(5, 10)
  surname: string;

  @IsString()
  @Length(5, 10)
  password: string;

  @IsEmail()
  email: string;

  @IsEnum(Role)
  role: Role;
}
