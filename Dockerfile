FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.22-alpine as build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk --no-cache add git

RUN mkdir -p /go/src/handler
WORKDIR /go/src/handler
COPY . .

ARG GO111MODULE="on"
ARG GOPROXY=""
ARG GOFLAGS=""
ARG CGO_ENABLED=0
ENV CGO_ENABLED=${CGO_ENABLED}

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go test ./... -cover

WORKDIR /go/src/handler
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build --ldflags "-s -w" -o handler .

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.19.1 as ship

# Add non root user and certs
RUN apk --no-cache add ca-certificates \
    && addgroup -S app && adduser -S -g app app

# Split instructions so that buildkit can run & cache
# the previous command ahead of time.
RUN mkdir -p /home/app \
    && chown app /home/app

WORKDIR /home/app

COPY --from=build --chown=app /go/src/handler/handler           .

USER app

CMD ["./handler"]
