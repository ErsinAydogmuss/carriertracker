import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { UserModule } from "./user/user.module";
import { PrismaModule } from "./prisma/prisma.module";
import { ConfigModule } from "@nestjs/config";
import { AuthModule } from "./authentication/auth.module";
import { ThrottlerGuard, ThrottlerModule } from "@nestjs/throttler";
import { OrderModule } from "./order/order.module";
import { CarrierModule } from "./carrier/carrier.module";

@Module({
  imports: [
    UserModule,
    AuthModule,
    PrismaModule,
    OrderModule,
    CarrierModule,
    ConfigModule.forRoot(),
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 10,
      },
    ]),
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: "APP_GUARD",
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}
