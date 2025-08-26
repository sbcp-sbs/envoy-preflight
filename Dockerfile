FROM golang:1.25-alpine AS builder

WORKDIR /go/src/envoy-preflight

RUN apk update && apk add curl git

COPY . .

RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w' -o /go/bin/envoy-preflight ./main.go

FROM gcr.io/distroless/base-debian12

COPY --from=builder /go/bin/envoy-preflight /go/bin/envoy-preflight

ENTRYPOINT ["/go/bin/envoy-preflight"]
