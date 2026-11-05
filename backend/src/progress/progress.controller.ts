import { Controller, Get, Post, Delete, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { ProgressService } from './progress.service.js';

@ApiTags('Progress')
@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get()
  @ApiOperation({ summary: 'ดึงรายการบทเรียนที่อ่านเสร็จแล้วทั้งหมด' })
  @ApiResponse({ status: 200, description: 'รายการบทเรียนที่เสร็จแล้ว' })
  async getAll() {
    return this.progressService.getAll();
  }

  @Post(':lessonId')
  @ApiOperation({ summary: 'ทำเครื่องหมายว่าอ่านบทเรียนนี้เสร็จแล้ว' })
  @ApiParam({ name: 'lessonId', description: 'UUID ของบทเรียน' })
  @ApiResponse({ status: 200, description: 'บันทึกสำเร็จ' })
  async markComplete(@Param('lessonId') lessonId: string) {
    return this.progressService.markComplete(lessonId);
  }

  @Delete(':lessonId')
  @ApiOperation({ summary: 'ยกเลิกสถานะอ่านเสร็จแล้วของบทเรียนนี้' })
  @ApiParam({ name: 'lessonId', description: 'UUID ของบทเรียน' })
  @ApiResponse({ status: 200, description: 'ยกเลิกสำเร็จ' })
  async unmarkComplete(@Param('lessonId') lessonId: string) {
    return this.progressService.unmarkComplete(lessonId);
  }
}
