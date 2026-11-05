import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery, ApiParam } from '@nestjs/swagger';
import { LessonsService } from './lessons.service.js';

@ApiTags('Lessons')
@Controller('lessons')
export class LessonsController {
  constructor(private readonly lessonsService: LessonsService) {}

  @Get()
  @ApiOperation({ summary: 'ดึงรายการบทเรียนทั้งหมด (สามารถกรองตาม topic_slug หรือ topic_id ได้)' })
  @ApiQuery({ name: 'topic_slug', required: false, description: 'Slug ของหมวดหมู่ เช่น linux' })
  @ApiQuery({ name: 'topic_id', required: false, type: Number, description: 'ID ของหมวดหมู่' })
  @ApiResponse({ status: 200, description: 'รายการบทเรียน' })
  async findAll(
    @Query('topic_slug') topicSlug?: string,
    @Query('topic_id') topicId?: number,
  ) {
    return this.lessonsService.findAll(topicSlug, topicId ? Number(topicId) : undefined);
  }

  @Get(':id')
  @ApiOperation({ summary: 'ดึงเนื้อหาบทเรียนฉบับเต็มตาม UUID' })
  @ApiParam({ name: 'id', description: 'UUID ของบทเรียน' })
  @ApiResponse({ status: 200, description: 'เนื้อหาบทเรียน' })
  @ApiResponse({ status: 404, description: 'ไม่พบบทเรียน' })
  async findById(@Param('id') id: string) {
    return this.lessonsService.findById(id);
  }

  @Get('by-slug/:topicSlug/:lessonSlug')
  @ApiOperation({ summary: 'ดึงเนื้อหาบทเรียนตาม topic slug และ lesson slug พร้อมรายการบทเรียนเพื่อนำทาง (Sidebar Nav)' })
  @ApiParam({ name: 'topicSlug', example: 'linux' })
  @ApiParam({ name: 'lessonSlug', example: 'linux-permissions' })
  @ApiResponse({ status: 200, description: 'เนื้อหาบทเรียนพร้อม Sibling navigation' })
  @ApiResponse({ status: 404, description: 'ไม่พบบทเรียน' })
  async findBySlug(
    @Param('topicSlug') topicSlug: string,
    @Param('lessonSlug') lessonSlug: string,
  ) {
    return this.lessonsService.findByTopicAndSlug(topicSlug, lessonSlug);
  }
}
