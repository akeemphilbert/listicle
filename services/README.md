# Services Directory

This directory contains backend microservices and APIs for the Listicle project.

## Structure

Each service should be added as a Git submodule and follow Go best practices with Clean Architecture.

## Adding New Services

Use the Makefile command to add new services:

```bash
make add-service-submodule URL=https://github.com/your-org/service-name NAME=service-name
```

## Planned Services

- **api-gateway**: Central API gateway and load balancer
- **user-service**: User management and authentication
- **content-service**: Content and list management
- **notification-service**: Email and push notifications
- **analytics-service**: Usage analytics and reporting

## Service Guidelines

Each service should follow these conventions:

1. **Clean Architecture** structure with clear separation of concerns
2. **Domain-driven design** principles
3. **Interface-driven development** with dependency injection
4. **Comprehensive testing** using table-driven patterns
5. **OpenTelemetry observability** for tracing and metrics
6. **Proper error handling** with wrapped errors
7. **Docker support** for containerization

## Development

```bash
# Start all services
make dev-services

# Start specific service
cd services/service-name
go run .

# Run tests
go test ./...

# Build service
go build -o bin/ ./...
```

## Docker Integration

Each service should include:
- `Dockerfile` for containerization
- Service definition in root `docker-compose.yml`
- Environment variable configuration
- Health checks and proper logging
