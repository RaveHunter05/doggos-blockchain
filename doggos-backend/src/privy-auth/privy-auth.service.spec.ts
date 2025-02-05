import { Test, TestingModule } from '@nestjs/testing';
import { PrivyAuthService } from './privy-auth.service';

describe('PrivyAuthService', () => {
  let service: PrivyAuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PrivyAuthService],
    }).compile();

    service = module.get<PrivyAuthService>(PrivyAuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
