from golang:1.18.1-alpine as builder


WORKDIR /app

copy go.mod . 

RUN go mod download

copy . . 

RUN go build -o main .

#final image dostroless

FROM gcr.io/distroless/base	

COPY  --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 8083

CMD ["./main"] 

