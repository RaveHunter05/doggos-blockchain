import { PartialType } from '@nestjs/mapped-types';
import { CreateFlowEvmDto } from './create-flow-evm.dto';

export class UpdateFlowEvmDto extends PartialType(CreateFlowEvmDto) {}
