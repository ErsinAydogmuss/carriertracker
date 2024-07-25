import { Module } from "@nestjs/common";
import { CarrierService } from "./carrier.service";
import { CarrierController } from "./carrier.controller";
import { PrismaModule } from "src/prisma/prisma.module";
import { OrderService } from "src/order/order.service";

@Module({
  imports: [PrismaModule],
  controllers: [CarrierController],
  providers: [CarrierService, OrderService],
})
export class CarrierModule {}
