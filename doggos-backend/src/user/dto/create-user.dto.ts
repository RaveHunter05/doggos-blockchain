import { IsString, IsNotEmpty, IsOptional, IsDateString } from 'class-validator'

// This doesn't have to do with the user model, instead is referred to the profiling of said user

export class CreateUserDto {
  @IsNotEmpty()
  @IsString()
  firstName: string

  @IsOptional()
  @IsString()
  middleName?: string

  @IsNotEmpty()
  @IsString()
  firstSurname: string

  @IsOptional()
  @IsString()
  secondSurname?: string

  @IsOptional()
  @IsString()
  nationalId?: string

  @IsNotEmpty()
  @IsDateString()
  birthdate: Date

  @IsNotEmpty()
  @IsString()
  userType: string
}
