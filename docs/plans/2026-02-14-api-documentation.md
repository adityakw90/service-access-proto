# API Documentation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create comprehensive API reference documentation for the Access Control Service gRPC APIs in a new service-access-doc repository.

**Architecture:** Static Markdown files on GitHub, organized by service/domain with common types documented separately and referenced from each service.

**Tech Stack:** Markdown, Git, GitHub Pages (optional)

---

## Prerequisites

1. Create new repository `service-access-doc` in the workspace
2. Ensure `service-access-proto` repository is accessible for reference

---

## Task 1: Create service-access-doc Repository Structure

**Files:**
- Create: `service-access-doc/README.md`
- Create: `service-access-doc/docs/common/types.md`
- Create: `service-access-doc/docs/services/.gitkeep`
- Create: `service-access-doc/docs/examples/go/README.md`
- Create: `service-access-doc/docs/examples/python/README.md`
- Create: `service-access-doc/CLAUDE.md`
- Create: `service-access-doc/.gitignore`

**Step 1: Create repository directory and initialize**

```bash
cd /media/adit/SSD/project/MTAmedia/repo/service-access
mkdir service-access-doc
cd service-access-doc
git init
```

**Step 2: Create README.md**

```markdown
# Access Control Service API Documentation

Official API reference documentation for the Access Control Service gRPC APIs.

## Quick Links

- [Common Types](docs/common/types.md) - Shared message types (Pagination, Meta, etc.)
- [Access Control Service](docs/services/access-control.md) - Resource and permission management
- [User Management Service](docs/services/user-management.md) - User CRUD operations

## Code Examples

- [Go Examples](docs/examples/go/README.md)
- [Python Examples](docs/examples/python/README.md)

## Getting Started

### Prerequisites

- gRPC tools for your language
- Access to the Access Control Service endpoint

### Installation

\`\`\`bash
# Go
go get github.com/adityakw90/service-access-proto

# Python
pip install service-access-proto
\`\`\`

## Version Compatibility

| Doc Version | Proto Version | Notes |
|-------------|---------------|-------|
| v1.0.0      | v1.0.0        | Initial release |

## Repository Structure

This repository is part of the Access Control Service workspace:

- \`service-access-proto\` - Protocol Buffer definitions
- \`service-access-doc\` - This documentation repository
- \`service-access\` - Service implementation (separate repo)

## Support

For questions or issues, please file a bug in the issue tracker.
```

**Step 3: Create .gitignore**

```text
# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Temporary
*.tmp
*.bak
```

**Step 4: Create CLAUDE.md**

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **service-access-doc** repository, part of a multi-repository workspace for the Access Control Service. This repository contains **API reference documentation** for the gRPC services defined in service-access-proto.

## Documentation Structure

- \`docs/common/types.md\` - Shared message types documentation
- \`docs/services/*.md\` - Individual service documentation
- \`docs/examples/\` - Code examples in multiple languages

## Key Principles

1. **Keep in sync with proto definitions** - When service-access-proto changes, update documentation
2. **Use consistent templates** - All service docs follow the same structure
3. **Include practical examples** - Show, don't just tell
4. **Version align** - Tag releases to match service-access-proto versions

## Related Repositories

- \`../service-access-proto\` - Protocol Buffer definitions
- \`../service-access\` - Service implementation (when created)
```

**Step 5: Create directory structure**

```bash
mkdir -p docs/common
mkdir -p docs/services
mkdir -p docs/examples/go
mkdir -p docs/examples/python
touch docs/services/.gitkeep
```

**Step 6: Create docs/examples/go/README.md**

```markdown
# Go Code Examples

This directory contains Go examples for using the Access Control Service.

## Prerequisites

\`\`\`bash
go get github.com/adityakw90/service-access-proto
go get google.golang.org/grpc
\`\`\`

## Examples

- [Create Resource](access-control/create-resource.go) - Creating a new resource
- [Check Permission](access-control/check-permission.go) - Checking user permissions

## Running Examples

\`\`\`bash
go run access-control/create-resource.go
\`\`\`
```

