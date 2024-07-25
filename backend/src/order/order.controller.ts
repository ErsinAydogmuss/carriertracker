import {
  Controller,
  Post,
  Res,
  UseGuards,
  Body,
  Get,
  Query,
} from "@nestjs/common";
import { JwtAuthGuard } from "src/authentication/auth.guard";
import { Response } from "express";
import { OrderService } from "./order.service";
import { CreateOrderDto } from "./dto/create.dto";
import { CarrierService } from "src/carrier/carrier.service";
import { AssignToCarrierDto } from "./dto/assignToCarrier.dto";

@Controller("orders")
export class OrderController {
  constructor(
    private readonly orderService: OrderService,
    private readonly carrierService: CarrierService
  ) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Res() response: Response,
    @Body() createOrderDto: CreateOrderDto
  ) {
    try {
      const result = await this.orderService.create(createOrderDto);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully create order!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  async findAll(@Res() response: Response) {
    try {
      const result = await this.orderService.findAll();

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get all orders!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Get("/pending")
  @UseGuards(JwtAuthGuard)
  async findAllByPending(@Res() response: Response) {
    try {
      const result = await this.orderService.findAllByPending();

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get all pending orders!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Post("/assign")
  @UseGuards(JwtAuthGuard)
  async assignTheOrderToCarrier(
    @Res() response: Response,
    @Body() assingToCarrierDto: AssignToCarrierDto
  ) {
    try {
      const carrier = await this.carrierService.findOne(
        +assingToCarrierDto.carrierId
      );

      if (!carrier) {
        return response.status(404).json({
          status: "Error!",
          message: "Carrier not found!",
        });
      }

      if (!carrier.isReady) {
        return response.status(400).json({
          status: "Error!",
          message: "Carrier is not ready!",
        });
      }

      const result =
        await this.orderService.assignToCarrier(assingToCarrierDto);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully create order!",
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
  // orders/user?userId=1
  @Get("user")
  @UseGuards(JwtAuthGuard)
  async findAllOrdersByUserId(
    @Res() response: Response,
    @Query("userId") userId: string
  ) {
    try {
      const result = await this.orderService.findAllOrdersByUserId(+userId);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get all orders by user!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }
}
