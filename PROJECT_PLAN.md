# 🚀 Mobile Application Project - Full Stack Cross-Platform

## Project Overview
A comprehensive cross-platform mobile application with ERP integrations, automation systems, and company-specific system connections.

---

# 📋 TABLE OF CONTENTS
1. [Tech Stack Recommendation](#tech-stack-recommendation)
2. [Project Architecture](#project-architecture)
3. [Infrastructure Plan](#infrastructure-plan)
4. [Requirements Document](#requirements-document)
5. [Claude Code Setup Instructions](#claude-code-setup-instructions)
6. [Development Phases](#development-phases)

---

# 🛠 TECH STACK RECOMMENDATION

## Frontend (Mobile)
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.24+ | Cross-platform mobile framework |
| **Dart** | 3.5+ | Programming language |
| **flutter_bloc** | 8.1+ | State management |
| **dio** | 5.4+ | HTTP client for API calls |
| **get_it** | 7.6+ | Dependency injection |
| **hive** | 2.2+ | Local storage |
| **flutter_secure_storage** | 9.0+ | Secure credentials storage |

## Backend (Recommended: Node.js)
| Technology | Version | Purpose |
|------------|---------|---------|
| **Node.js** | 20 LTS | Runtime environment |
| **NestJS** | 10+ | Backend framework (scalable & enterprise-ready) |
| **TypeScript** | 5.3+ | Type-safe JavaScript |
| **Prisma** | 5.10+ | ORM for database |
| **PostgreSQL** | 16+ | Primary database |
| **Redis** | 7+ | Caching & session management |
| **Bull** | 4+ | Job queues for background tasks |

### Why Node.js over Laravel for this project?
1. **Real-time capabilities**: Better WebSocket support for live updates
2. **TypeScript**: Full-stack type safety with Flutter/Dart
3. **Performance**: Non-blocking I/O ideal for multiple ERP integrations
4. **Microservices ready**: Easier to scale individual services
5. **NPM ecosystem**: Rich packages for ERP/API integrations

## Infrastructure & DevOps
| Technology | Purpose |
|------------|---------|
| **Docker** | Containerization |
| **Docker Compose** | Local development orchestration |
| **Nginx** | Reverse proxy & load balancer |
| **GitHub Actions** | CI/CD pipeline |
| **AWS/DigitalOcean** | Cloud hosting |

## Integration Layer
| Technology | Purpose |
|------------|---------|
| **Axios** | HTTP client for external APIs |
| **node-cron** | Scheduled tasks |
| **webhooks** | Real-time data sync |
| **Message Queue (RabbitMQ/Redis)** | Async processing |

---

# 🏗 PROJECT ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────┐
│                        MOBILE APP (Flutter)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │   UI     │  │  BLoC    │  │Repository│  │  Data Sources    │ │
│  │  Layer   │──│  State   │──│  Layer   │──│  (API/Local)     │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │ HTTPS/WSS
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY (Nginx)                         │
│                   Load Balancer / Rate Limiter                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND (NestJS + Node.js)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │Controllers│  │ Services │  │  Guards  │  │   Integrations   │ │
│  │  (REST)  │──│ (Business│──│  (Auth)  │──│   Module         │ │
│  └──────────┘  │  Logic)  │  └──────────┘  └──────────────────┘ │
│                └──────────┘                                      │
└─────────────────────────────────────────────────────────────────┘
         │              │                    │
         ▼              ▼                    ▼
┌──────────────┐ ┌────────────┐  ┌─────────────────────────────────┐
│  PostgreSQL  │ │   Redis    │  │      EXTERNAL INTEGRATIONS      │
│  (Primary DB)│ │  (Cache)   │  │  ┌─────────┐ ┌───────────────┐  │
└──────────────┘ └────────────┘  │  │Akarati  │ │  Automation   │  │
                                 │  │  ERP    │ │    System     │  │
                                 │  └─────────┘ └───────────────┘  │
                                 │  ┌─────────────────────────────┐│
                                 │  │   Company Internal System   ││
                                 │  └─────────────────────────────┘│
                                 └─────────────────────────────────┘
```

## Folder Structure

### Backend (NestJS)
```
backend/
├── src/
│   ├── main.ts
│   ├── app.module.ts
│   ├── common/
│   │   ├── decorators/
│   │   ├── filters/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   └── pipes/
│   ├── config/
│   │   ├── database.config.ts
│   │   ├── redis.config.ts
│   │   └── app.config.ts
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.module.ts
│   │   │   ├── dto/
│   │   │   ├── guards/
│   │   │   └── strategies/
│   │   ├── users/
│   │   │   ├── users.controller.ts
│   │   │   ├── users.service.ts
│   │   │   ├── users.module.ts
│   │   │   ├── dto/
│   │   │   └── entities/
│   │   ├── integrations/
│   │   │   ├── akarati/
│   │   │   │   ├── akarati.service.ts
│   │   │   │   ├── akarati.module.ts
│   │   │   │   └── dto/
│   │   │   ├── automation/
│   │   │   │   ├── automation.service.ts
│   │   │   │   ├── automation.module.ts
│   │   │   │   └── dto/
│   │   │   └── company-system/
│   │   │       ├── company.service.ts
│   │   │       ├── company.module.ts
│   │   │       └── dto/
│   │   └── notifications/
│   │       ├── notifications.service.ts
│   │       ├── notifications.module.ts
│   │       └── notifications.gateway.ts (WebSocket)
│   └── prisma/
│       ├── schema.prisma
│       └── migrations/
├── test/
├── docker-compose.yml
├── Dockerfile
├── .env.example
├── package.json
└── tsconfig.json
```

### Frontend (Flutter)
```
mobile_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   └── route_constants.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── api_interceptors.dart
│   │   │   └── network_info.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── helpers.dart
│   ├── config/
│   │   ├── routes.dart
│   │   └── injection.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   ├── dashboard/
│   │   ├── properties/ (Akarati integration)
│   │   ├── automation/
│   │   ├── reports/
│   │   └── settings/
│   └── shared/
│       ├── widgets/
│       └── models/
├── assets/
│   ├── images/
│   ├── fonts/
│   └── icons/
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

---

# 🏢 INFRASTRUCTURE PLAN

## Development Environment
```yaml
Local Development:
  - Docker Desktop
  - VS Code with Flutter & Dart extensions
  - Node.js 20 LTS
  - PostgreSQL (via Docker)
  - Redis (via Docker)
  - Android Studio / Xcode for emulators
```

## Staging Environment
```yaml
Staging:
  Provider: DigitalOcean / AWS
  Services:
    - App Server: 2 vCPU, 4GB RAM (NestJS)
    - Database: Managed PostgreSQL (1GB)
    - Cache: Managed Redis (1GB)
    - Storage: S3/Spaces for files
```

## Production Environment
```yaml
Production:
  Provider: AWS / DigitalOcean / Azure
  Services:
    - Load Balancer: Nginx / AWS ALB
    - App Servers: 2x (4 vCPU, 8GB RAM) - Auto-scaling
    - Database: Managed PostgreSQL (4GB, read replicas)
    - Cache: Managed Redis Cluster (2GB)
    - Storage: S3 with CDN
    - Monitoring: Prometheus + Grafana
    - Logging: ELK Stack / CloudWatch
```

## Docker Compose (Development)
```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app_db
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./backend:/app
      - /app/node_modules

  db:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: app_db
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  adminer:
    image: adminer
    ports:
      - "8080:8080"

volumes:
  postgres_data:
  redis_data:
```

---

# 📄 REQUIREMENTS DOCUMENT

## Functional Requirements

### 1. Authentication & Authorization
| ID | Requirement | Priority |
|----|-------------|----------|
| AUTH-01 | User registration with email/phone verification | High |
| AUTH-02 | Login with email/phone + password | High |
| AUTH-03 | Social login (Google, Apple) | Medium |
| AUTH-04 | JWT-based authentication with refresh tokens | High |
| AUTH-05 | Role-based access control (RBAC) | High |
| AUTH-06 | Biometric authentication (fingerprint/face) | Medium |
| AUTH-07 | Password reset via email/SMS | High |

### 2. User Management
| ID | Requirement | Priority |
|----|-------------|----------|
| USER-01 | User profile management | High |
| USER-02 | Profile picture upload | Medium |
| USER-03 | User preferences settings | Medium |
| USER-04 | Activity history | Low |

### 3. Akarati ERP Integration
| ID | Requirement | Priority |
|----|-------------|----------|
| AKA-01 | Sync property listings from Akarati | High |
| AKA-02 | Real-time inventory updates | High |
| AKA-03 | Customer data synchronization | High |
| AKA-04 | Transaction history sync | Medium |
| AKA-05 | Document management integration | Medium |
| AKA-06 | Financial reports from ERP | Medium |

### 4. Automation System Integration
| ID | Requirement | Priority |
|----|-------------|----------|
| AUTO-01 | Trigger automated workflows | High |
| AUTO-02 | Receive automation status updates | High |
| AUTO-03 | Configure automation rules | Medium |
| AUTO-04 | Automation logs and history | Medium |
| AUTO-05 | Error handling and notifications | High |

### 5. Company System Integration
| ID | Requirement | Priority |
|----|-------------|----------|
| COMP-01 | Employee data sync | High |
| COMP-02 | Internal communications | Medium |
| COMP-03 | Task management integration | Medium |
| COMP-04 | Calendar sync | Low |
| COMP-05 | Document access | Medium |

### 6. Notifications
| ID | Requirement | Priority |
|----|-------------|----------|
| NOT-01 | Push notifications (FCM/APNs) | High |
| NOT-02 | In-app notifications | High |
| NOT-03 | Email notifications | Medium |
| NOT-04 | SMS notifications | Medium |
| NOT-05 | Notification preferences | Medium |

### 7. Offline Support
| ID | Requirement | Priority |
|----|-------------|----------|
| OFF-01 | Offline data caching | Medium |
| OFF-02 | Sync when online | Medium |
| OFF-03 | Conflict resolution | Medium |

## Non-Functional Requirements

### Performance
- API response time: < 200ms for 95th percentile
- App launch time: < 3 seconds
- Support 10,000+ concurrent users

### Security
- All data encrypted in transit (TLS 1.3)
- Sensitive data encrypted at rest
- OWASP security standards compliance
- Regular security audits

### Scalability
- Horizontal scaling capability
- Database read replicas
- CDN for static assets

### Availability
- 99.9% uptime SLA
- Automated failover
- Regular backups

---

# 🤖 CLAUDE CODE SETUP INSTRUCTIONS

## Pre-requisites Check Script

Create and run this script to check/install required tools:

```bash
#!/bin/bash
# File: setup_check.sh

echo "🔍 Checking development environment..."

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo "✅ Node.js installed: $NODE_VERSION"
else
    echo "❌ Node.js not found. Installing..."
    # For macOS
    brew install node@20
    # For Ubuntu/Debian
    # curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    # sudo apt-get install -y nodejs
fi

# Check Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "✅ Flutter installed: $FLUTTER_VERSION"
else
    echo "❌ Flutter not found. Please install from https://flutter.dev"
fi

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "✅ Docker installed: $DOCKER_VERSION"
else
    echo "❌ Docker not found. Please install Docker Desktop"
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo "✅ Git installed: $GIT_VERSION"
else
    echo "❌ Git not found. Installing..."
    brew install git
fi

echo "✅ Environment check complete!"
```

## Step-by-Step Setup Commands for Claude Code

### Phase 1: Project Initialization

```bash
# Create project root directory
mkdir -p mobile-erp-app && cd mobile-erp-app

# Initialize Git repository
git init
echo "node_modules/\n.env\n*.log\nbuild/\n.dart_tool/\n.flutter-plugins" > .gitignore

# Create directory structure
mkdir -p backend frontend docs scripts
```

### Phase 2: Backend Setup (NestJS)

```bash
# Navigate to backend directory
cd backend

# Install NestJS CLI globally
npm install -g @nestjs/cli

# Create new NestJS project
nest new . --package-manager npm --skip-git

# Install core dependencies
npm install @nestjs/config @nestjs/jwt @nestjs/passport passport passport-jwt passport-local
npm install @prisma/client class-validator class-transformer
npm install bcryptjs helmet compression
npm install @nestjs/swagger swagger-ui-express
npm install @nestjs/bull bull
npm install ioredis @nestjs/cache-manager cache-manager cache-manager-ioredis-yet

# Install dev dependencies
npm install -D prisma @types/passport-jwt @types/passport-local @types/bcryptjs
npm install -D @types/node typescript ts-node

# Initialize Prisma
npx prisma init

# Generate NestJS modules
nest generate module modules/auth
nest generate controller modules/auth
nest generate service modules/auth

nest generate module modules/users
nest generate controller modules/users
nest generate service modules/users

nest generate module modules/integrations/akarati
nest generate service modules/integrations/akarati

nest generate module modules/integrations/automation
nest generate service modules/integrations/automation

nest generate module modules/integrations/company-system
nest generate service modules/integrations/company-system

nest generate module modules/notifications
nest generate service modules/notifications
nest generate gateway modules/notifications
```

### Phase 3: Frontend Setup (Flutter)

```bash
# Navigate to frontend directory
cd ../frontend

# Create Flutter project
flutter create --org com.yourcompany --project-name mobile_erp_app .

# Add dependencies to pubspec.yaml
flutter pub add flutter_bloc dio get_it injectable
flutter pub add flutter_secure_storage hive hive_flutter
flutter pub add go_router cached_network_image
flutter pub add json_annotation freezed_annotation
flutter pub add intl connectivity_plus
flutter pub add firebase_core firebase_messaging
flutter pub add local_auth

# Add dev dependencies
flutter pub add --dev build_runner freezed json_serializable
flutter pub add --dev flutter_lints injectable_generator

# Create feature directories
mkdir -p lib/core/{constants,errors,network,theme,utils}
mkdir -p lib/config
mkdir -p lib/features/{auth,dashboard,properties,automation,reports,settings}/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/shared/{widgets,models}
mkdir -p assets/{images,fonts,icons}
```

### Phase 4: Docker Setup

```bash
# Navigate back to project root
cd ..

# Create Docker files
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app_db
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=your-super-secret-jwt-key
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./backend:/app
      - /app/node_modules

  db:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: app_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  adminer:
    image: adminer
    ports:
      - "8080:8080"

volumes:
  postgres_data:
  redis_data:
EOF

# Create Backend Dockerfile
cat > backend/Dockerfile << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npx prisma generate

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
EOF
```

### Phase 5: Environment Configuration

```bash
# Create environment files
cat > backend/.env.example << 'EOF'
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/app_db

# Redis
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRATION=15m
JWT_REFRESH_EXPIRATION=7d

# Akarati ERP Integration
AKARATI_API_URL=https://api.akarati.com
AKARATI_API_KEY=your-akarati-api-key
AKARATI_WEBHOOK_SECRET=your-webhook-secret

# Automation System Integration
AUTOMATION_API_URL=https://automation.yourcompany.com
AUTOMATION_API_KEY=your-automation-api-key

# Company System Integration
COMPANY_API_URL=https://internal.yourcompany.com
COMPANY_API_KEY=your-company-api-key

# Firebase (for push notifications)
FIREBASE_PROJECT_ID=your-firebase-project
FIREBASE_PRIVATE_KEY=your-firebase-private-key
FIREBASE_CLIENT_EMAIL=your-firebase-client-email

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# SMS (Twilio example)
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
TWILIO_PHONE_NUMBER=+1234567890
EOF

cp backend/.env.example backend/.env
```

---

# 📅 DEVELOPMENT PHASES

## Phase 1: Foundation (Week 1-2)
- [x] Project setup and configuration
- [ ] Database schema design
- [ ] Authentication module (JWT)
- [ ] User management module
- [ ] Basic Flutter app structure
- [ ] API client setup in Flutter

## Phase 2: Core Features (Week 3-4)
- [ ] Complete auth flow (login, register, forgot password)
- [ ] Dashboard module
- [ ] User profile management
- [ ] Push notifications setup
- [ ] Offline storage implementation

## Phase 3: Integrations (Week 5-7)
- [ ] Akarati ERP integration
  - [ ] API connection setup
  - [ ] Data sync services
  - [ ] Webhook handlers
- [ ] Automation system integration
- [ ] Company system integration

## Phase 4: Advanced Features (Week 8-9)
- [ ] Real-time updates (WebSocket)
- [ ] Advanced reporting
- [ ] File management
- [ ] Search functionality

## Phase 5: Testing & Optimization (Week 10-11)
- [ ] Unit tests
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Security audit

## Phase 6: Deployment (Week 12)
- [ ] CI/CD pipeline setup
- [ ] Staging deployment
- [ ] Production deployment
- [ ] Monitoring setup

---

# 🎯 QUICK START COMMANDS

```bash
# Clone and setup (after project is initialized)
git clone <repository-url>
cd mobile-erp-app

# Start backend services
docker-compose up -d

# Run database migrations
cd backend && npx prisma migrate dev

# Start backend in development mode
npm run start:dev

# In another terminal, start Flutter app
cd frontend
flutter pub get
flutter run
```

---

# 📞 INTEGRATION API SPECIFICATIONS

## Akarati ERP Expected Endpoints
```
GET    /api/properties          - List all properties
GET    /api/properties/:id      - Get property details
POST   /api/properties          - Create property
PUT    /api/properties/:id      - Update property
GET    /api/customers           - List customers
GET    /api/transactions        - List transactions
POST   /webhooks/property-update - Webhook for updates
```

## Automation System Expected Endpoints
```
GET    /api/workflows           - List workflows
POST   /api/workflows/:id/trigger - Trigger workflow
GET    /api/workflows/:id/status  - Get workflow status
POST   /webhooks/automation     - Automation events webhook
```

## Company System Expected Endpoints
```
GET    /api/employees           - List employees
GET    /api/departments         - List departments
GET    /api/tasks               - List tasks
POST   /api/tasks               - Create task
```

---

**Document Version:** 1.0
**Last Updated:** 2025
**Author:** AI Assistant