**Step 7: Create docs/examples/python/README.md**

```markdown
# Python Code Examples

This directory contains Python examples for using the Access Control Service.

## Prerequisites

\`\`\`bash
pip install grpcio
pip install service-access-proto
\`\`\`

## Examples

Coming soon...
```

**Step 8: Initialize git and commit**

```bash
git add .
git commit -m "feat: initial repository structure"
```

---

## Task 2: Document Common Types

**Files:**
- Create: `service-access-doc/docs/common/types.md`

**Step 1: Read proto common types for reference**

```bash
cat ../service-access-proto/proto/common.proto
```

**Step 2: Create docs/common/types.md**

```markdown
# Common Types

This document describes message types shared across all Access Control Service APIs.

## Overview

These common message types are used across multiple services. When you see a reference to these types in service documentation, refer to this document for field details.

## Contents

- [Empty](#empty)
- [Success](#success)
- [Meta](#meta)
- [Pagination](#pagination)

---

## Empty

An empty message used for requests or responses that require no payload.

**Proto Definition:**

\`\`\`protobuf
message Empty {}
\`\`\`

**Usage:**
- RPC methods that don't require input parameters
- RPC methods that only return a success/failure status

---

## Success

A simple success boolean response.

**Proto Definition:**

\`\`\`protobuf
message Success {
  bool success = 1;
}
\`\`\`

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| success | bool | \`true\` if the operation succeeded, \`false\` otherwise |

**Usage:**
- RPC methods that only need to indicate success/failure
- Simple operations that don't return additional data

---

## Meta

Pagination response metadata containing information about the total number of items and pages.

**Proto Definition:**

\`\`\`protobuf
message Meta {
  int32 page = 1;  // The current page of result
  int32 limit = 2;  // The number of items per page
  int64 total = 3;  // The total number of items available
  int32 pages = 4;  // The total number of pages available
\`\`\`

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| page | int32 | The current page number (1-indexed) |
| limit | int32 | The number of items per page |
| total | int64 | The total number of items available across all pages |
| pages | int32 | The total number of pages available |

**Usage:**
- Response messages for paginated list operations
- Use with \`Pagination\` message for complete pagination support

---

## Pagination

Standard pagination request parameters for list operations.

**Proto Definition:**

\`\`\`protobuf
message Pagination {
  int32 page = 1;         // The page number to retrieve
  int32 limit = 2;        // The number of items per page
  string order_by = 3;    // what field to use for ordering
  string sort = 4;        // asc or desc
}
\`\`\`

**Fields:**

| Field | Type | Description |
|-------|------|-------------|
| page | int32 | The page number to retrieve (1-indexed, default: 1) |
| limit | int32 | The number of items per page (default: 10, max: 100) |
| order_by | string | The field name to sort results by (e.g., "created_at", "name") |
| sort | string | Sort direction: \`"asc"\` for ascending, \`"desc"\` for descending |

**Usage:**
- Request messages for paginated list operations
- Combine with \`Meta\` message for complete pagination

**Example:**

To get the second page of results, sorted by name in descending order:

\`\`\`json
{
  "page": 2,
  "limit": 25,
  "order_by": "name",
  "sort": "desc"
}
\`\`\`

## Related Services

All services that support list operations use \`Pagination\` and \`Meta\`:

- [User Management Service](../services/user-management.md#list-users)
- [Access Control Service](../services/access-control.md#list-resources)
```

**Step 3: Commit**

```bash
git add docs/common/types.md
git commit -m "docs: add common types documentation"
```

---

## Task 3: Create Access Control Service Documentation

**Files:**
- Create: `service-access-doc/docs/services/access-control.md`

**Step 1: Create access-control.md template**

