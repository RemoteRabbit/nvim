;; yaml
name: {{_input_:workflow_name_}}

on:
  push:
    branches: [ {{_input_:branches_}} ]
  pull_request:
    branches: [ {{_input_:branches_}} ]
  workflow_dispatch:

env:
  NODE_VERSION: '{{_input_:node_version_}}'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [{{_input_:node_matrix_}}]

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: '{{_input_:package_manager_}}'

    - name: Install dependencies
      run: {{_input_:install_command_}}

    - name: Run linter
      run: {{_input_:lint_command_}}

    - name: Run type check
      run: {{_input_:typecheck_command_}}

    - name: Run tests
      run: {{_input_:test_command_}}

    - name: Upload coverage to Codecov
      if: matrix.node-version == env.NODE_VERSION
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
        fail_ci_if_error: true

  security:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Run security audit
      run: {{_input_:audit_command_}}

    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'

  build:
    runs-on: ubuntu-latest
    needs: [test, security]
    if: github.event_name == 'push'

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-

    - name: Build and push Docker image
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/{{_input_:deploy_branch_}}' && github.event_name == 'push'
    environment: {{_input_:environment_name_}}

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Deploy to {{_input_:deploy_target_}}
      env:
        DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        DEPLOY_HOST: ${{ secrets.DEPLOY_HOST }}
        DEPLOY_USER: ${{ secrets.DEPLOY_USER }}
      run: |
        # Add deployment steps here
        echo "Deploying to {{_input_:deploy_target_}}..."
        {{_cursor_}}

    - name: Health check
      run: |
        curl -f ${{ secrets.HEALTH_CHECK_URL }} || exit 1
