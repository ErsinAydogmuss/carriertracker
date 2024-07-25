import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
  Req,
  Res,
  UseGuards,
} from "@nestjs/common";
import { JwtAuthGuard } from "src/authentication/auth.guard";
import { Response } from "express";
import { CarrierService } from "./carrier.service";
import { OrderService } from "src/order/order.service";
import { UpdateLocationDto } from "./dto/update-location.dto";
import { UpdateCarrierDto } from "./dto/update-carrier.dto";
import { UpdateStatusDto } from "./dto/update-status.dto";

@Controller("/carriers")
export class CarrierController {
  constructor(
    private readonly carrierService: CarrierService,
    private readonly orderService: OrderService
  ) {}

  @Get(":id")
  @UseGuards(JwtAuthGuard)
  async findOne(@Res() response: Response, @Param("id") id: string) {
    try {
      const result = await this.carrierService.findOne(+id);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get carrier!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Put(":id")
  @UseGuards(JwtAuthGuard)
  async update(
    @Res() response: Response,
    @Param("id") id: string,
    @Body() UpdateCarrierDto: UpdateCarrierDto
  ) {
    try {
      console.log(UpdateCarrierDto);
      console.log(id);
      const result = await this.carrierService.finishDelivery(
        +UpdateCarrierDto.orderId
      );

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully update carrier!",
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

  @Put(":id/location")
  @UseGuards(JwtAuthGuard)
  async updateLocation(
    @Res() response: Response,
    @Req() request: Request,
    @Body() updateLocationDto: UpdateLocationDto,
    @Param("id") id: string
  ) {
    try {
      const result = await this.carrierService.updateLocation(
        +id,
        updateLocationDto
      );

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully update location!",
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

  @Get()
  @UseGuards(JwtAuthGuard)
  async findAll(@Res() response: Response) {
    try {
      const result = await this.carrierService.findAll();

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get carriers!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Get(":carrierId/orders")
  @UseGuards(JwtAuthGuard)
  async findMyDelivery(
    @Res() response: Response,
    @Param("carrierId") carrierId: string
  ) {
    try {
      const result = await this.carrierService.findMyDelivery(+carrierId);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully get orders!",
        result: result,
      });
    } catch (error) {
      return response.status(500).json({
        status: "Error!",
        message: "Internal Server Error!",
      });
    }
  }

  @Put(":carrierId/status")
  @UseGuards(JwtAuthGuard)
  async updateStatus(
    @Res() response: Response,
    @Param("carrierId") carrierId: string,
    @Body() updateCarrierDto: UpdateStatusDto
  ) {
    try {
      const isReady = updateCarrierDto.isReady === "true" ? true : false;
      const result = await this.carrierService.updateReadyStatus(
        +carrierId,
        isReady
      );

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully update status!",
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

  @Post("/complete")
  @UseGuards(JwtAuthGuard)
  async completeOrder(
    @Res() response: Response,
    @Param("orderId") orderId: string,
    @Param("carrierId") carrierId: string
  ) {
    try {
      const order = await this.orderService.findOne(+orderId);

      if (!order) {
        return response.status(404).json({
          status: "Error!",
          message: "Order not found!",
        });
      }

      if (order.carrierId !== +carrierId) {
        return response.status(403).json({
          status: "Error!",
          message: "You are not the carrier of this order!",
        });
      }

      const result = await this.carrierService.completeOrder(+orderId);

      return response.status(200).json({
        status: "Ok!",
        message: "Successfully complete order!",
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