```markdown
# Access Control Service

**Protocol:** gRPC
**Proto File:** `access-control.proto`
**Package:** `accesscontrol`

## Overview

The Access Control Service manages resource definitions and permission checks for the Access Control system. It provides APIs for creating, reading, updating, and deleting resources, as well as checking user permissions.

## Service Definition

\`\`\`protobuf
service AccessControl {
  rpc CreateResource(CreateResourceRequest) returns (CreateResourceResponse);
  rpc GetResource(GetResourceRequest) returns (GetResourceResponse);
  rpc UpdateResource(UpdateResourceRequest) returns (UpdateResourceResponse);
  rpc DeleteResource(DeleteResourceRequest) returns (Success);
  rpc ListResources(ListResourcesRequest) returns (ListResourcesResponse);
  rpc CheckPermission(CheckPermissionRequest) returns (CheckPermissionResponse);
}
\`\`\`

## Methods

### CreateResource

**CreateResourceRequest** → **CreateResourceResponse**

Creates a new resource with the specified permissions.

**Request Message:** \`CreateResourceRequest\`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | Yes | Unique name/identifier for the resource |
| type | string | Yes | Type/category of the resource (e.g., "database", "api") |
| description | string | No | Human-readable description |
| permissions | repeated string | Yes | List of permissions available on this resource |

**Response Message:** \`CreateResourceResponse\`

| Field | Type | Description |
|-------|------|-------------|
| resource | Resource | The created resource with populated ID |
| ... | ... | ... |

**Errors:**
- \`AlreadyExists\` - A resource with this name already exists
- \`InvalidArgument\` - Required fields are missing or invalid
- \`PermissionDenied\` - Caller lacks permission to create resources

---

### GetResource

**GetResourceRequest** → **GetResourceResponse**

Retrieves a single resource by ID or name.

**Request Message:** \`GetResourceRequest\`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| resource_id | string | Yes* | ID of the resource |
| name | string | Yes* | Name of the resource |
| ... | ... | ... | ... |

*Either \`resource_id\` or \`name\` must be provided.

**Response Message:** \`GetResourceResponse\`

| Field | Type | Description |
|-------|------|-------------|
| resource | Resource | The requested resource |
| ... | ... | ... |

**Errors:**
- \`NotFound\` - Resource does not exist
- \`InvalidArgument\` - Neither resource_id nor name provided

---

## Message Types

### Resource

Represents a resource in the access control system.

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique identifier (auto-generated) |
| name | string | Unique name/identifier |
| type | string | Resource type |
| description | string | Human-readable description |
| permissions | repeated string | Available permissions |
| created_at | int64 | Creation timestamp (Unix epoch) |
| updated_at | int64 | Last update timestamp (Unix epoch) |

## See Also

- [Common Types](../common/types.md) - Pagination, Meta, Success
- [User Management Service](./user-management.md) - User and role management
```

**Step 2: Commit**

```bash
git add docs/services/access-control.md
git commit -m "docs: add Access Control Service documentation"
```

---

## Task 4: Create User Management Service Documentation

**Files:**
- Create: `service-access-doc/docs/services/user-management.md`

**Step 1: Create user-management.md**

