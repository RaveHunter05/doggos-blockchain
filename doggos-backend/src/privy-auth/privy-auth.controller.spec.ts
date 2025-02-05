import { Test, TestingModule } from '@nestjs/testing';
import { PrivyAuthController } from './privy-auth.controller';
import { PrivyAuthService } from './privy-auth.service';

describe('PrivyAuthController', () => {
  let controller: PrivyAuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PrivyAuthController],
      providers: [PrivyAuthService],
    }).compile();

    controller = module.get<PrivyAuthController>(PrivyAuthController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
