import { Module } from '@nestjs/common';
import { PrivyAuthService } from './privy-auth.service';
import { PrivyAuthController } from './privy-auth.controller';

@Module({
  controllers: [PrivyAuthController],
  providers: [PrivyAuthService],
})
export class PrivyAuthModule {}
