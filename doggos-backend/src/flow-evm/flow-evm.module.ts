import { Module } from '@nestjs/common';
import { FlowEvmService } from './flow-evm.service';
import { FlowEvmController } from './flow-evm.controller';

@Module({
  controllers: [FlowEvmController],
  providers: [FlowEvmService],
})
export class FlowEvmModule {}
