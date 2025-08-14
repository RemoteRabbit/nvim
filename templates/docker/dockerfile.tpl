;; dockerfile
# {{_file_name_}} - {{_input_:app_description_}}
# Author: {{_author_}}
# Date: {{_date_}}

FROM {{_input_:base_image_}} AS base

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    {{_input_:system_packages_}} \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser

# Copy dependency files
COPY {{_input_:dependency_files_}} ./

# Install dependencies
RUN {{_input_:install_command_}}

# Development stage
FROM base AS development

# Install development dependencies
RUN {{_input_:dev_install_command_}}

# Copy source code
COPY --chown=appuser:appuser . .

USER appuser

EXPOSE {{_input_:dev_port_}}

CMD ["{{_input_:dev_command_}}"]

# Production stage
FROM base AS production

# Copy source code
COPY --chown=appuser:appuser {{_input_:src_directory_}} ./

# Build application
RUN {{_input_:build_command_}}

# Remove development dependencies and clean up
RUN {{_input_:cleanup_command_}} \
    && rm -rf /tmp/* /var/tmp/*

USER appuser

EXPOSE {{_input_:prod_port_}}

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD {{_input_:health_check_command_}}

CMD ["{{_input_:prod_command_}}"]

{{_cursor_}}
