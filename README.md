# Listicle Mono-Repo

A pseudo mono-repo structure using Git submodules to manage multiple related projects including Chrome extensions, web applications, and microservices.

## Repository Structure

```
listicle/
├── ui/                          # User interface projects
│   └── listicle-extension/      # Chrome extension (Git submodule)
├── services/                    # Backend services and APIs
│   ├── api-gateway/            # API Gateway (future)
│   ├── user-service/           # User management service (future)
│   └── content-service/        # Content management service (future)
├── docker-compose.yml          # Local development orchestration
├── Makefile                    # Common build and development tasks
├── README.md                   # This file
├── .gitignore                  # Git ignore patterns
└── .gitmodules                 # Git submodule configuration (auto-generated)
```

## Quick Start

### Prerequisites

- Git
- Docker and Docker Compose
- Node.js (for UI projects)
- Go (for service projects)

### Initial Setup

1. **Clone the repository with submodules:**
   ```bash
   git clone --recurse-submodules https://github.com/your-org/listicle.git
   cd listicle
   ```

2. **If you already cloned without submodules:**
   ```bash
   git submodule update --init --recursive
   ```

3. **Initialize the development environment:**
   ```bash
   make init
   ```

4. **Start the development services:**
   ```bash
   make docker-up
   ```

## Development Workflow

### Available Commands

Run `make help` to see all available commands:

```bash
make help                    # Display available commands
make init                    # Initialize submodules and install dependencies
make update                   # Update all submodules to latest
make build                    # Build all projects
make test                     # Run tests across all projects
make clean                    # Clean build artifacts
make docker-up               # Start all services via docker-compose
make docker-down             # Stop all services
make dev-ui                  # Start UI development server
make dev-services            # Start all service development servers
```

### Working with Submodules

#### Adding New Projects

**Add a new UI project:**
```bash
make add-ui-submodule URL=https://github.com/your-org/new-ui-project NAME=new-ui-project
```

**Add a new service:**
```bash
make add-service-submodule URL=https://github.com/your-org/new-service NAME=new-service
```

#### Updating Submodules

```bash
# Update all submodules to their latest commits
make update

# Or manually update specific submodules
cd ui/listicle-extension
git pull origin main
cd ../..
git add ui/listicle-extension
git commit -m "Update listicle-extension submodule"
```

#### Submodule Status

```bash
make submodule-status        # Show submodule status
git submodule status         # Alternative command
```

## Project Details

### UI Projects (`ui/`)

Contains user-facing applications:

- **listicle-extension**: Chrome browser extension for list management
  - Location: `ui/listicle-extension/`
  - Repository: https://github.com/akeemphilbert/listicle-extension (currently empty)
  - Technology: JavaScript/TypeScript, Chrome Extension APIs
  - Status: Placeholder directory ready for submodule conversion when repository has content

### Services (`services/`)

Contains backend microservices and APIs:

- **api-gateway**: Central API gateway (planned)
- **user-service**: User management and authentication (planned)
- **content-service**: Content and list management (planned)

Each service should follow Go best practices with:
- Clean Architecture structure
- Domain-driven design
- Interface-driven development
- Comprehensive testing
- OpenTelemetry observability

### Infrastructure

#### Docker Compose Services

The `docker-compose.yml` provides local development infrastructure:

- **PostgreSQL**: Primary database
- **Redis**: Caching and session storage
- **RabbitMQ**: Message queue for inter-service communication
- **MailHog**: Email testing in development

#### Environment Variables

Create a `.env` file in the root directory for local development:

```env
# Database
DATABASE_URL=postgres://listicle:listicle_dev@localhost:5432/listicle

# Redis
REDIS_URL=redis://localhost:6379

# RabbitMQ
RABBITMQ_URL=amqp://listicle:listicle_dev@localhost:5672

# API Gateway
API_GATEWAY_PORT=8080

# Development
NODE_ENV=development
GO_ENV=development
```

## Architecture Overview

### Service Communication

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Chrome        │    │   Web Apps      │    │   Mobile Apps   │
│   Extension     │    │   (Future)      │    │   (Future)      │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────┴─────────────┐
                    │      API Gateway          │
                    │    (Load Balancer)        │
                    └─────────────┬─────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          │                       │                       │
┌─────────┴───────┐    ┌─────────┴───────┐    ┌─────────┴───────┐
│  User Service   │    │ Content Service │    │  Future Services │
│  (Auth & Users) │    │ (Lists & Items) │    │                 │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────┴─────────────┐
                    │     Shared Infrastructure │
                    │  PostgreSQL | Redis | MQ  │
                    └───────────────────────────┘
```

### Technology Stack

**Frontend (UI):**
- Chrome Extension APIs
- Modern JavaScript/TypeScript
- React/Vue.js (for web apps)

**Backend (Services):**
- Go with Clean Architecture
- PostgreSQL for data persistence
- Redis for caching and sessions
- RabbitMQ for message queuing
- OpenTelemetry for observability

**Infrastructure:**
- Docker & Docker Compose for local development
- Git submodules for code organization
- Make for build automation

## Contributing

### Development Guidelines

1. **Follow Go best practices** for service development
2. **Use Clean Architecture** principles
3. **Write comprehensive tests** with table-driven patterns
4. **Implement proper error handling** with wrapped errors
5. **Add observability** with OpenTelemetry spans and metrics
6. **Document public APIs** with GoDoc comments

### Adding New Services

1. Create a new repository for your service
2. Add it as a submodule: `make add-service-submodule URL=<repo-url> NAME=<service-name>`
3. Follow the Go project structure guidelines
4. Add Docker configuration for the service
5. Update this README with service documentation

### Testing

```bash
# Run all tests
make test

# Run tests for specific project
cd ui/listicle-extension && npm test
cd services/user-service && go test ./...
```

## Troubleshooting

### Submodule Issues

**If submodules appear empty:**
```bash
git submodule update --init --recursive
```

**If you need to update submodule URLs:**
```bash
make submodule-sync
```

**If you need to remove a submodule:**
```bash
git submodule deinit ui/listicle-extension
git rm ui/listicle-extension
rm -rf .git/modules/ui/listicle-extension
```

### Docker Issues

**Reset Docker environment:**
```bash
make docker-down
docker system prune -a
make docker-up
```

**View service logs:**
```bash
make docker-logs
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
