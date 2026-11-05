import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module.js';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);

  // Set global API prefix
  app.setGlobalPrefix('api');

  // Enable CORS for frontend applications
  app.enableCors({
    origin: ['http://localhost:3000', 'http://127.0.0.1:3000'],
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });

  // Enable Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: false,
    }),
  );

  // Configure Swagger Documentation
  const config = new DocumentBuilder()
    .setTitle('Support Knowledge Review API')
    .setDescription(
      'API สำหรับเว็บแอปพลิเคชันทบทวนความรู้สาย Technical Support\n' +
      'ครอบคลุมหมวดหมู่ Linux, Network, SQL, Web/API, Docker และ Troubleshooting Methodology\n' +
      'ทำงานด้วย Raw SQL (Native pg Pool) โดยไม่มี ORM',
    )
    .setVersion('1.0.0')
    .addTag('Topics', 'ระบบจัดการและสืบค้นหมวดหมู่วิชาชีพ')
    .addTag('Lessons', 'ระบบบทเรียนและคลังความรู้สำหรับอ่านทบทวน')
    .addTag('Questions', 'คลังข้อสอบและสุ่มโจทย์ตามเงื่อนไข')
    .addTag('Quiz Engine', 'ระบบทำข้อสอบ ตรวจคำตอบ จับเวลา และสรุปผลวิเคราะห์')
    .addTag('Flashcards', 'ระบบการ์ดทบทวนความรู้ด่วน (Spaced Flashcards)')
    .addTag('Bookmarks', 'ระบบบันทึกรายการสำหรับทบทวนซ้ำ')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document, {
    customSiteTitle: 'Support Knowledge API Docs',
    swaggerOptions: {
      persistAuthorization: true,
      docExpansion: 'list',
      filter: true,
    },
  });

  const port = process.env.PORT || 4000;
  await app.listen(port);
  logger.log(`Server is running at: http://localhost:${port}/api`);
  logger.log(`Swagger UI is available at: http://localhost:${port}/api/docs`);
}

await bootstrap();
