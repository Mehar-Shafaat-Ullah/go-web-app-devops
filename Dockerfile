# Build stage
FROM golang:alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

# build without VCS stamping (no git needed)
RUN go build -buildvcs=false -o main .

# Final stage: tiny distroless image
FROM gcr.io/distroless/base-debian11

WORKDIR /
COPY --from=builder /app/main /main
COPY --from=builder /app/static /static

EXPOSE 8083

CMD ["/main"]

