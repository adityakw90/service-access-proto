# Migration Guide: Simplified Proto

## Summary

HTTP annotations and validation rules have been removed from proto files.
This package now provides pure gRPC contracts with simplified structure.

## Breaking Changes

1. **No HTTP/JSON Endpoints**
   - gRPC-Gateway endpoints are no longer generated
   - Use gRPC clients only

2. **No Proto-Level Validation**
   - Validation rules removed from proto definitions
   - Implement validation in your service layer

3. **Reduced Dependencies**
   - No longer requires grpc-gateway or protoc-gen-validate

## Service Layer Validation Example

Previously validated at proto level:
```go
// Validation is now your responsibility
func (s *Server) CheckAccess(ctx context.Context, req *accesspb.CheckAccessRequest) (*accesspb.CheckAccessResponse, error) {
    if req.SubjectId == "" {
        return nil, status.Error(codes.InvalidArgument, "subject_id is required")
    }
    if req.SubjectType == "" {
        return nil, status.Error(codes.InvalidArgument, "subject_type is required")
    }
    // ... rest of implementation
}
```

## Updated Go Module

```go
// No longer needed:
// import "github.com/grpc-ecosystem/grpc-gateway/v2/runtime"

import (
    accesspb "github.com/adityakw90/service-access-proto/gen/go/access"
    rolepb "github.com/adityakw90/service-access-proto/gen/go/role"
    // ... other packages
)
```
