# 📦 STARTER CODE TEMPLATES

This file contains ready-to-use code templates for the backend. Copy these into the appropriate files.

---

## 1. Main App Module (src/app.module.ts)

```typescript
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { CacheModule } from '@nestjs/cache-manager';
import { redisStore } from 'cache-manager-ioredis-yet';

import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { AkaratiModule } from './modules/integrations/akarati/akarati.module';
import { AutomationModule } from './modules/integrations/automation/automation.module';
import { CompanyModule } from './modules/integrations/company/company.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    
    // Rate limiting
    ThrottlerModule.forRoot([{
      ttl: 60000,
      limit: 100,
    }]),
    
    // Caching with Redis
    CacheModule.registerAsync({
      isGlobal: true,
      inject: [ConfigService],
      useFactory: async (config: ConfigService) => ({
        store: await redisStore({
          host: config.get('REDIS_HOST', 'localhost'),
          port: config.get('REDIS_PORT', 6379),
          ttl: 60 * 1000, // 60 seconds default
        }),
      }),
    }),
    
    // Application modules
    PrismaModule,
    AuthModule,
    UsersModule,
    AkaratiModule,
    AutomationModule,
    CompanyModule,
    NotificationsModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}
```

---

## 2. Prisma Module (src/prisma/prisma.module.ts)

```typescript
import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
```

## 3. Prisma Service (src/prisma/prisma.service.ts)

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

---

## 4. Auth Module Files

### auth.module.ts
```typescript
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    UsersModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get('JWT_SECRET'),
        signOptions: {
          expiresIn: config.get('JWT_EXPIRATION', '15m'),
        },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, LocalStrategy],
  exports: [AuthService],
})
export class AuthModule {}
```

### auth.service.ts
```typescript
import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(dto: RegisterDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 12);

    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        password: hashedPassword,
        firstName: dto.firstName,
        lastName: dto.lastName,
        phone: dto.phone,
      },
    });

    const tokens = await this.generateTokens(user.id, user.email);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return {
      user: this.excludePassword(user),
      ...tokens,
    };
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (!user || !user.isActive) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const passwordValid = await bcrypt.compare(dto.password, user.password);
    if (!passwordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const tokens = await this.generateTokens(user.id, user.email);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return {
      user: this.excludePassword(user),
      ...tokens,
    };
  }

  async logout(userId: string) {
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
    return { message: 'Logged out successfully' };
  }

  async refreshTokens(userId: string, refreshToken: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || !user.refreshToken) {
      throw new UnauthorizedException('Access denied');
    }

    const refreshTokenValid = await bcrypt.compare(refreshToken, user.refreshToken);
    if (!refreshTokenValid) {
      throw new UnauthorizedException('Access denied');
    }

    const tokens = await this.generateTokens(user.id, user.email);
    await this.updateRefreshToken(user.id, tokens.refreshToken);

    return tokens;
  }

  private async generateTokens(userId: string, email: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        { sub: userId, email },
        {
          secret: this.configService.get('JWT_SECRET'),
          expiresIn: this.configService.get('JWT_EXPIRATION', '15m'),
        },
      ),
      this.jwtService.signAsync(
        { sub: userId, email },
        {
          secret: this.configService.get('JWT_REFRESH_SECRET'),
          expiresIn: this.configService.get('JWT_REFRESH_EXPIRATION', '7d'),
        },
      ),
    ]);

    return { accessToken, refreshToken };
  }

  private async updateRefreshToken(userId: string, refreshToken: string) {
    const hashedRefreshToken = await bcrypt.hash(refreshToken, 12);
    await this.prisma.user.update({
      where: { id: userId },
      data: { refreshToken: hashedRefreshToken },
    });
  }

  private excludePassword(user: any) {
    const { password, refreshToken, ...result } = user;
    return result;
  }
}
```

### auth.controller.ts
```typescript
import { Controller, Post, Body, UseGuards, Get, Req, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RefreshTokenDto } from './dto/refresh-token.dto';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register a new user' })
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login user' })
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Logout user' })
  async logout(@Req() req) {
    return this.authService.logout(req.user.id);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Refresh access token' })
  async refreshTokens(@Body() dto: RefreshTokenDto) {
    return this.authService.refreshTokens(dto.userId, dto.refreshToken);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current user' })
  async getMe(@Req() req) {
    return req.user;
  }
}
```

### DTOs (src/modules/auth/dto/)

#### register.dto.ts
```typescript
import { IsEmail, IsString, MinLength, IsOptional, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'Password123!' })
  @IsString()
  @MinLength(8)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'Password must contain uppercase, lowercase, and number/special character',
  })
  password: string;

  @ApiProperty({ example: 'John' })
  @IsString()
  @MinLength(2)
  firstName: string;

  @ApiProperty({ example: 'Doe' })
  @IsString()
  @MinLength(2)
  lastName: string;

  @ApiProperty({ example: '+201234567890', required: false })
  @IsOptional()
  @IsString()
  phone?: string;
}
```

#### login.dto.ts
```typescript
import { IsEmail, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'Password123!' })
  @IsString()
  password: string;
}
```

#### refresh-token.dto.ts
```typescript
import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RefreshTokenDto {
  @ApiProperty()
  @IsString()
  userId: string;

  @ApiProperty()
  @IsString()
  refreshToken: string;
}
```

### JWT Strategy (src/modules/auth/strategies/jwt.strategy.ts)
```typescript
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    private prisma: PrismaService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
  }

  async validate(payload: { sub: string; email: string }) {
    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
    });

    if (!user || !user.isActive) {
      throw new UnauthorizedException();
    }

    const { password, refreshToken, ...result } = user;
    return result;
  }
}
```

