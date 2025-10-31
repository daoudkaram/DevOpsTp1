# Stage 1: Build the Go binary
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy dependency files to cache modules
COPY go.mod go.sum ./
RUN go mod download

# Copy rest of source code
COPY . .

# Build binary no CGO
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Stage 2: Minimal runtime image
#it's not the smallest distro but betweent he optimized it's the safest for prod i am gona go with it 
FROM gcr.io/distroless/static:nonroot 

#Copy compiled binary
COPY --from=builder /app/server /server

#Run as non-root user
USER nonroot:nonroot

EXPOSE 8080
ENTRYPOINT ["/server"]
