FROM golang:1.22.1 AS go

ARG TFSEC_VERSION=v1.28.4
ARG TFLINT_VERSION=v0.49.0

RUN go install github.com/aquasecurity/tfsec/cmd/tfsec@${TFSEC_VERSION}
RUN go install github.com/terraform-linters/tflint@${TFLINT_VERSION}

FROM python:3.12.4-slim AS run

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY --from=go /go/bin/tfsec /usr/bin/tfsec
COPY --from=go /go/bin/tflint /usr/bin/tflint
