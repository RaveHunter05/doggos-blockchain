import { PartialType } from '@nestjs/mapped-types';
import { CreatePrivyAuthDto } from './create-privy-auth.dto';

export class UpdatePrivyAuthDto extends PartialType(CreatePrivyAuthDto) {}
