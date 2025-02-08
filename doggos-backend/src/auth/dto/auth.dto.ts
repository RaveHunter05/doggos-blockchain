import { IsNotEmpty, IsString, IsOptional } from 'class-validator'

export class SignUpDto {
  @IsOptional()
  @IsString()
  username?: string

  @IsNotEmpty()
  @IsString()
  email: string

  @IsNotEmpty()
  @IsString()
  password: string
}

export class AuthDto {
  @IsNotEmpty()
  @IsString()
  email: string

  @IsNotEmpty()
  @IsString()
  password: string
}
