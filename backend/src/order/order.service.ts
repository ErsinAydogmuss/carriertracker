import { Injectable } from "@nestjs/common";
import { Order, OrderStatus } from "@prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateOrderDto } from "./dto/create.dto";
import { AssignToCarrierDto } from "./dto/assignToCarrier.dto";

@Injectable()
export class OrderService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createOrderDto: CreateOrderDto): Promise<Order> {
    return await this.prisma.order.create({
      data: {
        product: createOrderDto.product,
        user: {
          connect: {
            id: +createOrderDto.userId,
          },
        },
        moveTo: {
          create: {
            latitude: +createOrderDto.latitude,
            longitude: +createOrderDto.longitude,
          },
        },
      },
    });
  }

  async findAll(): Promise<Order[]> {
    return await this.prisma.order.findMany();
  }

  async findOne(id: number): Promise<Order | null> {
    return await this.prisma.order.findUnique({
      where: {
        id: id,
      },
    });
  }

  async findAllByPending(): Promise<Order[]> {
    return await this.prisma.order.findMany({
      where: {
        status: "PENDING",
      },
      include: {
        moveTo: true,
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

  async findAllOrdersByUserId(userId: number): Promise<Order[]> {
    return await this.prisma.order.findMany({
      where: {
        userId: userId,
      },
      include: {
        user: {
          select: {
            id: true,
            name: true,
            email: true,
          },
        },
        moveTo: true,
        assignedTo: {
          include: {
            user: {
              select: {
                id: true,
                name: true,
                email: true,
              },
            },
            location: true,
          },
        },
      },
    });
  }

  async assignToCarrier(
    assingToCarrierDto: AssignToCarrierDto
  ): Promise<Order> {
    console.log(assingToCarrierDto);
    return await this.prisma.order.update({
      where: {
        id: +assingToCarrierDto.orderId,
      },
      data: {
        assignedBy: {
          connect: {
            id: +assingToCarrierDto.adminId,
          },
        },
        assignedTo: {
          connect: {
            id: +assingToCarrierDto.carrierId,
          },
          update: {
            isReady: false,
          },
        },
        status: OrderStatus.ASSIGNED,
      },
    });
  }
}
