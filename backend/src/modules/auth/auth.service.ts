import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../../prisma/prisma.service';
import { MailService } from '../mail/mail.service';
import {
  SignInDto,
  SignUpDto,
  ForgotPasswordDto,
  VerifyOtpDto,
  ResetPasswordDto,
} from './dto/auth.dto';

@Injectable()
export class AuthService {
  private otpStore: Map<string, { otp: string; expiresAt: Date }> = new Map();

  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private mailService: MailService,
  ) {}

  async signIn(dto: SignInDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordValid = await bcrypt.compare(dto.password, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Account is deactivated');
    }

    const tokens = await this.generateTokens(user.id, user.email, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
      ...tokens,
    };
  }

  async signUp(dto: SignUpDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        password: hashedPassword,
        firstName: dto.firstName,
        lastName: dto.lastName,
        phone: dto.phone,
      },
    });

    const tokens = await this.generateTokens(user.id, user.email, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      },
      ...tokens,
    };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      // Return success even if user not found for security
      return { message: 'If the email exists, a verification code has been sent' };
    }

    const otp = this.generateOtp();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    this.otpStore.set(dto.email, { otp, expiresAt });

    await this.mailService.sendOtpEmail(dto.email, otp, user.firstName);

    return { message: 'Verification code sent to your email' };
  }

  async verifyOtp(dto: VerifyOtpDto) {
    const stored = this.otpStore.get(dto.email);

    if (!stored) {
      throw new BadRequestException('No OTP found for this email');
    }

    if (new Date() > stored.expiresAt) {
      this.otpStore.delete(dto.email);
      throw new BadRequestException('OTP has expired');
    }

    if (stored.otp !== dto.otp) {
      throw new BadRequestException('Invalid OTP');
    }

    return { message: 'OTP verified successfully', verified: true };
  }

  async resetPassword(dto: ResetPasswordDto) {
    // Verify OTP first
    await this.verifyOtp({ email: dto.email, otp: dto.otp });

    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    const hashedPassword = await bcrypt.hash(dto.newPassword, 10);

    await this.prisma.user.update({
      where: { email: dto.email },
      data: { password: hashedPassword },
    });

    // Clear OTP after successful password reset
    this.otpStore.delete(dto.email);

    return { message: 'Password reset successfully' };
  }

  async refreshTokens(userId: string, refreshToken: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || !user.refreshToken) {
      throw new UnauthorizedException('Access denied');
    }

    const refreshTokenMatches = await bcrypt.compare(
      refreshToken,
      user.refreshToken,
    );

    if (!refreshTokenMatches) {
      throw new UnauthorizedException('Access denied');
    }

    const tokens = await this.generateTokens(user.id, user.email, user.role);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return tokens;
  }

  async logout(userId: string) {
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
    return { message: 'Logged out successfully' };
  }

  private async generateTokens(userId: string, email: string, role: string) {
    const payload = { sub: userId, email, role };
    const jwtSecret = this.configService.get<string>('JWT_SECRET');
    const jwtRefreshSecret = this.configService.get<string>('JWT_REFRESH_SECRET');
    const jwtExpiration = this.configService.get<string>('JWT_EXPIRATION') || '15m';
    const jwtRefreshExpiration = this.configService.get<string>('JWT_REFRESH_EXPIRATION') || '7d';

    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, {
        secret: jwtSecret,
        expiresIn: jwtExpiration,
      } as any),
      this.jwtService.signAsync(payload, {
        secret: jwtRefreshSecret,
        expiresIn: jwtRefreshExpiration,
      } as any),
    ]);

    return { accessToken, refreshToken };
  }

  private async updateRefreshToken(userId: string, refreshToken: string) {
    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: hashedRefreshToken },
    });
  }

  private generateOtp(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }
}
