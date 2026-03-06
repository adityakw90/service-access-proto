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
├── access/              # AccessControlService (access.proto)
│   ├── access.pb.go
│   └── access_grpc.pb.go
├── subject/             # SubjectService (subject.proto)
│   ├── subject.pb.go
│   └── subject_grpc.pb.go
├── permission/          # PermissionService (permission.proto)
│   ├── permission.pb.go
│   └── permission_grpc.pb.go
├── group/               # GroupService (group.proto)
│   ├── group.pb.go
│   └── group_grpc.pb.go
├── role/                # RoleService (role.proto)
│   ├── role.pb.go
│   └── role_grpc.pb.go
└── common/              # Common types (common.proto)
    └── common.pb.go
```

> **Note:** This package provides pure gRPC contracts. HTTP/JSON gateway endpoints and proto-level validation have been removed.

## Services Overview

This repository defines the following gRPC services:

### 1. AccessControlService (`access.proto`)

Core authorization service for checking access permissions.

- **CheckAccess**: Verify if a subject has permission for an action on a resource

### 2. SubjectService (`subject.proto`)

Subject and role assignment management operations.

- **List**: List all role assignments for a subject (paginated, with filtering)
- **AssignRole**: Grant a role to a subject
- **RevokeRole**: Remove a role from a subject
- **Get**: Get comprehensive subject information including all groups, roles, and permissions
- **ListGroup**: List all groups the subject belongs to
- **ListRole**: List all roles assigned to the subject (directly and via groups)
- **ListPermission**: List all unique permissions the subject has through their roles

### 3. PermissionService (`permission.proto`)

Full CRUD operations for managing permissions.

- **CreatePermission**: Create a new permission
- **GetPermission**: Retrieve a permission by UID
- **UpdatePermission**: Update permission details
- **DeletePermission**: Delete a permission
- **ListPermissions**: List all permissions (paginated)

### 4. GroupService (`group.proto`)

Full CRUD operations for managing permission groups.

- **CreateGroup**: Create a new permission group
- **GetGroup**: Retrieve a group by UID
- **UpdateGroup**: Update group details
- **DeleteGroup**: Delete a group
- **ListGroups**: List all groups (paginated)
- **AssignGroupPermission**: Add a permission to a group
- **RevokeGroupPermission**: Remove a permission from a group
- **ListGroupPermissions**: List all permissions in a group

### 5. RoleService (`role.proto`)

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

## API Reference

### AccessControlService

#### CheckAccess

**Request:** `CheckAccessRequest`
- `subject_id` (string): The ID of the entity requesting access (e.g., "user-123", "service-abc")
- `subject_type` (string): The type of entity (e.g., "user", "service", "system")
- `resource` (string): The resource being accessed
- `action` (string): The action being performed (e.g., "read", "write", "delete")

**Response:** `CheckAccessResponse`
- `allowed` (bool): True if the subject has permission
- `reason` (string): Explanation of the decision (which roles/permissions granted access, or why denied)

### SubjectService

**Messages:**

- `SubjectRole`: Represents a role assigned to a subject
  - `subject_id` (string)
  - `subject_type` (string)
  - `role_uid` (string)
  - `assigned_at` (google.protobuf.Timestamp)

- `FilterRequest`: Filter for subject role queries
  - `subject_id` (optional string)
  - `subject_type` (optional string)
  - `role_uid` (optional string)
  - `query` (optional string)

- `GetSubjectRequest`: Request for comprehensive subject data
  - `subject_id` (string)
  - `subject_type` (string)

- `GetSubjectResponse`: Complete subject context
  - `groups` (repeated access.group.Group): All groups the subject belongs to
  - `roles` (repeated access.role.Role): All roles assigned (direct and via groups)
  - `permissions` (repeated access.permission.Permission): All unique permissions
  - `total_group` (int32)
  - `total_role` (int32)
  - `total_permission` (int32)

- `ListGroupResponse`: Groups for a subject
  - `groups` (repeated access.group.Group)
  - `total` (int32)

- `ListRoleResponse`: Roles for a subject
  - `roles` (repeated access.role.Role)
  - `total` (int32)

- `ListPermissionResponse`: Permissions for a subject
  - `permissions` (repeated access.permission.Permission)
  - `total` (int32)

**RPC Methods:**
- `List(ListRequest) → ListResponse`
- `AssignRole(AssignRoleRequest) → access.common.Success`
- `RevokeRole(RevokeRoleRequest) → access.common.Success`
- `Get(GetSubjectRequest) → GetSubjectResponse`
- `ListGroup(GetSubjectRequest) → ListGroupResponse`
- `ListRole(GetSubjectRequest) → ListRoleResponse`
- `ListPermission(GetSubjectRequest) → ListPermissionResponse`

### PermissionService

#### Messages:
- `Permission`: Represents a permission
  - `uid` (string)
  - `resource` (string)
  - `action` (string)
  - `description` (string)
  - `created_at` (google.protobuf.Timestamp)
  - `updated_at` (google.protobuf.Timestamp)

- `FilterRequest`: Filter for permission queries
  - `uids` (repeated string)
  - `resource` (optional string)
  - `action` (optional string)
  - `query` (optional string)

**RPC Methods:**
- `List(ListRequest) → ListResponse`
- `Get(GetRequest) → Permission`
- `Create(CreateRequest) → CreateResponse`
- `Update(UpdateRequest) → access.common.Success`
- `Delete(DeleteRequest) → access.common.Success`

### GroupService

#### Messages:
- `Group`: Represents a permission group
  - `uid` (string)
  - `name` (string)
  - `description` (string)
  - `created_at` (google.protobuf.Timestamp)
  - `updated_at` (google.protobuf.Timestamp)

- `GroupPermission`: Permission assigned to a group
  - `uid` (string)
  - `group_uid` (string)
  - `permission_uid` (string)
  - `permission_resource` (string)
  - `permission_action` (string)
  - `permission_description` (string)
  - `created_at` (google.protobuf.Timestamp)

- `FilterRequest`: Filter for group queries
  - `uids` (repeated string)
  - `name` (optional string)
  - `query` (optional string)

- `FilterPermissionRequest`: Filter for group permissions
  - `uids` (repeated string)
  - `permission_uids` (repeated string)
  - `resource` (optional string)
  - `action` (optional string)
  - `query` (optional string)

**RPC Methods:**
- `List(ListRequest) → ListResponse`
- `Get(GetRequest) → Group`
- `Create(CreateRequest) → CreateResponse`
- `Update(UpdateRequest) → access.common.Success`
- `Delete(DeleteRequest) → access.common.Success`
- `AssignPermission(AssignPermissionRequest) → access.common.Success`
- `RevokePermission(RevokePermissionRequest) → access.common.Success`
- `ListPermissions(ListPermissionsRequest) → ListPermissionsResponse`

### RoleService

#### Messages:
- `Role`: Represents a role within a group
  - `uid` (string)
  - `group_uid` (string)
  - `name` (string)
  - `description` (string)
  - `created_at` (google.protobuf.Timestamp)
  - `updated_at` (google.protobuf.Timestamp)

- `RolePermission`: Permission assigned to a role
  - `role_uid` (string)
  - `group_permission_uid` (string)
  - `permission_uid` (string)
  - `permission_resource` (string)
  - `permission_action` (string)
  - `permission_description` (string)
  - `created_at` (google.protobuf.Timestamp)

- `FilterRequest`: Filter for role queries
  - `uids` (repeated string)
  - `group_uids` (repeated string)
  - `name` (optional string)
  - `query` (optional string)

- `FilterPermissionRequest`: Filter for role permissions
  - `permission_uids` (repeated string)
  - `resource` (optional string)
  - `action` (optional string)
  - `query` (optional string)

**RPC Methods:**
- `List(ListRequest) → ListResponse`
- `Get(GetRequest) → Role`
- `Create(CreateRequest) → CreateResponse`
- `Update(UpdateRequest) → access.common.Success`
- `Delete(DeleteRequest) → access.common.Success`
- `AssignPermission(AssignPermissionRequest) → access.common.Success`
- `RevokePermission(RevokePermissionRequest) → access.common.Success`
- `ListPermissions(ListPermissionsRequest) → ListPermissionsResponse`

## Type Referencing Conventions

This project uses **fully-qualified type names** for all cross-package references to ensure consistency and avoid naming conflicts, particularly with reserved keywords like `group`.

**Pattern:** `access.<package>.<Type>`

Examples:
- `access.common.Pagination`
- `access.common.Success`
- `access.common.Meta`
- `access.group.Group`
- `access.role.Role`
- `access.permission.Permission`

When defining messages within a proto file, types from the same package can be referenced by their simple name (e.g., `Group`, `Role`). However, when importing types from other packages, always use the fully-qualified name.

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
