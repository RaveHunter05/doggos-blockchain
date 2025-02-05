import { Test, TestingModule } from '@nestjs/testing';
import { FlowEvmController } from './flow-evm.controller';
import { FlowEvmService } from './flow-evm.service';

describe('FlowEvmController', () => {
  let controller: FlowEvmController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FlowEvmController],
      providers: [FlowEvmService],
    }).compile();

    controller = module.get<FlowEvmController>(FlowEvmController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
