import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery, ApiParam } from '@nestjs/swagger';
import { QuestionsService } from './questions.service.js';

@ApiTags('Questions')
@Controller('questions')
export class QuestionsController {
  constructor(private readonly questionsService: QuestionsService) {}

  @Get()
  @ApiOperation({ summary: 'ค้นหาและดึงรายการคำถามตามเงื่อนไข (หมวดหมู่, ความยาก, คำค้นหา)' })
  @ApiQuery({ name: 'topic_slug', required: false, description: 'Slug ของหมวด เช่น linux' })
  @ApiQuery({ name: 'topic_id', required: false, type: Number })
  @ApiQuery({ name: 'difficulty', required: false, enum: ['all', 'easy', 'medium', 'hard'] })
  @ApiQuery({ name: 'lesson_id', required: false })
  @ApiQuery({ name: 'search', required: false, description: 'คำค้นหาในข้อสอบ' })
  @ApiResponse({ status: 200, description: 'รายการข้อสอบ' })
  async findAll(
    @Query('topic_slug') topicSlug?: string,
    @Query('topic_id') topicId?: number,
    @Query('difficulty') difficulty?: string,
    @Query('lesson_id') lessonId?: string,
    @Query('search') search?: string,
  ) {
    return this.questionsService.findAll({
      topicSlug,
      topicId: topicId ? Number(topicId) : undefined,
      difficulty,
      lessonId,
      search,
      includeAnswers: false,
    });
  }

  @Get('random')
  @ApiOperation({ summary: 'สุ่มโจทย์ข้อสอบตามเงื่อนไขเพื่อใช้จัดชุดทำข้อสอบ (Random Quiz Quizzer)' })
  @ApiQuery({ name: 'topic_slug', required: false })
  @ApiQuery({ name: 'topic_id', required: false, type: Number })
  @ApiQuery({ name: 'difficulty', required: false, enum: ['all', 'easy', 'medium', 'hard'] })
  @ApiQuery({ name: 'limit', required: false, type: Number, example: 10 })
  @ApiResponse({ status: 200, description: 'ชุดข้อสอบที่สุ่มได้' })
  async findRandom(
    @Query('topic_slug') topicSlug?: string,
    @Query('topic_id') topicId?: number,
    @Query('difficulty') difficulty?: string,
    @Query('limit') limit?: number,
  ) {
    return this.questionsService.findRandom({
      topicSlug,
      topicId: topicId ? Number(topicId) : undefined,
      difficulty,
      limit: limit ? Number(limit) : 10,
    });
  }

  @Get(':id')
  @ApiOperation({ summary: 'ดึงข้อมูลคำถามข้อเดี่ยวตาม ID พร้อมตัวเลือกคำตอบ' })
  @ApiParam({ name: 'id', description: 'UUID ของคำถาม' })
  @ApiResponse({ status: 200, description: 'ข้อมูลคำถาม' })
  @ApiResponse({ status: 404, description: 'ไม่พบคำถาม' })
  async findById(@Param('id') id: string) {
    return this.questionsService.findById(id, false);
  }
}
