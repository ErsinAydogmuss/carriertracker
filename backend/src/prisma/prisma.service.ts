import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  async onModuleInit() {
    console.log('Connecting PrismaClient onModuleInit');
    await this.$connect();
  }

  async onModuleDestroy() {
    console.log('Disconnecting PrismaClient onModuleDestroy');
    await this.$disconnect();
  }

  async beforeApplicationShutdown() {
    console.log('Disconnecting PrismaClient beforeApplicationShutdown');
    await this.$disconnect();
  }
}
