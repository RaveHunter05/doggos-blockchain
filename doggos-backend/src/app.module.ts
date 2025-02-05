import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AgentkitModule } from './agentkit/agentkit.module';
import { FlowEvmModule } from './flow-evm/flow-evm.module';
import { PrivyAuthModule } from './privy-auth/privy-auth.module';

@Module({
  imports: [AgentkitModule, FlowEvmModule, PrivyAuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
