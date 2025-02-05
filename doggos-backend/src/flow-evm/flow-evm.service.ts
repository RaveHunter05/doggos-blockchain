import { Injectable } from '@nestjs/common';
import { CreateFlowEvmDto } from './dto/create-flow-evm.dto';
import { UpdateFlowEvmDto } from './dto/update-flow-evm.dto';

@Injectable()
export class FlowEvmService {
  create(createFlowEvmDto: CreateFlowEvmDto) {
    return 'This action adds a new flowEvm';
  }

  findAll() {
    return `This action returns all flowEvm`;
  }

  findOne(id: number) {
    return `This action returns a #${id} flowEvm`;
  }

  update(id: number, updateFlowEvmDto: UpdateFlowEvmDto) {
    return `This action updates a #${id} flowEvm`;
  }

  remove(id: number) {
    return `This action removes a #${id} flowEvm`;
  }
}
