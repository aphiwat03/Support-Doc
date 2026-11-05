import { Controller, Get, Post, Delete, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiQuery, ApiParam } from '@nestjs/swagger';
import { BookmarksService } from './bookmarks.service.js';
import { CreateBookmarkDto } from './dto/create-bookmark.dto.js';

@ApiTags('Bookmarks')
@Controller('bookmarks')
export class BookmarksController {
  constructor(private readonly bookmarksService: BookmarksService) {}

  @Get()
  @ApiOperation({ summary: 'ดึงรายการ Bookmark ทั้งหมด (กรองตามประเภท question, lesson, flashcard ได้)' })
  @ApiQuery({ name: 'item_type', required: false, enum: ['question', 'lesson', 'flashcard'] })
  @ApiResponse({ status: 200, description: 'รายการ Bookmark' })
  async findAll(@Query('item_type') itemType?: string) {
    return this.bookmarksService.findAll(itemType);
  }

  @Post()
  @ApiOperation({ summary: 'บันทึก Bookmark ใหม่ หรืออัปเดตโน้ตข้อความ' })
  @ApiResponse({ status: 201, description: 'บันทึกสำเร็จ' })
  async create(@Body() dto: CreateBookmarkDto) {
    return this.bookmarksService.create(dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'ลบ Bookmark ตาม ID' })
  @ApiParam({ name: 'id', description: 'UUID ของ Bookmark' })
  @ApiResponse({ status: 200, description: 'ลบสำเร็จ' })
  @ApiResponse({ status: 404, description: 'ไม่พบ Bookmark' })
  async remove(@Param('id') id: string) {
    return this.bookmarksService.remove(id);
  }

  @Delete('by-item/:itemType/:itemId')
  @ApiOperation({ summary: 'ลบ Bookmark ตาม item_type และ item_id' })
  @ApiParam({ name: 'itemType', enum: ['question', 'lesson', 'flashcard'] })
  @ApiParam({ name: 'itemId', description: 'UUID ของ Item' })
  @ApiResponse({ status: 200, description: 'ลบสำเร็จ' })
  @ApiResponse({ status: 404, description: 'ไม่พบ Bookmark' })
  async removeByItem(
    @Param('itemType') itemType: string,
    @Param('itemId') itemId: string,
  ) {
    return this.bookmarksService.removeByItem(itemType, itemId);
  }
}
