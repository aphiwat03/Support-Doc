import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseModule } from './database/database.module.js';
import { TopicsModule } from './topics/topics.module.js';
import { LessonsModule } from './lessons/lessons.module.js';
import { QuestionsModule } from './questions/questions.module.js';
import { QuizModule } from './quiz/quiz.module.js';
import { FlashcardsModule } from './flashcards/flashcards.module.js';
import { BookmarksModule } from './bookmarks/bookmarks.module.js';
import { ProgressModule } from './progress/progress.module.js';
import { StreakModule } from './streak/streak.module.js';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['../.env', '.env'],
    }),
    DatabaseModule,
    TopicsModule,
    LessonsModule,
    QuestionsModule,
    QuizModule,
    FlashcardsModule,
    BookmarksModule,
    ProgressModule,
    StreakModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
