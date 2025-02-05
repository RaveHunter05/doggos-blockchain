import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { FlowEvmService } from './flow-evm.service';
import { CreateFlowEvmDto } from './dto/create-flow-evm.dto';
import { UpdateFlowEvmDto } from './dto/update-flow-evm.dto';

@Controller('flow-evm')
export class FlowEvmController {
  constructor(private readonly flowEvmService: FlowEvmService) {}

  @Post()
  create(@Body() createFlowEvmDto: CreateFlowEvmDto) {
    return this.flowEvmService.create(createFlowEvmDto);
  }

  @Get()
  findAll() {
    return this.flowEvmService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.flowEvmService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateFlowEvmDto: UpdateFlowEvmDto) {
    return this.flowEvmService.update(+id, updateFlowEvmDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.flowEvmService.remove(+id);
  }
}
