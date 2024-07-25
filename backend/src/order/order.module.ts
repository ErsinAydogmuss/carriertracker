import { Module } from "@nestjs/common";
import { OrderService } from "./order.service";
import { OrderController } from "./order.controller";
import { PrismaModule } from "src/prisma/prisma.module";
import { CarrierService } from "src/carrier/carrier.service";

@Module({
  imports: [PrismaModule],
  controllers: [OrderController],
  providers: [OrderService, CarrierService],
})
export class OrderModule {}
