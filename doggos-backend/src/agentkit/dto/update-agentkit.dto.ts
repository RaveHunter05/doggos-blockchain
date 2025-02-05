import { PartialType } from '@nestjs/mapped-types';
import { CreateAgentkitDto } from './create-agentkit.dto';

export class UpdateAgentkitDto extends PartialType(CreateAgentkitDto) {}
