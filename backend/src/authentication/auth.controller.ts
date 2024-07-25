import { Controller, Post, Body, Res, NotFoundException } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { LoginDto } from "./dto/login.dto";
import { Response } from "express";
import { RegisterDto } from "./dto/register.dto";

@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post("/login")
  async login(@Res() response: Response, @Body() loginDto: LoginDto) {
    try {
      const result = await this.authService.login(loginDto);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully login!",
        result: result,
      });
    } catch (err) {
      if (err instanceof NotFoundException) {
        return response.status(404).json({
          status: "Error!",
          message: "Lütfen bilgilerinizi kontrol edin!",
        });
      }
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Post("/register")
  async register(@Res() response: Response, @Body() registerDto: RegisterDto) {
    try {
      const result = await this.authService.register(registerDto);
      return response.status(200).json({
        status: "Ok!",
        message: "Successfully register user!",
        result: result,
      });
    } catch (error) {
      console.log(error);
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }
}