### JWT Auth Guard (src/modules/auth/guards/jwt-auth.guard.ts)
```typescript
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
```

---

## 5. Akarati Integration Service (src/modules/integrations/akarati/akarati.service.ts)

```typescript
import { Injectable, Logger, HttpException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { PrismaService } from '../../../prisma/prisma.service';

@Injectable()
export class AkaratiService {
  private readonly logger = new Logger(AkaratiService.name);
  private readonly apiClient: AxiosInstance;

  constructor(
    private configService: ConfigService,
    private prisma: PrismaService,
  ) {
    this.apiClient = axios.create({
      baseURL: this.configService.get('AKARATI_API_URL'),
      headers: {
        'Authorization': `Bearer ${this.configService.get('AKARATI_API_KEY')}`,
        'Content-Type': 'application/json',
      },
      timeout: 30000,
    });
  }

  async getProperties(params?: { page?: number; limit?: number; filters?: any }) {
    try {
      const response = await this.apiClient.get('/properties', { params });
      await this.logSync('properties', 'fetch', 'success', response.data.length);
      return response.data;
    } catch (error) {
      this.logger.error(`Failed to fetch properties: ${error.message}`);
      await this.logSync('properties', 'fetch', 'failed', 0, error.message);
      throw new HttpException('Failed to fetch properties from Akarati', 500);
    }
  }

  async getPropertyById(id: string) {
    try {
      const response = await this.apiClient.get(`/properties/${id}`);
      return response.data;
    } catch (error) {
      this.logger.error(`Failed to fetch property ${id}: ${error.message}`);
      throw new HttpException('Property not found', 404);
    }
  }

  async getCustomers(params?: { page?: number; limit?: number }) {
    try {
      const response = await this.apiClient.get('/customers', { params });
      return response.data;
    } catch (error) {
      this.logger.error(`Failed to fetch customers: ${error.message}`);
      throw new HttpException('Failed to fetch customers from Akarati', 500);
    }
  }

  async getTransactions(params?: { startDate?: string; endDate?: string }) {
    try {
      const response = await this.apiClient.get('/transactions', { params });
      return response.data;
    } catch (error) {
      this.logger.error(`Failed to fetch transactions: ${error.message}`);
      throw new HttpException('Failed to fetch transactions from Akarati', 500);
    }
  }

  async syncData() {
    this.logger.log('Starting Akarati data sync...');
    const startTime = Date.now();
    
    try {
      // Sync properties
      const properties = await this.getProperties();
      
      // Sync customers
      const customers = await this.getCustomers();
      
      const duration = Date.now() - startTime;
      this.logger.log(`Akarati sync completed in ${duration}ms`);
      
      return {
        success: true,
        properties: properties.length,
        customers: customers.length,
        duration,
      };
    } catch (error) {
      this.logger.error(`Akarati sync failed: ${error.message}`);
      throw error;
    }
  }

  async handleWebhook(payload: any) {
    this.logger.log(`Received Akarati webhook: ${JSON.stringify(payload)}`);
    
    switch (payload.event) {
      case 'property.created':
      case 'property.updated':
        // Handle property updates
        break;
      case 'customer.created':
      case 'customer.updated':
        // Handle customer updates
        break;
      case 'transaction.created':
        // Handle new transactions
        break;
      default:
        this.logger.warn(`Unknown webhook event: ${payload.event}`);
    }
    
    return { received: true };
  }

  private async logSync(
    integrationType: string,
    operation: string,
    status: string,
    recordsAffected: number,
    errorMessage?: string,
  ) {
    await this.prisma.syncLog.create({
      data: {
        integrationType,
        operation,
        status,
        recordsAffected,
        errorMessage,
        completedAt: new Date(),
      },
    });
  }
}
```

---

## 6. Main Bootstrap (src/main.ts)

```typescript
import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';
import { AppModule } from './app.module';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // Security
  app.use(helmet());
  app.use(compression());
  
  // CORS
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // Global prefix
  const apiPrefix = configService.get('API_PREFIX', 'api/v1');
  app.setGlobalPrefix(apiPrefix);

  // Validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Swagger Documentation
  const swaggerConfig = new DocumentBuilder()
    .setTitle('Mobile ERP API')
    .setDescription('API documentation for Mobile ERP Application')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('Authentication')
    .addTag('Users')
    .addTag('Akarati Integration')
    .addTag('Automation')
    .addTag('Notifications')
    .build();
  
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api/docs', app, document);

  // Start server
  const port = configService.get('PORT', 3000);
  await app.listen(port);
  
  logger.log(`🚀 Application running on: http://localhost:${port}`);
  logger.log(`📚 Swagger docs: http://localhost:${port}/api/docs`);
}

bootstrap();
```

---

## 7. Flutter API Client (lib/core/network/api_client.dart)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String baseUrl = 'http://localhost:3000/api/v1';
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry the request
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(error);
      },
    ));
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      final userId = await _storage.read(key: 'user_id');
      
      if (refreshToken == null || userId == null) return false;
      
      final response = await _dio.post('/auth/refresh', data: {
        'userId': userId,
        'refreshToken': refreshToken,
      });
      
      await _storage.write(key: 'access_token', value: response.data['accessToken']);
      await _storage.write(key: 'refresh_token', value: response.data['refreshToken']);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Generic request methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
```

---

**Use these templates as starting points and customize according to your specific requirements.**
