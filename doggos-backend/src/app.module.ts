import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AgentkitModule } from './agentkit/agentkit.module';
import { FlowEvmModule } from './flow-evm/flow-evm.module';

@Module({
  imports: [AgentkitModule, FlowEvmModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
