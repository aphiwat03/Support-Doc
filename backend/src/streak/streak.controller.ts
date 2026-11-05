import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery } from '@nestjs/swagger';
import { StreakService } from './streak.service.js';

@ApiTags('Streak')
@Controller('streak')
export class StreakController {
  constructor(private readonly streakService: StreakService) {}

  @Get('summary')
  @ApiOperation({ summary: 'ดึงสรุปจำนวนวัน Streak ปัจจุบันและสถิติสูงสุด' })
  @ApiResponse({ status: 200, description: 'ข้อมูล Streak สรุป' })
  async getSummary() {
    return this.streakService.getSummary();
  }

  @Get('activity')
  @ApiOperation({ summary: 'ดึงสถิติกิจกรรมการเรียนรายวันสำหรับสร้างกราฟ' })
  @ApiQuery({ name: 'days', required: false, type: Number, description: 'จำนวนวันย้อนหลัง (ค่าเริ่มต้น 30)' })
  @ApiResponse({ status: 200, description: 'รายการกิจกรรมรายวัน' })
  async getActivity(@Query('days') days?: string) {
    const daysNum = days ? parseInt(days, 10) : 30;
    return this.streakService.getActivity(daysNum);
  }

  @Get('progress')
  @ApiOperation({ summary: 'ดึงเปอร์เซ็นต์ความคืบหน้ารายหมวดหมู่' })
  @ApiResponse({ status: 200, description: 'ความคืบหน้ารายหมวด' })
  async getTopicProgress() {
    return this.streakService.getTopicProgress();
  }

  @Post('activity')
  @ApiOperation({ summary: 'บันทึกกิจกรรมการเรียน (อ่านบทเรียน / ทำข้อสอบ / แฟลชการ์ด)' })
  @ApiResponse({ status: 201, description: 'บันทึกกิจกรรมสำเร็จ' })
  async recordActivity(
    @Body() body: { activity_type: 'lesson' | 'quiz' | 'flashcard'; item_id?: string }
  ) {
    return this.streakService.recordActivity(body.activity_type, body.item_id);
  }
}
