import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpStatus,
  HttpCode,
  UseGuards,
} from '@nestjs/common'

import { UserService } from './user.service'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'
import { AtGuard } from 'src/common/guards'
import { GetCurrentUserId } from 'src/common/decorators'

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('create-profile')
  @UseGuards(AtGuard)
  @HttpCode(HttpStatus.CREATED)
  create(
    @GetCurrentUserId() userId: number,
    @Body() createUserDto: CreateUserDto,
  ) {
    return this.userService.create(userId, createUserDto)
  }

  // @Get()
  // findAll() {
  //   return this.userService.findAll()
  // }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userService.findOne(+id)
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.userService.update(+id, updateUserDto)
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userService.remove(+id)
  }
}
