.PHONY: go clean deps

deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1

# Generate Go code for all proto files
go:
	mkdir -p gen/go
	protoc \
		--proto_path=proto \
		--proto_path=/usr/local/include \
		--go_out=. --go_opt=module=github.com/adityakw90/service-access-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-access-proto \
		proto/*.proto

clean:
	rm -rf gen
