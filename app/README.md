# 💰 Money Transfer System

A robust and secure digital wallet and money transfer API built with modern backend technologies, featuring OTP-based authentication, real-time transaction processing, and comprehensive security measures.

[![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![AWS](https://img.shields.io/badge/AWS_SNS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/sns/)
[![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=JSON%20web%20tokens&logoColor=white)](https://jwt.io/)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Architecture & Design Patterns](#architecture--design-patterns)
- [API Endpoints](#api-endpoints)
- [Installation & Setup](#installation--setup)
- [Environment Variables](#environment-variables)
- [Project Structure](#project-structure)
- [Skills Demonstrated](#skills-demonstrated)
- [Security Features](#security-features)
- [Database Schema](#database-schema)

---

## 🎯 Overview

This project is a **production-ready** digital wallet and money transfer system that enables users to securely send and receive money. The system implements industry-standard security practices including JWT authentication, OTP verification via SMS, and comprehensive input validation.

### What Makes This Project Special

- **Enterprise-grade Architecture**: Built using NestJS framework following SOLID principles and clean architecture
- **Security-First Approach**: Multi-layer security with JWT tokens, OTP verification, and cryptographic hashing
- **Cloud Integration**: AWS SNS for reliable SMS delivery
- **Type Safety**: Full TypeScript implementation with strict type checking
- **Scalable Design**: Modular architecture ready for horizontal scaling
- **Production Ready**: Includes validation, error handling, guards, and comprehensive testing setup

---

## ✨ Key Features

### 🔐 Authentication & Authorization
- Phone number-based user registration
- OTP verification using AWS SNS (SMS)
- JWT-based authentication with secure token management
- Protected routes using custom authentication guards
- Session management with configurable expiration

### 💳 Wallet Management
- Individual wallet creation for each user
- Real-time balance tracking
- Transaction history
- Wallet locking mechanism for security
- Initial balance allocation

### 💸 Money Transfer
- Two-step transfer process (initiate + verify)
- OTP verification for transaction security
- Real-time balance updates
- Transaction status tracking (pending, completed, failed)
- Atomic operations to prevent race conditions

### 📊 Transaction System
- Complete transaction history
- Sender and receiver tracking
- Transaction status management
- Timestamps for audit trails

---

## 🛠 Technology Stack

### Backend Framework
- **NestJS** - Progressive Node.js framework for building efficient and scalable server-side applications
- **TypeScript** - Strongly typed programming language for enhanced code quality

### Database & ODM
- **MongoDB** - NoSQL database for flexible data storage
- **Mongoose** - Elegant MongoDB object modeling with schema validation

### Authentication & Security
- **JWT (@nestjs/jwt)** - JSON Web Tokens for stateless authentication
- **Crypto (Node.js)** - Built-in cryptographic functionality for OTP hashing
- **Class Validator** - Decorator-based validation for DTOs
- **Class Transformer** - Transform plain objects to class instances

### Cloud Services
- **AWS SDK (@aws-sdk/client-sns)** - Amazon SNS integration for SMS delivery

### Configuration & Environment
- **@nestjs/config** - Configuration module for environment variables
- **dotenv** - Environment variable management

### Code Quality & Testing
- **ESLint** - Code linting and style enforcement
- **Prettier** - Code formatting
- **Jest** - Testing framework
- **Supertest** - HTTP assertion library for E2E testing

### Development Tools
- **pnpm** - Fast, disk space efficient package manager
- **ts-node** - TypeScript execution environment
- **ts-jest** - TypeScript preprocessor for Jest
- **Nest CLI** - NestJS command-line interface

---

## 🏗 Architecture & Design Patterns

### Design Patterns Implemented

1. **Dependency Injection**
   - Leveraging NestJS's powerful DI container
   - Loose coupling between modules
   - Easy testing and maintainability

2. **Repository Pattern**
   - Data access abstraction through Mongoose models
   - Separation of business logic from data persistence

3. **Guard Pattern**
   - Authentication guard for route protection
   - Reusable authorization logic

4. **DTO Pattern**
   - Data Transfer Objects for request/response validation
   - Clear API contracts

5. **Module Pattern**
   - Feature-based module organization
   - Clear separation of concerns
   - Reusable and maintainable code structure

### Project Architecture

```
┌─────────────────────────────────────────────┐
│           API Layer (Controllers)            │
│  - Request validation                        │
│  - Route handling                            │
│  - Guards application                        │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│         Business Logic (Services)            │
│  - Authentication logic                      │
│  - Transfer processing                       │
│  - OTP generation & verification             │
│  - Wallet operations                         │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│        Data Access Layer (Schemas)           │
│  - User schema                               │
│  - Wallet schema                             │
│  - Transaction schema                        │
│  - OTP schema                                │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│             MongoDB Database                 │
└─────────────────────────────────────────────┘

         External Services
┌─────────────────────────────────────────────┐
│              AWS SNS (SMS)                   │
└─────────────────────────────────────────────┘
```

---

## 🚀 API Endpoints

### Authentication Endpoints

```http
POST /auth/register
Content-Type: application/json

{
  "fullName": "John Doe",
  "phone": "+1234567890"
}
```

```http
POST /auth/login
Content-Type: application/json

{
  "phone": "+1234567890"
}
```

```http
POST /auth/verify
Content-Type: application/json

{
  "userId": "user_id",
  "code": "123456",
  "purpose": "login"
}
```

### Wallet Endpoints

```http
GET /wallet/balance
Authorization: Bearer <jwt_token>
```

### Transfer Endpoints

```http
POST /transfer/initiate
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "receiverPhone": "+0987654321",
  "amount": 100
}
```

```http
POST /transfer/verify
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "transactionId": "transaction_id",
  "code": "123456"
}
```

---

## 📦 Installation & Setup

### Prerequisites

- Node.js (v16 or higher)
- pnpm (recommended) or npm
- MongoDB instance (local or cloud)
- AWS Account with SNS configured

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd money
```

### Step 2: Install Dependencies

```bash
pnpm install
```

### Step 3: Configure Environment Variables

Create a `.env` file in the root directory:

```env
# Server Configuration
PORT=3000

# Database
MONGO_URL=mongodb://localhost:27017/money_transfer

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here

# AWS Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

### Step 4: Run the Application

**Development Mode:**
```bash
pnpm run start:dev
```

**Production Mode:**
```bash
pnpm run build
pnpm run start:prod
```

### Step 5: Run Tests

```bash
# Unit tests
pnpm run test

# E2E tests
pnpm run test:e2e

# Test coverage
pnpm run test:cov
```

---

## 🌍 Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `PORT` | Server port number | Yes | - |
| `MONGO_URL` | MongoDB connection string | Yes | - |
| `JWT_SECRET` | Secret key for JWT signing | Yes | - |
| `AWS_REGION` | AWS region for SNS | Yes | us-east-1 |
| `AWS_ACCESS_KEY_ID` | AWS access key | Yes | - |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key | Yes | - |

---

## 📁 Project Structure

```
money/
├── src/
│   ├── auth/                    # Authentication module
│   │   ├── auth.controller.ts   # Auth endpoints
│   │   ├── auth.service.ts      # Auth business logic
│   │   ├── auth.guard.ts        # JWT guard implementation
│   │   ├── auth.module.ts       # Auth module configuration
│   │   └── dto.ts               # Auth DTOs
│   │
│   ├── user/                    # User management module
│   │   ├── user.controller.ts   # User endpoints
│   │   ├── user.service.ts      # User business logic
│   │   ├── user.schema.ts       # User MongoDB schema
│   │   ├── user.module.ts       # User module configuration
│   │   └── dto.ts               # User DTOs
│   │
│   ├── wallet/                  # Wallet management module
│   │   ├── wallet.controller.ts # Wallet endpoints
│   │   ├── wallet.service.ts    # Wallet business logic
│   │   ├── wallet.schema.ts     # Wallet MongoDB schema
│   │   ├── wallet.module.ts     # Wallet module configuration
│   │   └── otp.ts               # Wallet OTP utilities
│   │
│   ├── transfer/                # Money transfer module
│   │   ├── transfer.controller.ts # Transfer endpoints
│   │   ├── transfer.service.ts   # Transfer business logic
│   │   ├── transfer.module.ts    # Transfer module configuration
│   │   └── dto.ts                # Transfer DTOs
│   │
│   ├── transaction/             # Transaction tracking module
│   │   ├── transaction.service.ts # Transaction business logic
│   │   ├── transaction.schema.ts  # Transaction MongoDB schema
│   │   ├── transaction.module.ts  # Transaction module configuration
│   │   └── dto/                   # Transaction DTOs
│   │
│   ├── otp/                     # OTP management module
│   │   ├── otp.service.ts       # OTP generation & verification
│   │   ├── otp.schema.ts        # OTP MongoDB schema
│   │   ├── otp.module.ts        # OTP module configuration
│   │   └── dto.ts               # OTP DTOs
│   │
│   ├── app.module.ts            # Root application module
│   ├── app.controller.ts        # Root controller
│   ├── app.service.ts           # Root service
│   └── main.ts                  # Application entry point
│
├── test/                        # Test files
│   ├── app.e2e-spec.ts          # E2E tests
│   └── jest-e2e.json            # E2E Jest configuration
│
├── .eslintrc.js                 # ESLint configuration
├── .prettierrc                  # Prettier configuration
├── nest-cli.json                # Nest CLI configuration
├── tsconfig.json                # TypeScript configuration
├── tsconfig.build.json          # TypeScript build configuration
├── package.json                 # Project dependencies
└── pnpm-lock.yaml              # Dependency lock file
```

---

## 💡 Skills Demonstrated

### Backend Development
- ✅ **RESTful API Design** - Well-structured endpoints following REST principles
- ✅ **Microservices Architecture** - Modular, scalable application structure
- ✅ **Dependency Injection** - Leveraging NestJS IoC container
- ✅ **Middleware & Guards** - Custom authentication and validation middleware

### TypeScript & JavaScript
- ✅ **Advanced TypeScript** - Interfaces, generics, decorators, and strict typing
- ✅ **Async/Await** - Promise-based asynchronous programming
- ✅ **ES6+ Features** - Modern JavaScript syntax and features
- ✅ **Type Safety** - Compile-time type checking and validation

### Database Management
- ✅ **MongoDB** - NoSQL database design and optimization
- ✅ **Mongoose ODM** - Schema design, validation, and middleware
- ✅ **Data Modeling** - Entity relationships and schema design
- ✅ **Database Indexing** - Performance optimization

### Authentication & Security
- ✅ **JWT Authentication** - Token-based stateless authentication
- ✅ **OTP Implementation** - Two-factor authentication system
- ✅ **Cryptographic Hashing** - Secure data hashing using crypto
- ✅ **Input Validation** - DTO-based validation using class-validator
- ✅ **Authorization Guards** - Role-based access control

### Cloud Services & DevOps
- ✅ **AWS SNS Integration** - Cloud messaging service integration
- ✅ **Environment Configuration** - Multi-environment setup
- ✅ **Error Handling** - Comprehensive error management
- ✅ **Logging** - Application monitoring and debugging

### Software Engineering Best Practices
- ✅ **SOLID Principles** - Clean, maintainable code architecture
- ✅ **Design Patterns** - Repository, Factory, Guard, and Module patterns
- ✅ **Code Organization** - Feature-based modular structure
- ✅ **Version Control** - Git workflow (implied)
- ✅ **Code Quality** - ESLint and Prettier configuration

### Testing
- ✅ **Unit Testing** - Jest test framework setup
- ✅ **E2E Testing** - Supertest integration
- ✅ **Test Coverage** - Code coverage reporting
- ✅ **Test-Driven Development** - Testing infrastructure in place

### API Development
- ✅ **Request Validation** - DTO-based validation pipeline
- ✅ **Response Formatting** - Consistent API responses
- ✅ **Error Handling** - Proper HTTP status codes and error messages
- ✅ **API Documentation** - Clear endpoint specifications

### Performance & Optimization
- ✅ **Async Operations** - Non-blocking I/O operations
- ✅ **Database Optimization** - Efficient queries and indexing
- ✅ **Resource Management** - Connection pooling and timeout handling
- ✅ **Caching Strategy** - Balance updates and timeout considerations

---

## 🔒 Security Features

### 1. Authentication Security
- JWT-based stateless authentication
- Secure token generation and validation
- Configurable token expiration (1 hour default)
- Bearer token implementation

### 2. OTP Security
- Cryptographic hashing using HMAC-SHA256
- Timing-safe comparison to prevent timing attacks
- OTP expiration (10 minutes)
- Single-use OTP tokens
- Purpose-specific OTP validation

### 3. Data Validation
- Input sanitization using class-validator
- DTO-based request validation
- Whitelist validation (strips unknown properties)
- Type transformation and coercion

### 4. Transaction Security
- Two-step verification process
- Atomic operations for balance updates
- Transaction status tracking
- Wallet locking mechanism

### 5. Communication Security
- AWS SNS for secure SMS delivery
- Environment-based configuration
- Secure credential management

---

## 🗄 Database Schema

### User Collection
```typescript
{
  _id: ObjectId,
  fullName: String (required),
  phone: String (required, unique),
  isVerified: Boolean (default: false),
  createdAt: Date,
  updatedAt: Date
}
```

### Wallet Collection
```typescript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  balance: Number (default: 1000),
  isLocked: Boolean (default: false),
  lastTransactionAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

### Transaction Collection
```typescript
{
  _id: ObjectId,
  senderId: ObjectId (ref: User),
  receiverId: ObjectId (ref: User),
  amount: Number (required),
  status: String (enum: ['pending', 'completed', 'failed']),
  otpVerified: Boolean (default: false),
  createdAt: Date,
  updatedAt: Date
}
```

### OTP Collection
```typescript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  hashed_code: String (required),
  purpose: String (required),
  isUsed: Boolean (default: false),
  expiresAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🎓 Learning Outcomes

This project demonstrates proficiency in:

1. **Full-stack Backend Development** - Building production-ready REST APIs
2. **Enterprise Architecture** - Scalable and maintainable code structure
3. **Security Implementation** - Industry-standard security practices
4. **Cloud Integration** - Working with AWS services
5. **Database Design** - Efficient NoSQL schema design
6. **Modern TypeScript** - Advanced language features and best practices
7. **Testing Strategies** - Comprehensive test coverage approach
8. **DevOps Practices** - Environment management and deployment readiness

---

## 📈 Future Enhancements

- [ ] Add transaction fees and commission system
- [ ] Implement transaction limits and daily caps
- [ ] Add webhook notifications for transactions
- [ ] Implement account statement generation
- [ ] Add support for multiple currencies
- [ ] Implement refund and reversal mechanisms
- [ ] Add rate limiting for API endpoints
- [ ] Implement Redis for caching and session management
- [ ] Add support for scheduled/recurring transfers
- [ ] Implement comprehensive audit logging
- [ ] Add Docker containerization
- [ ] Set up CI/CD pipeline
- [ ] Add API documentation using Swagger/OpenAPI
- [ ] Implement GraphQL API alongside REST

---

## 📄 License

This project is licensed under the UNLICENSED license.

---

## 👨‍💻 Author

**Your Name**

A passionate backend developer specializing in Node.js, TypeScript, and cloud-based solutions. This project showcases expertise in building secure, scalable, and production-ready applications using modern technologies and best practices.

---

## 🙏 Acknowledgments

- NestJS team for the amazing framework
- MongoDB for the robust database solution
- AWS for reliable cloud services
- The open-source community for excellent tools and libraries

---

<div align="center">

**Built with ❤️ using NestJS and TypeScript**

[⬆ Back to Top](#-money-transfer-system)

</div>
