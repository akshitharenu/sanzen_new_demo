import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';

export class SignInDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;
}

export class SignUpDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  firstName: string;

  @IsString()
  lastName: string;

  @IsOptional()
  @IsString()
  phone?: string;
}

export class ForgotPasswordDto {
  @IsEmail()
  email: string;
}

export class VerifyOtpDto {
  @IsEmail()
  email: string;

  @IsString()
  otp: string;
}

export class ResetPasswordDto {
  @IsEmail()
  email: string;

  @IsString()
  otp: string;

  @IsString()
  @MinLength(8)
  newPassword: string;
}

export class RefreshTokenDto {
  @IsString()
  refreshToken: string;
}
