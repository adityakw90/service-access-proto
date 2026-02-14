# Service Access Proto

Protobuf definitions and gRPC contracts for the Access Control Service.

## Directory Structure

- `proto/`: Contains the source `.proto` files defining the service API and messages.
- `gen/`: Contains the generated code from the proto definitions.
  - `go/`: Generated Go code.

## Services Overview

This repository defines the following gRPC services:

### 1. <ServiceName> (`<service-name>.proto`)

<Service Description>.

- **<MethodName>**: Short description.
- **<MethodName>**: Short description.
- **<MethodName>**: Short description.
- **<MethodName>**: Short description.

### Common Definitions (`common.proto`)

Contains shared message definitions used across multiple services:

- **Pagination**: Standard pagination request parameters (page, limit, sort).
- **Meta**: Pagination response metadata (total items, total pages).
- **Success**: A simple success boolean response.

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

## Usage

To generate the Go code from the proto definitions, run the following command from the root of the repository:

```bash
make go
```

This command will:

1. Create the `gen/go` directory if it doesn't exist.
2. Compile all `.proto` files in the `proto/` directory.
3. Output the generated Go code into `gen/go`, preserving the package structure defined by `go_package`.
