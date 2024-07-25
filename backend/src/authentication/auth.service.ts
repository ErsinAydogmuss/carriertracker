import { Injectable, NotFoundException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { PrismaService } from "src/prisma/prisma.service";
import { UserService } from "src/user/user.service";
import { LoginDto } from "src/authentication/dto/login.dto";
import * as bcrypt from "bcrypt";
import { RegisterDto } from "./dto/register.dto";
@Injectable()
export class AuthService {
  constructor(
    private readonly prismaService: PrismaService,
    private jwtService: JwtService,
    private readonly userService: UserService
  ) {}

  async login(
    loginDto: LoginDto
  ): Promise<{ token: string } | NotFoundException> {
    const { email, password, role } = loginDto;

    if (!email || !password || !role) {
      throw new NotFoundException("Invalid credentials");
    }

    const user = await this.prismaService.user.findUnique({
      where: {
        email: email,
        role: role,
      },
      include: {
        admin: {
          select: {
            id: true,
          },
        },
        carrier: {
          select: {
            id: true,
            isReady: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException("User not found");
    }

    const validatePassword = await bcrypt.compare(password, user.password);

    if (!validatePassword) {
      throw new NotFoundException("Invalid password");
    }

    return {
      token: this.jwtService.sign({
        name: user.name,
        email: user.email,
        role: user.role,
        id: user.id,
        ...(user.admin && { adminId: user.admin.id }),
        ...(user.carrier && {
          carrierId: user.carrier.id,
          isReady: user.carrier.isReady,
        }),
      }),
    };
  }

  async register(createDto: RegisterDto): Promise<{ token: string }> {
    const user = await this.userService.create(createDto);

    return {
      token: this.jwtService.sign({ email: user.email }),
    };
  }
}
