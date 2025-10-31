FROM alpine:latest

# Install curl 
RUN apk --no-cache add curl 

# non root user (and group)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

ENTRYPOINT ["curl"]

CMD ["--help"]
