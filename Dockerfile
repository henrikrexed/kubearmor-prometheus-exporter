### Builder

FROM golang:1.22-alpine3.20 AS builder

WORKDIR /usr/src/kubearmor-prometheus-exporter

RUN apk update
RUN apk add build-base

COPY . .
RUN go mod tidy
RUN GOOS=linux GOARCH=amd64 go build -a -ldflags '-s -w' -o kubearmor-prometheus-exporter main.go

### Make executable image

FROM alpine:3.20.3

COPY --from=builder /usr/src/kubearmor-prometheus-exporter/kubearmor-prometheus-exporter /kubearmor-prometheus-exporter

ENTRYPOINT ["/kubearmor-prometheus-exporter"]
