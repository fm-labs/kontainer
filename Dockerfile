## Build stage
FROM node:lts AS ui-builder

WORKDIR /app

# Copy package.json and yarn.lock for caching purposes
COPY ./ui/package.json ./ui/yarn.lock ./

# Install packages and cache them
#RUN npm i -g npm@latest && npm i -g yarn@latest
RUN yarn install --frozen-lockfile && yarn cache clean

# Copy rest of files
# See / edit .dockerignore file for excluded files
COPY ./ui/ /app/
RUN ls -la /app

RUN yarn build



FROM python:3.13-slim AS agent-builder

# Update package list and install necessary dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    nginx \
    redis-server \
    supervisor

# Add Docker's official GPG key:
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

# Verify the installations
#RUN which docker && docker --version

WORKDIR /app

# Install dependencies
COPY ./agent/pyproject.toml ./agent/poetry.lock /app/
RUN pip install poetry \
    && poetry config virtualenvs.create false \
    && poetry install --only main --no-root

# Copy the rest of the code
COPY ./agent/src /app/src
COPY ./agent/agent.py /app/agent.py
COPY ./agent/celery_worker.sh /app/celery_worker.sh

# Copy nginx configuration
COPY ./agent/docker/nginx/default.conf /etc/nginx/sites-available/default

# Configure Supervisor
COPY ./agent/docker/supervisor/celery_worker.conf /etc/supervisor/conf.d/celery_worker.conf


# Copy frontend app from the ui-builder stage
COPY --from=ui-builder /app/dist /app/www


# Entry point
#COPY ./docker/entrypoint.sh /entrypoint.sh
COPY ./agent/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["gunicorn-tcp"]


# Health check
HEALTHCHECK --interval=60s --timeout=3s --retries=3 \
 CMD curl --fail http://localhost:80/ || exit 1

# Nginx Port
EXPOSE 80

# Agent Port
EXPOSE 5000
