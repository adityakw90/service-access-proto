.PHONY: go clean deps

deps:
	@echo "Installing dependencies..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1
	@echo "Dependencies installed successfully."

# Generate Go code for all proto files
go:
	@echo "Generating Go code for all proto files..."
	@mkdir -p gen/go
	@protoc \
		--proto_path=proto \
		--go_out=. --go_opt=module=github.com/adityakw90/service-access-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/adityakw90/service-access-proto \
		proto/**/*.proto
	@echo "Go code generated successfully."

clean:
	@echo "Cleaning generated code..."
	@rm -rf gen
	@echo "Cleaned successfully."
