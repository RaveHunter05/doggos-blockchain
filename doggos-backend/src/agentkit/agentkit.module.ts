import { Module } from '@nestjs/common';
import { AgentkitService } from './agentkit.service';
import { AgentkitController } from './agentkit.controller';

@Module({
  controllers: [AgentkitController],
  providers: [AgentkitService],
})
export class AgentkitModule {}
