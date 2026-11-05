import { Module } from '@nestjs/common';
import { StreakController } from './streak.controller.js';
import { StreakService } from './streak.service.js';

@Module({
  controllers: [StreakController],
  providers: [StreakService],
  exports: [StreakService],
})
export class StreakModule {}
