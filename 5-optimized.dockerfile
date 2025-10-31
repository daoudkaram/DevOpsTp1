# Stage 1: Build the Go binary
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy dependency files to cache modules
COPY go.mod go.sum ./
RUN go mod download

# Copy rest of source code
COPY . .

# Build binary no CGO (fully static binary this time)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server .
# this is a bit over kill but will explain the ldflags will strip symbols/debug tables and it will reduce size even further and GOARCH will ensure consistent architecture

# Stage 2: Minimal runtime image
#will user scratch it's not the best but it's an empty image literly the smallest so the code will be the "OS" like this it will be the smallest size possible :) 
FROM scratch

#Copy compiled binary
COPY --from=builder /app/server /server

#scratch don't have https requests so if we need later https we have to uncomment this but for the sake to have the smallest size will keep them commented now 
#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

#scratch has no users, so we manually define UID/GID
USER 65532:65532 


#purely documentation; scratch doesn't "open" ports
EXPOSE 8080
ENTRYPOINT ["/server"]
