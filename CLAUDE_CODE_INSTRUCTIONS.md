# 🤖 CLAUDE CODE EXECUTION GUIDE

## IMPORTANT: Read This First
This document contains step-by-step instructions for Claude Code to set up and develop the mobile ERP application. Execute commands in order and verify each step before proceeding.

---

## 🔧 STEP 1: ENVIRONMENT CHECK

Run these commands first to verify the development environment:

```bash
# Check Node.js (required: v20+)
node --version

# Check npm
npm --version

# Check Flutter (required: v3.24+)
flutter --version

# Check Docker
docker --version

# Check Git
git --version
```

### If Node.js is NOT installed:
```bash
# macOS (using Homebrew)
brew install node@20

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Windows (using winget)
winget install OpenJS.NodeJS.LTS
```

### If Flutter is NOT installed:
```bash
# macOS
brew install --cask flutter

# Linux - Download from flutter.dev and add to PATH
# Windows - Download from flutter.dev and add to PATH

# After installation
flutter doctor
```

### If Docker is NOT installed:
```bash
# macOS
brew install --cask docker

# Ubuntu
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER

# Windows - Download Docker Desktop from docker.com
```

---

## 🚀 STEP 2: PROJECT INITIALIZATION

```bash
# Create project root
mkdir -p ~/projects/mobile-erp-app
cd ~/projects/mobile-erp-app

# Initialize Git
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.dart_tool/
.packages

# Environment
.env
.env.local
.env.*.local

# Build outputs
build/
dist/
*.js.map

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Flutter
.flutter-plugins
.flutter-plugins-dependencies
*.iml

# Logs
*.log
npm-debug.log*

# Testing
coverage/

# Generated
*.g.dart
*.freezed.dart
EOF

# Create directory structure
mkdir -p backend frontend docs scripts
```

---

## 🖥️ STEP 3: BACKEND SETUP (NestJS)

```bash
cd ~/projects/mobile-erp-app/backend

# Install NestJS CLI
npm install -g @nestjs/cli

# Create NestJS project
nest new . --package-manager npm --skip-git

# Confirm with 'y' if prompted
```

### Install Dependencies:
```bash
# Core packages
npm install @nestjs/config @nestjs/jwt @nestjs/passport
npm install passport passport-jwt passport-local bcryptjs
npm install @prisma/client class-validator class-transformer
npm install helmet compression uuid
npm install @nestjs/swagger swagger-ui-express
npm install @nestjs/bull bull ioredis
npm install @nestjs/cache-manager cache-manager cache-manager-ioredis-yet
npm install axios

# Dev packages
npm install -D prisma
npm install -D @types/passport-jwt @types/passport-local @types/bcryptjs @types/uuid
```

### Initialize Prisma:
```bash
npx prisma init
```

### Create Prisma Schema:
```bash
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum Role {
  ADMIN
  MANAGER
  USER
}

enum NotificationType {
  PUSH
  EMAIL
  SMS
}

model User {
  id              String    @id @default(uuid())
  email           String    @unique
  phone           String?   @unique
  password        String
  firstName       String
  lastName        String
  avatar          String?
  role            Role      @default(USER)
  isActive        Boolean   @default(true)
  isEmailVerified Boolean   @default(false)
  isPhoneVerified Boolean   @default(false)
  refreshToken    String?
  fcmToken        String?
  createdAt       DateTime  @default(now())
  updatedAt       DateTime  @updatedAt
  
  notifications   Notification[]
  auditLogs       AuditLog[]
  sessions        Session[]
}

model Session {
  id          String   @id @default(uuid())
  userId      String
  token       String   @unique
  userAgent   String?
  ipAddress   String?
  expiresAt   DateTime
  createdAt   DateTime @default(now())
  
  user        User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model Notification {
  id        String           @id @default(uuid())
  userId    String
  title     String
  body      String
  type      NotificationType
  data      Json?
  isRead    Boolean          @default(false)
  sentAt    DateTime         @default(now())
  readAt    DateTime?
  
  user      User             @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model AuditLog {
  id         String   @id @default(uuid())
  userId     String
  action     String
  resource   String
  resourceId String?
  oldData    Json?
  newData    Json?
  ipAddress  String?
  userAgent  String?
  createdAt  DateTime @default(now())
  
  user       User     @relation(fields: [userId], references: [id])
}

model IntegrationConfig {
  id          String   @id @default(uuid())
  name        String   @unique
  type        String   // 'akarati', 'automation', 'company'
  baseUrl     String
  apiKey      String?
  isActive    Boolean  @default(true)
  config      Json?
  lastSyncAt  DateTime?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model SyncLog {
  id              String   @id @default(uuid())
  integrationType String
  operation       String
  status          String   // 'success', 'failed', 'partial'
  recordsAffected Int      @default(0)
  errorMessage    String?
  details         Json?
  startedAt       DateTime @default(now())
  completedAt     DateTime?
}
EOF
```

### Generate NestJS Modules:
```bash
# Auth module
nest g module modules/auth
nest g controller modules/auth --no-spec
nest g service modules/auth --no-spec

# Users module
nest g module modules/users
nest g controller modules/users --no-spec
nest g service modules/users --no-spec

# Integration modules
nest g module modules/integrations/akarati
nest g service modules/integrations/akarati --no-spec

nest g module modules/integrations/automation
nest g service modules/integrations/automation --no-spec

nest g module modules/integrations/company
nest g service modules/integrations/company --no-spec

# Notifications module
nest g module modules/notifications
nest g service modules/notifications --no-spec
nest g gateway modules/notifications --no-spec
```

