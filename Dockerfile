# Build stage
FROM golang:1.18.1-alpine AS builder

WORKDIR /app

# Install git (only if needed by go mod)
RUN apk add --no-cache git

COPY go.mod ./
RUN go mod download

COPY . .

# Build static binary (no glibc/musl issues)
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -buildvcs=false -o main .

# Final stage: minimal distroless image
FROM gcr.io/distroless/static-debian11

WORKDIR /

COPY --from=builder /app/main /main
COPY --from=builder /app/static /static

EXPOSE 8083

CMD ["/main"]
