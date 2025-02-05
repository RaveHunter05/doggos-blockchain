import { Injectable } from '@nestjs/common';
import { CreateAgentkitDto } from './dto/create-agentkit.dto';
import { UpdateAgentkitDto } from './dto/update-agentkit.dto';

@Injectable()
export class AgentkitService {
  create(createAgentkitDto: CreateAgentkitDto) {
    return 'This action adds a new agentkit';
  }

  findAll() {
    return `This action returns all agentkit`;
  }

  findOne(id: number) {
    return `This action returns a #${id} agentkit`;
  }

  update(id: number, updateAgentkitDto: UpdateAgentkitDto) {
    return `This action updates a #${id} agentkit`;
  }

  remove(id: number) {
    return `This action removes a #${id} agentkit`;
  }
}
