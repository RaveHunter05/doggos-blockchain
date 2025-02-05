import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { AgentkitService } from './agentkit.service';
import { CreateAgentkitDto } from './dto/create-agentkit.dto';
import { UpdateAgentkitDto } from './dto/update-agentkit.dto';

@Controller('agentkit')
export class AgentkitController {
  constructor(private readonly agentkitService: AgentkitService) {}

  @Post()
  create(@Body() createAgentkitDto: CreateAgentkitDto) {
    return this.agentkitService.create(createAgentkitDto);
  }

  @Get()
  findAll() {
    return this.agentkitService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.agentkitService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateAgentkitDto: UpdateAgentkitDto) {
    return this.agentkitService.update(+id, updateAgentkitDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.agentkitService.remove(+id);
  }
}
