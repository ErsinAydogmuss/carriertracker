import { Injectable } from "@nestjs/common";
import { Carrier, Order, OrderStatus } from "@prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import { UpdateLocationDto } from "./dto/update-location.dto";

@Injectable()
export class CarrierService {
  constructor(private readonly prisma: PrismaService) {}

  async findOne(id: number): Promise<Carrier | null> {
    return await this.prisma.carrier.findUnique({
      where: {
        id,
      },
    });
  }

  async completeOrder(orderId: number): Promise<Order | null> {
    return await this.prisma.order.update({
      where: {
        id: orderId,
      },
      data: {
        status: OrderStatus.COMPLETED,
      },
    });
  }

  async findMyDelivery(id: number): Promise<Order | null> {
    return await this.prisma.order.findFirst({
      where: {
        carrierId: id,
        status: OrderStatus.ASSIGNED,
      },
      include: {
        assignedBy: {
          include: {
            user: {
              select: {
                id: true,
                name: true,
                email: true,
              },
            },
          },
        },
        user: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
        moveTo: true,
      },
    });
  }

  async findAll(): Promise<Carrier[]> {
    return await this.prisma.carrier.findMany({
      include: {
        location: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
      },
    });
  }

  async updateLocation(
    id: number,
    updateLocationDto: UpdateLocationDto
  ): Promise<Carrier> {
    return await this.prisma.carrier.update({
      where: {
        id,
      },
      data: {
        location: {
          update: {
            latitude: +updateLocationDto.latitude,
            longitude: +updateLocationDto.longitude,
          },
        },
      },
    });
  }

  async finishDelivery(orderId: number): Promise<Order> {
    return await this.prisma.order.update({
      where: {
        id: orderId,
      },
      data: {
        status: OrderStatus.COMPLETED,
      },
    });
  }

  async updateReadyStatus(id: number, isReady: boolean): Promise<Carrier> {
    return await this.prisma.carrier.update({
      where: {
        id,
      },
      data: {
        isReady,
      },
    });
  }
}
