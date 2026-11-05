import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, IsIn, IsOptional } from 'class-validator';

export class CreateBookmarkDto {
  @ApiProperty({ example: 'question', enum: ['question', 'lesson', 'flashcard'] })
  @IsIn(['question', 'lesson', 'flashcard'])
  item_type!: string;

  @ApiProperty({ description: 'UUID ของรายการที่ต้องการ Bookmark' })
  @IsUUID()
  item_id!: string;

  @ApiPropertyOptional({ example: 'ต้องกลับมาทบทวนเรื่อง octal permission อีกครั้ง' })
  @IsOptional()
  @IsString()
  notes?: string;
}
