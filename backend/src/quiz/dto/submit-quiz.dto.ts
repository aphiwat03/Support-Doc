import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsArray, IsString, IsUUID, ValidateNested, IsOptional, IsNumber } from 'class-validator';
import { Type } from 'class-transformer';

export class AnswerItemDto {
  @ApiProperty({ description: 'UUID ของคำถาม' })
  @IsUUID()
  question_id!: string;

  @ApiPropertyOptional({ description: 'UUID ของตัวเลือกที่ผู้ใช้เลือก (เว้นว่างได้หากไม่ได้ตอบ)' })
  @IsOptional()
  @IsUUID()
  selected_choice_id?: string;
}

export class SubmitQuizDto {
  @ApiProperty({ type: [AnswerItemDto], description: 'รายการคำตอบของผู้ใช้' })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AnswerItemDto)
  answers!: AnswerItemDto[];

  @ApiPropertyOptional({ example: 45, description: 'เวลาที่ใช้ไปทั้งหมด (วินาที)' })
  @IsOptional()
  @IsNumber()
  time_spent_seconds?: number;
}
