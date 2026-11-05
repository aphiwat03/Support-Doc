import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery } from '@nestjs/swagger';
import { FlashcardsService } from './flashcards.service.js';

@ApiTags('Flashcards')
@Controller('flashcards')
export class FlashcardsController {
  constructor(private readonly flashcardsService: FlashcardsService) {}

  @Get()
  @ApiOperation({ summary: 'ดึงรายการ Flashcards สำหรับทบทวนด่วน (กรองตามหมวดหมู่ได้)' })
  @ApiQuery({ name: 'topic_slug', required: false, description: 'Slug ของหมวด เช่น linux' })
  @ApiQuery({ name: 'topic_id', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'รายการ Flashcards' })
  async findAll(
    @Query('topic_slug') topicSlug?: string,
    @Query('topic_id') topicId?: number,
  ) {
    return this.flashcardsService.findAll(topicSlug, topicId ? Number(topicId) : undefined);
  }
}
