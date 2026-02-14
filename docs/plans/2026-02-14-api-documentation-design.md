# API Documentation Design for service-access-doc

**Date:** 2026-02-14
**Status:** Approved
**Repository:** service-access-doc

## Overview

Design for comprehensive API reference documentation for the Access Control Service gRPC APIs. The documentation will be static Markdown files hosted on GitHub, organized by service/domain.

## Goals

- Provide complete API reference documentation for all Access Control Service APIs
- Serve as the canonical API reference for service consumers
- Include code examples in multiple languages
- Maintain synchronization with proto definitions

## Repository Structure

```
service-access-doc/
├── README.md                    # Project overview, quick links, getting started
├── docs/
│   ├── common/
│   │   └── types.md            # Common message types (Empty, Success, Meta, Pagination)
│   ├── services/
│   │   ├── access-control.md   # Access Control gRPC service documentation
│   │   ├── user-management.md  # User Management gRPC service documentation
│   │   └── ...                 # Additional services as they're defined
│   └── examples/
│       ├── go/                 # Go client code examples
│       └── python/             # Python client code examples
└── CLAUDE.md                   # Repository instructions for Claude Code
```

## Documentation Templates

### Service Documentation Template

Each service in `docs/services/*.md` follows this structure:

1. **Header** - Service name, proto file, package
2. **Overview** - Brief description of service purpose
3. **Service Definition** - Protobuf service definition
4. **Methods** - Each RPC with request/response types and error conditions
5. **Message Types** - Field descriptions for all request/response messages

### Common Types Template

`docs/common/types.md` documents shared types:
- Empty
- Success
- Meta (pagination metadata)
- Pagination (request parameters)

## Code Examples

The `docs/examples/` directory contains practical code samples organized by language and service:

- Complete, runnable code
- Connection/client setup
- Error handling patterns
- Comments explaining each step

## Maintenance & Synchronization

**Synchronization Process:**

1. When proto files change, update the corresponding documentation
2. Commit both proto changes and documentation updates together
3. Tag both repositories with matching versions

**Version Compatibility Table:**

A matrix in README.md maps doc versions to proto versions.

## Implementation Plan

See separate implementation plan created by writing-plans skill.

## Decisions

| Decision | Rationale |
|----------|-----------|
| Static Markdown on GitHub | Simple, no build toolchain, easy collaboration |
| Service-oriented structure | Logical for developers finding specific APIs |
| Manual documentation maintenance | Better explanations and context than auto-generation |
| Common types documented separately | Single source of truth, referenced by all services |