### Create Environment File:
```bash
cat > .env << 'EOF'
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mobile_erp_db

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-min-32-chars!!
JWT_EXPIRATION=15m
JWT_REFRESH_SECRET=your-refresh-token-secret-min-32-chars!!
JWT_REFRESH_EXPIRATION=7d

# Akarati ERP
AKARATI_API_URL=https://api.akarati.com
AKARATI_API_KEY=your-akarati-api-key

# Automation System
AUTOMATION_API_URL=https://automation.company.com
AUTOMATION_API_KEY=your-automation-api-key

# Company System
COMPANY_API_URL=https://internal.company.com
COMPANY_API_KEY=your-company-api-key

# Firebase
FIREBASE_PROJECT_ID=
FIREBASE_PRIVATE_KEY=
FIREBASE_CLIENT_EMAIL=
EOF
```

---

## 📱 STEP 4: FRONTEND SETUP (Flutter)

```bash
cd ~/projects/mobile-erp-app/frontend

# Create Flutter project
flutter create --org com.yourcompany --project-name mobile_erp_app .

# Add dependencies
flutter pub add flutter_bloc equatable dio get_it injectable
flutter pub add flutter_secure_storage hive hive_flutter
flutter pub add go_router cached_network_image json_annotation freezed_annotation
flutter pub add intl connectivity_plus internet_connection_checker
flutter pub add firebase_core firebase_messaging
flutter pub add local_auth flutter_local_notifications
flutter pub add shimmer pull_to_refresh flutter_svg

# Add dev dependencies
flutter pub add --dev build_runner freezed json_serializable
flutter pub add --dev flutter_lints injectable_generator very_good_analysis

# Create folder structure
mkdir -p lib/core/{constants,errors,network,theme,utils,extensions}
mkdir -p lib/config
mkdir -p lib/features/auth/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/dashboard/{data,domain,presentation/{bloc,pages,widgets}}
mkdir -p lib/features/properties/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/automation/{data,domain,presentation/{bloc,pages,widgets}}
mkdir -p lib/features/notifications/{data,domain,presentation/{bloc,pages,widgets}}
mkdir -p lib/features/settings/{presentation/{pages,widgets}}
mkdir -p lib/shared/{widgets,models,extensions}
mkdir -p assets/{images,fonts,icons,animations}
```

### Update pubspec.yaml assets:
```bash
# Add to pubspec.yaml under flutter section:
# assets:
#   - assets/images/
#   - assets/fonts/
#   - assets/icons/
#   - assets/animations/
```

---

## 🐳 STEP 5: DOCKER SETUP

```bash
cd ~/projects/mobile-erp-app

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: erp_api
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/mobile_erp_db
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./backend:/app
      - /app/node_modules
    networks:
      - erp_network

  db:
    image: postgres:16-alpine
    container_name: erp_postgres
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: mobile_erp_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - erp_network

  redis:
    image: redis:7-alpine
    container_name: erp_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - erp_network

  adminer:
    image: adminer:latest
    container_name: erp_adminer
    ports:
      - "8080:8080"
    depends_on:
      - db
    networks:
      - erp_network

networks:
  erp_network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
EOF

# Create Dockerfile for backend
cat > backend/Dockerfile << 'EOF'
FROM node:20-alpine

WORKDIR /app

# Install dependencies for native modules
RUN apk add --no-cache python3 make g++

COPY package*.json ./
RUN npm ci

COPY . .

# Generate Prisma client
RUN npx prisma generate

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
EOF

# Create .dockerignore
cat > backend/.dockerignore << 'EOF'
node_modules
npm-debug.log
dist
.git
.env.local
EOF
```

---

## ▶️ STEP 6: START DEVELOPMENT

```bash
# Start Docker containers
cd ~/projects/mobile-erp-app
docker-compose up -d

# Wait for database to be ready, then run migrations
cd backend
npx prisma migrate dev --name init

# Generate Prisma client
npx prisma generate

# Seed database (optional)
npx prisma db seed

# Start backend server
npm run start:dev
```

### In a new terminal:
```bash
# Start Flutter app
cd ~/projects/mobile-erp-app/frontend
flutter pub get
flutter run
```

---

## ✅ VERIFICATION CHECKLIST

After setup, verify:

1. [ ] `docker ps` shows 4 containers running (api, db, redis, adminer)
2. [ ] Backend API accessible at http://localhost:3000
3. [ ] Swagger docs at http://localhost:3000/api/docs
4. [ ] Adminer (DB UI) at http://localhost:8080
5. [ ] Flutter app runs on emulator/device

---

## 🔄 DAILY DEVELOPMENT COMMANDS

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop all services
docker-compose down

# Rebuild after changes
docker-compose up -d --build

# Run Flutter
cd frontend && flutter run

# Run tests
cd backend && npm run test
cd frontend && flutter test

# Generate code (Flutter)
cd frontend && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📝 NOTES FOR CLAUDE CODE

1. **Always check environment first** - Run verification commands before proceeding
2. **Execute commands sequentially** - Wait for each command to complete
3. **Handle errors gracefully** - If a command fails, diagnose and fix before continuing
4. **Keep .env secure** - Never commit actual API keys
5. **Test after each major step** - Verify functionality before moving on

---

**Ready to execute? Start with STEP 1 and proceed sequentially.**
