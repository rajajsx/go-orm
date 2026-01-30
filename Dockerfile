FROM nprod-harbor.mohre.gov.ae/lts-alpine/lts-alpine:3.19

# Create a non-root user and group
RUN addgroup -S mohregroup && adduser -S mohreuser -G mohregroup

# Create app directory and set permissions
RUN mkdir -p /app
COPY app/. /app/

# Set the working directory
WORKDIR /app
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing grpcurl

# Create a script to start exe
RUN echo "#!/bin/sh" > start-actions.sh && \
    echo "./sdp-actions-api" >> start-actions.sh && \
    chmod +x start-actions.sh

RUN echo "#!/bin/sh" > start-sahel.sh && \
    echo "./sdp-sahel-api" >> start-sahel.sh && \
    chmod +x start-sahel.sh

RUN echo "#!/bin/sh" > start-admin.sh && \
    echo "./sdp-admin-api" >> start-admin.sh && \
    chmod +x start-admin.sh

RUN echo "#!/bin/sh" > start-auth.sh && \
    echo "./auth_service" >> start-auth.sh && \
    chmod +x start-auth.sh

RUN echo "#!/bin/sh" > start-relay.sh && \
    echo "./sdp-relay-worker" >> start-relay.sh && \
    chmod +x start-relay.sh

RUN echo "#!/bin/sh" > start-audit.sh && \
    echo "./sdp-audit-processor" >> start-audit.sh && \
    chmod +x start-audit.sh

RUN echo "#!/bin/sh" > start-elastic.sh && \
    echo "./sdp-elastic-sync" >> start-elastic.sh && \
    chmod +x start-elastic.sh

RUN echo "#!/bin/sh" > start-jobs.sh && \
    echo "./sdp-background-jobs" >> start-jobs.sh && \
    chmod +x start-jobs.sh

RUN echo "#!/bin/sh" > start-notifications.sh && \
    echo "./sdp-notifications-worker" >> start-notifications.sh && \
    chmod +x start-notifications.sh

RUN echo "#!/bin/sh" > start-sdpslalistener.sh && \
    echo "./sdp-sla-listener" >> start-sdpslalistener.sh && \
    chmod +x start-sdpslalistener.sh

# Change ownership of the application files to the non-root user
RUN chown -R mohreuser:mohregroup \
    start-actions.sh start-sahel.sh start-admin.sh start-auth.sh \
    start-relay.sh start-audit.sh start-elastic.sh start-jobs.sh start-notifications.sh start-sdpslalistener.sh \
    sdp-actions-api sdp-sahel-api sdp-admin-api auth_service \
    sdp-relay-worker sdp-audit-processor sdp-elastic-sync sdp-background-jobs sdp-notifications-worker sdp-sla-listener || true

# Switch to the non-root user
USER mohreuser

EXPOSE 8443
# CMD ["/app/start.sh"]