```markdown
# User Management Service

**Protocol:** gRPC
**Proto File:** `user-management.proto`
**Package:** `usermanagement`

## Overview

The User Management Service handles user accounts, roles, and role assignments. It provides CRUD operations for users and roles, as well as APIs for managing role memberships.

## Service Definition

\`\`\`protobuf
service UserManagement {
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc UpdateUser(UpdateUserRequest) returns (UpdateUserResponse);
  rpc DeleteUser(DeleteUserRequest) returns (Success);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);

  rpc CreateRole(CreateRoleRequest) returns (CreateRoleResponse);
  rpc AssignRole(AssignRoleRequest) returns (Success);
  rpc RemoveRole(RemoveRoleRequest) returns (Success);
}
\`\`\`

## Methods

### CreateUser

**CreateUserRequest** → **CreateUserResponse**

Creates a new user account.

**Request Message:** \`CreateUserRequest\`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | Yes | User's email address (must be unique) |
| username | string | Yes | Unique username |
| display_name | string | No | Display name for UI |
| password | string | Yes* | Initial password (or invite flow) |

**Response Message:** \`CreateUserResponse\`

| Field | Type | Description |
|-------|------|-------------|
| user | User | The created user |
| ... | ... | ... |

**Errors:**
- \`AlreadyExists\` - User with this email/username exists
- \`InvalidArgument\` - Invalid email format or missing fields

---

### ListUsers

**ListUsersRequest** → **ListUsersResponse**

Lists users with pagination support.

**Request Message:** \`ListUsersRequest\`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| pagination | Pagination | No | Pagination parameters |
| filter | UserFilter | No | Filter criteria |

**Response Message:** \`ListUsersResponse\`

| Field | Type | Description |
|-------|------|-------------|
| users | repeated User | List of users |
| meta | Meta | Pagination metadata |

**See Also:** [Pagination](../common/types.md#pagination) | [Meta](../common/types.md#meta)

---

## Message Types

### User

Represents a user account.

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique identifier (auto-generated) |
| email | string | Email address |
| username | string | Unique username |
| display_name | string | Display name |
| created_at | int64 | Creation timestamp |
| updated_at | int64 | Last update timestamp |

### Role

Represents a role with associated permissions.

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique identifier |
| name | string | Role name |
| permissions | repeated string | Permissions granted by this role |

## See Also

- [Common Types](../common/types.md) - Pagination, Meta, Success
- [Access Control Service](./access-control.md) - Resource and permission management
```

**Step 2: Commit**

```bash
git add docs/services/user-management.md
git commit -m "docs: add User Management Service documentation"
```

---

## Task 5: Create Go Example - Create Resource

**Files:**
- Create: `service-access-doc/docs/examples/go/access-control/create-resource.go`

**Step 1: Create directory**

```bash
mkdir -p docs/examples/go/access-control
```

**Step 2: Create create-resource.go**

```go
// Package main provides an example of creating a resource in the Access Control Service.
//
// This example demonstrates:
// - Establishing a gRPC connection
// - Creating an Access Control client
// - Building a CreateResourceRequest
// - Handling the response and errors
//
// Usage:
//
//	go run create-resource.go
package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	accesscontrolv1 "github.com/adityakw90/service-access-proto/gen/go/accesscontrol"
)

const (
	serverAddr = "localhost:50051"
)

func main() {
	// 1. Establish connection to the Access Control Service
	conn, err := grpc.Dial(serverAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithBlock(),
	)
	if err != nil {
		log.Fatalf("Failed to connect to server: %v", err)
	}
	defer conn.Close()

	log.Printf("Connected to Access Control Service at %s", serverAddr)

	// 2. Create the Access Control client
	client := accesscontrolv1.NewAccessControlClient(conn)

	// 3. Set a timeout for the RPC call
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 4. Build the CreateResourceRequest
	req := &accesscontrolv1.CreateResourceRequest{
		Name:        "customer-database",
		Type:        "database",
		Description: "Customer database for application data",
		Permissions: []string{"read", "write", "delete"},
	}

	// 5. Call the CreateResource RPC
	log.Printf("Creating resource: %s", req.Name)
	resp, err := client.CreateResource(ctx, req)
	if err != nil {
		log.Fatalf("CreateResource failed: %v", err)
	}

	// 6. Handle the response
	resource := resp.GetResource()
	log.Printf("Resource created successfully!")
	log.Printf("  ID: %s", resource.GetId())
	log.Printf("  Name: %s", resource.GetName())
	log.Printf("  Type: %s", resource.GetType())
	log.Printf("  Permissions: %v", resource.GetPermissions())
}
```

**Step 3: Commit**

```bash
git add docs/examples/go/access-control/create-resource.go
git commit -m "docs: add Go example for CreateResource"
```

---

## Task 6: Create Go Example - Check Permission

