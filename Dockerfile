FROM golang:1.16 as builder

ENV PROJECT github.com/XciD/loxone-prometheus-exporter
ENV GO111MODULE on
WORKDIR /go/src/$PROJECT

COPY go.mod /go/src/$PROJECT
COPY go.sum /go/src/$PROJECT

RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /exporter .

FROM scratch as release
COPY --from=builder /exporter /exporter
EXPOSE 8080
ENTRYPOINT ["/exporter"]
