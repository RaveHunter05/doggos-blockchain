import { Injectable } from '@nestjs/common';
import { CreatePrivyAuthDto } from './dto/create-privy-auth.dto';
import { UpdatePrivyAuthDto } from './dto/update-privy-auth.dto';

@Injectable()
export class PrivyAuthService {
  create(createPrivyAuthDto: CreatePrivyAuthDto) {
    return 'This action adds a new privyAuth';
  }

  findAll() {
    return `This action returns all privyAuth`;
  }

  findOne(id: number) {
    return `This action returns a #${id} privyAuth`;
  }

  update(id: number, updatePrivyAuthDto: UpdatePrivyAuthDto) {
    return `This action updates a #${id} privyAuth`;
  }

  remove(id: number) {
    return `This action removes a #${id} privyAuth`;
  }
}
