import {
  Controller,
  Post,
  Get,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import {
  SignInDto,
  SignUpDto,
  ForgotPasswordDto,
  VerifyOtpDto,
  ResetPasswordDto,
  RefreshTokenDto,
} from './dto/auth.dto';
import { JwtAuthGuard } from './jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('signin')
  @HttpCode(HttpStatus.OK)
  async signIn(@Body() dto: SignInDto) {
    return this.authService.signIn(dto);
  }

  @Post('signup')
  async signUp(@Body() dto: SignUpDto) {
    return this.authService.signUp(dto);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getProfile(@Request() req: any) {
    return this.authService.getProfile(req.user.id);
  }

  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  async forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgotPassword(dto);
  }

  @Post('verify-otp')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(dto);
  }

  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  async resetPassword(@Body() dto: ResetPasswordDto) {
    return this.authService.resetPassword(dto);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refreshTokens(@Body() dto: RefreshTokenDto, @Request() req: any) {
    const userId = req.user?.sub;
    return this.authService.refreshTokens(userId, dto.refreshToken);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async logout(@Request() req: any) {
    return this.authService.logout(req.user.id);
  }
}

