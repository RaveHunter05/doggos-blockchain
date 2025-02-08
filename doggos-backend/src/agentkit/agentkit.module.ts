import { Module } from '@nestjs/common';
import { AgentkitService } from './agentkit.service';
import { AgentkitController } from './agentkit.controller';
import { ChatGateway } from './gateway/chat.gateway';

@Module({
  controllers: [AgentkitController],
  providers: [AgentkitService, ChatGateway],
})
export class AgentkitModule {}
