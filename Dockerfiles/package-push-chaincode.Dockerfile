FROM alpine:3.12.1

RUN apk add curl bash git tar
RUN curl -L "https://github.com/jt-nti/cds-cli/releases/download/0.5.0/cds-0.5.0-linux" -o cds && chmod +x cds && mv cds /bin/cds