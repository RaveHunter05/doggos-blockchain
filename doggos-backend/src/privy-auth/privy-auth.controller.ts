import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { PrivyAuthService } from './privy-auth.service';
import { CreatePrivyAuthDto } from './dto/create-privy-auth.dto';
import { UpdatePrivyAuthDto } from './dto/update-privy-auth.dto';

@Controller('privy-auth')
export class PrivyAuthController {
  constructor(private readonly privyAuthService: PrivyAuthService) {}

  @Post()
  create(@Body() createPrivyAuthDto: CreatePrivyAuthDto) {
    return this.privyAuthService.create(createPrivyAuthDto);
  }

  @Get()
  findAll() {
    return this.privyAuthService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.privyAuthService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePrivyAuthDto: UpdatePrivyAuthDto) {
    return this.privyAuthService.update(+id, updatePrivyAuthDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.privyAuthService.remove(+id);
  }
}
