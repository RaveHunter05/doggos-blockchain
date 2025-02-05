import { Test, TestingModule } from '@nestjs/testing';
import { AgentkitService } from './agentkit.service';

describe('AgentkitService', () => {
  let service: AgentkitService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [AgentkitService],
    }).compile();

    service = module.get<AgentkitService>(AgentkitService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
