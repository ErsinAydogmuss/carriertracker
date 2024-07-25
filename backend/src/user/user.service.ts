import { Injectable } from "@nestjs/common";
import { Role, User } from "@prisma/client";
import { RegisterDto } from "src/authentication/dto/register.dto";
import { PrismaService } from "src/prisma/prisma.service";
import * as bcrypt from "bcrypt";

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<User[]> {
    return await this.prisma.user.findMany();
  }

  async findOne(id: number): Promise<User | null> {
    return await this.prisma.user.findUnique({
      where: {
        id,
      },
    });
  }

  async create(data: RegisterDto): Promise<User> {
    return await this.prisma.user.create({
      data: {
        name: data.name,
        email: data.email,
        password: await bcrypt.hash(data.password, 10),
        role: data.role,
        ...(data.role === Role.ADMIN
          ? { admin: { create: {} } }
          : data.role === Role.CARRIER
            ? {
                carrier: {
                  create: {
                    location: {
                      create: {
                        latitude: 0,
                        longitude: 0,
                      },
                    },
                  },
                },
              }
            : {}),
      },
    });
  }
}
