import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle("Nestjs Shop Api")
    .setDescription("The Nestjs Shop API description")
    .setVersion("0.1")
    .build();

  const cors = {
    origin: ["https://localhost:3000"],
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
  };

  app.enableCors(cors);

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api", app, document);

  await app.listen(3000);
}
bootstrap();
