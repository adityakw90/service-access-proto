.PHONY: go clean deps

deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1
	go install github.com/envoyproxy/protoc-gen-validate@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest

# Generate Go code for all proto files
go:
	mkdir -p gen/go
	protoc \
		--proto_path=proto \
		--proto_path=/usr/local/include \
		--go_out=. --go_opt=module=github.com/adityakw90/service-access-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-access-proto \
		--validate_out=. --validate_opt=module=github.com/adityakw90/service-access-proto \
		--grpc-gateway_out=. --grpc-gateway_opt=module=github.com/adityakw90/service-access-proto \
		--openapiv2_out=gen/go \
		proto/*.proto

clean:
	rm -rf gen
