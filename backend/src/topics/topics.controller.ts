import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { TopicsService } from './topics.service.js';

@ApiTags('Topics')
@Controller('topics')
export class TopicsController {
  constructor(private readonly topicsService: TopicsService) {}

  @Get()
  @ApiOperation({ summary: 'ดึงรายการหมวดหมู่ทั้งหมด พร้อมสถิติจำนวนบทเรียน คำถาม และแฟลชการ์ด' })
  @ApiResponse({ status: 200, description: 'รายการหมวดหมู่สำเร็จ' })
  async findAll() {
    return this.topicsService.findAll();
  }

  @Get(':slug')
  @ApiOperation({ summary: 'ดึงข้อมูลหมวดหมู่เฉพาะเจาะจงตาม slug พร้อมรายชื่อบทเรียนย่อย' })
  @ApiParam({ name: 'slug', example: 'linux', description: 'Slug ของหมวดหมู่ เช่น linux, network, sql' })
  @ApiResponse({ status: 200, description: 'ข้อมูลหมวดหมู่สำเร็จ' })
  @ApiResponse({ status: 404, description: 'ไม่พบหมวดหมู่ดังกล่าว' })
  async findBySlug(@Param('slug') slug: string) {
    return this.topicsService.findBySlug(slug);
  }
}
