# Service Access Proto

Protobuf definitions and gRPC contracts for the Access Control Service.

## Directory Structure

- `proto/`: Contains the source `.proto` files defining the service API and messages.
- `gen/`: Contains the generated code from the proto definitions.
  - `go/`: Generated Go code.

## Generated Code Structure

After running `make go`, the following structure is created:

```
gen/go/
├── access/              # AccessControlService
│   ├── access_control.pb.go
│   └── access_control_grpc.pb.go
├── permission/          # PermissionService
│   ├── permission.pb.go
│   └── permission_grpc.pb.go
├── group/               # GroupService
│   ├── group.pb.go
│   └── group_grpc.pb.go
├── role/                # RoleService
│   ├── role.pb.go
│   └── role_grpc.pb.go
└── common/              # Common types
    └── common.pb.go
```

> **Note:** This package provides pure gRPC contracts. HTTP/JSON gateway endpoints and proto-level validation have been removed. See [docs/MIGRATION.md](docs/MIGRATION.md) for details.

## Services Overview

This repository defines the following gRPC services:

### 1. AccessControlService (`access_control.proto`)

Authorization and subject assignment operations.

- **CheckAccess**: Verify if a subject has permission for an action on a resource
- **AssignRole**: Grant a role to a subject
- **RevokeRole**: Remove a role from a subject
- **ListSubjectRoles**: List all roles assigned to a subject

### 2. PermissionService (`permission.proto`)

Full CRUD operations for managing permissions.

- **CreatePermission**: Create a new permission
- **GetPermission**: Retrieve a permission by UID
- **UpdatePermission**: Update permission details
- **DeletePermission**: Delete a permission
- **ListPermissions**: List all permissions (paginated)

### 3. GroupService (`group.proto`)

Full CRUD operations for managing permission groups.

- **CreateGroup**: Create a new permission group
- **GetGroup**: Retrieve a group by UID
- **UpdateGroup**: Update group details
- **DeleteGroup**: Delete a group
- **ListGroups**: List all groups (paginated)
- **AssignGroupPermission**: Add a permission to a group
- **RevokeGroupPermission**: Remove a permission from a group
- **ListGroupPermissions**: List all permissions in a group

### 4. RoleService (`role.proto`)

Full CRUD operations for managing roles within groups.

- **CreateRole**: Create a new role in a group
- **GetRole**: Retrieve a role by UID
- **UpdateRole**: Update role details
- **DeleteRole**: Delete a role
- **ListRoles**: List all roles (paginated, optional group filter)
- **AssignRolePermission**: Add a permission to a role
- **RevokeRolePermission**: Remove a permission from a role
- **ListRolePermissions**: List all permissions in a role

### Common Definitions (`common.proto`)

Contains shared message definitions used across multiple services:

- **Empty**: Empty message for operations with no parameters
- **Success**: Simple success boolean response
- **Pagination**: Standard pagination request parameters (page, limit, sort)
- **Meta**: Pagination response metadata (total items, total pages)

## Installation

### 1. Install Protocol Buffers compiler

**For Ubuntu/Debian:**

```bash
sudo apt-get install protobuf-compiler
```

**For macOS:**

```bash
brew install protobuf
```

### 2. Install Go plugins

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1
```

Or simply run:
```bash
make deps
```

## Usage

To generate the Go code from the proto definitions, run the following command from the root of the repository:

```bash
make go
```

This command will:

1. Create the `gen/go` directory if it doesn't exist.
2. Compile all `.proto` files in the `proto/` directory.
3. Output the generated Go code into `gen/go`.

To clean the generated code:

```bash
make clean
```
