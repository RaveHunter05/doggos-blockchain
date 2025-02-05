import { Test, TestingModule } from '@nestjs/testing';
import { AgentkitController } from './agentkit.controller';
import { AgentkitService } from './agentkit.service';

describe('AgentkitController', () => {
  let controller: AgentkitController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AgentkitController],
      providers: [AgentkitService],
    }).compile();

    controller = module.get<AgentkitController>(AgentkitController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
