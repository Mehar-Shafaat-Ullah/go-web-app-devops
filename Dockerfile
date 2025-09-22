from golang:1.18.1-alpine


WORKDIR /

copy go.mod . 

RUN go mod download

copy . . 

RUN go build -o main .


