import { Test, TestingModule } from '@nestjs/testing';
import { FlowEvmService } from './flow-evm.service';

describe('FlowEvmService', () => {
  let service: FlowEvmService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [FlowEvmService],
    }).compile();

    service = module.get<FlowEvmService>(FlowEvmService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
