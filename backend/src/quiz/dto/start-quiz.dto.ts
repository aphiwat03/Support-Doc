import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsNumber, IsIn, Min, Max } from 'class-validator';

export class StartQuizDto {
  @ApiPropertyOptional({ example: 'linux', description: 'Slug ของหมวดหมู่ เช่น linux, network, sql (เว้นว่างไว้เพื่อสุ่มคละทุกหมวด)' })
  @IsOptional()
  @IsString()
  topic_slug?: string;

  @ApiPropertyOptional({ example: 1, description: 'ID ของหมวดหมู่' })
  @IsOptional()
  @IsNumber()
  topic_id?: number;

  @ApiPropertyOptional({ example: 'all', enum: ['all', 'easy', 'medium', 'hard'] })
  @IsOptional()
  @IsIn(['all', 'easy', 'medium', 'hard'])
  difficulty?: string;

  @ApiPropertyOptional({ example: 5, description: 'จำนวนข้อที่ต้องการทำ (1 - 50)', default: 10 })
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(50)
  total_questions?: number;
}
