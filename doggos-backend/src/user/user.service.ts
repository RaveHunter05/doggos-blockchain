import { BadRequestException, Injectable } from '@nestjs/common'
import { CreateUserDto } from './dto/create-user.dto'
import { UpdateUserDto } from './dto/update-user.dto'

import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async create(userId: number, createUserDto: CreateUserDto) {
    const userCompletingProfile = await this.prisma.user.findUnique({
      where: {
        id: userId,
      },
    })

    const { userType } = createUserDto

    const roles = this.prisma.returnUsersEnum()

    if (!roles[userType]) {
      throw new BadRequestException('Invalid user type')
    }

    if (roles[userType] !== roles.GUEST) {
      const userTypeUpdated = roles[userType]
      await this.prisma.user.update({
        where: {
          id: userId,
        },
        data: {
          userType: userTypeUpdated,
        },
      })
    }

    const userAlreadyHasProfile = await this.prisma.persona.findFirst({
      where: {
        userId: userId,
      },
    })

    if (userAlreadyHasProfile) {
      throw new BadRequestException('User already has a profile')
    }

    delete createUserDto.userType

    const userProfile = await this.prisma.persona.create({
      data: {
        ...{
          ...createUserDto,
          birthdate: new Date(createUserDto.birthdate).toISOString(),
        },
        user: {
          connect: {
            id: userId,
          },
        },
      },
    })

    return {
      userType: userCompletingProfile.userType,
      firstName: userProfile.firstName,
      middleName: userProfile.middleName,
      firstSurname: userProfile.firstSurname,
      secondSurname: userProfile.secondSurname,
      birthdate: userProfile.birthdate,
      nationalId: userProfile.nationalId,
    }
  }

  findOne(id: number) {
    return `This action returns a #${id} user`
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return `This action updates a #${id} user`
  }

  remove(id: number) {
    return `This action removes a #${id} user`
  }
}