**Files:**
- Create: `service-access-doc/docs/examples/go/access-control/check-permission.go`

**Step 1: Create check-permission.go**

```go
// Package main provides an example of checking permissions in the Access Control Service.
//
// This example demonstrates:
// - Creating an Access Control client
// - Building a CheckPermissionRequest
// - Handling permission check results
//
// Usage:
//
//	go run check-permission.go
package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	accesscontrolv1 "github.com/adityakw90/service-access-proto/gen/go/accesscontrol"
)

const (
	serverAddr = "localhost:50051"
)

func main() {
	// 1. Establish connection
	conn, err := grpc.Dial(serverAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithBlock(),
	)
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
	defer conn.Close()

	client := accesscontrolv1.NewAccessControlClient(conn)

	// 2. Set timeout
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 3. Build the CheckPermissionRequest
	req := &accesscontrolv1.CheckPermissionRequest{
		UserId:      "user-123",
		ResourceId:  "resource-456",
		Permission:  "write",
	}

	// 4. Check permission
	log.Printf("Checking if user %s has %s permission on resource %s",
		req.UserId, req.Permission, req.ResourceId)

	resp, err := client.CheckPermission(ctx, req)
	if err != nil {
		log.Fatalf("CheckPermission failed: %v", err)
	}

	// 5. Handle result
	if resp.Allowed {
		log.Printf("✓ Permission granted")
	} else {
		log.Printf("✗ Permission denied")
		log.Printf("  Reason: %s", resp.GetReason())
	}
}
```

**Step 2: Commit**

```bash
git add docs/examples/go/access-control/check-permission.go
git commit -m "docs: add Go example for CheckPermission"
```

---

## Task 7: Update service-access-proto README

**Files:**
- Modify: `service-access-proto/README.md`

**Step 1: Read current README**

```bash
cat ../service-access-proto/README.md
```

**Step 2: Update README to reference documentation**

In the existing README, add a section before the installation steps:

```markdown
## Documentation

Full API documentation is available in the [service-access-doc](https://github.com/adityakw90/service-access-doc) repository.

- [Common Types Reference](https://github.com/adityakw90/service-access-doc/blob/main/docs/common/types.md)
- [Access Control Service](https://github.com/adityakw90/service-access-doc/blob/main/docs/services/access-control.md)
- [Code Examples](https://github.com/adityakw90/service-access-doc/tree/main/docs/examples)
```

**Step 3: Commit in service-access-proto**

```bash
cd ../service-access-proto
git add README.md
git commit -m "docs: reference service-access-doc repository"
```

---

## Task 8: Initial Release Tag

**Files:**
- Create: `service-access-doc/CHANGELOG.md`

**Step 1: Create CHANGELOG.md**

```markdown
# Changelog

All notable changes to the Access Control Service API documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-14

### Added
- Initial API documentation structure
- Common types documentation (Empty, Success, Meta, Pagination)
- Access Control Service documentation
- User Management Service documentation
- Go code examples for Access Control Service
- Documentation templates for future services
```

**Step 2: Commit in service-access-doc**

```bash
cd ../service-access-doc
git add CHANGELOG.md
git commit -m "docs: add initial changelog"
```

**Step 3: Create and push tag**

```bash
git tag -a v1.0.0 -m "Release v1.0.0: Initial API documentation"
git log --oneline -1
```

---

## Verification Steps

After completing all tasks:

1. **Verify structure:**
   ```bash
   cd service-access-doc
   find docs -type f | sort
   ```

2. **Verify links work:**
   - Check all internal markdown links reference existing files
   - Ensure cross-references between services and common types are correct

3. **Verify examples are syntactically correct:**
   ```bash
   go fmt docs/examples/go/...
   ```

4. **Review git history:**
   ```bash
   git log --oneline
   ```

---

## Notes

- This plan creates documentation for services that may not exist yet in proto
- When actual proto files are created, update the documentation to match
- Add Python examples when the service implementation is available
