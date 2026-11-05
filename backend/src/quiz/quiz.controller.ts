import { Controller, Post, Get, Body, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { QuizService } from './quiz.service.js';
import { StartQuizDto } from './dto/start-quiz.dto.js';
import { SubmitQuizDto } from './dto/submit-quiz.dto.js';

@ApiTags('Quiz Engine')
@Controller('quiz')
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Post('start')
  @ApiOperation({ summary: 'สร้างรอบการทำข้อสอบใหม่ (Quiz Session) สุ่มโจทย์ตามเงื่อนไข' })
  @ApiResponse({ status: 201, description: 'สร้างรอบสอบและส่งชุดข้อสอบสำเร็จ' })
  async startQuiz(@Body() dto: StartQuizDto) {
    return this.quizService.startQuiz(dto);
  }

  @Post(':sessionId/submit')
  @ApiOperation({ summary: 'ส่งคำตอบทั้งหมด ตรวจข้อสอบ คำนวณคะแนน และส่งกลับคำอธิบายเฉลยละเอียด' })
  @ApiParam({ name: 'sessionId', description: 'UUID ของรอบการทำข้อสอบ' })
  @ApiResponse({ status: 200, description: 'ตรวจข้อสอบและสรุปผลคะแนนสำเร็จ' })
  @ApiResponse({ status: 400, description: 'รอบสอบนี้ตรวจไปแล้ว หรือข้อมูลไม่ถูกต้อง' })
  @ApiResponse({ status: 404, description: 'ไม่พบรอบสอบ' })
  async submitQuiz(
    @Param('sessionId') sessionId: string,
    @Body() dto: SubmitQuizDto,
  ) {
    return this.quizService.submitQuiz(sessionId, dto);
  }

  @Get(':sessionId')
  @ApiOperation({ summary: 'ดึงผลการสอบและรายงานย้อนหลังตาม session ID' })
  @ApiParam({ name: 'sessionId', description: 'UUID ของรอบการสอบ' })
  @ApiResponse({ status: 200, description: 'ผลลัพธ์ของรอบสอบ' })
  @ApiResponse({ status: 404, description: 'ไม่พบรอบสอบ' })
  async getSessionResult(@Param('sessionId') sessionId: string) {
    return this.quizService.getSessionResult(sessionId);
  }
}
