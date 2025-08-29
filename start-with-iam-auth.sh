#!/bin/bash

# AWS RDS IAM 인증을 사용하는 MCP 서버 시작 스크립트

# 모든 디버그 메시지는 stderr로 출력
echo "Generating RDS IAM authentication token..." >&2
AUTH_TOKEN=$(aws rds generate-db-auth-token \
  --hostname "$MYSQL_HOST" \
  --port "$MYSQL_PORT" \
  --username "$MYSQL_USER" \
  --region "$AWS_REGION" 2>&2)

if [ $? -ne 0 ]; then
  echo "Failed to generate authentication token" >&2
  exit 1
fi

echo "Token generated successfully" >&2

# 환경 변수 설정 및 MCP 서버 시작
export MYSQL_HOST="$MYSQL_HOST"
export MYSQL_PORT="$MYSQL_PORT"
export MYSQL_USER="$MYSQL_USER"
export MYSQL_PASS="$AUTH_TOKEN"
export MYSQL_DB="$MYSQL_DB"
export MYSQL_SSL="true"
export ALLOW_INSERT_OPERATION="false"
export ALLOW_UPDATE_OPERATION="false"
export ALLOW_DELETE_OPERATION="false"

# MCP 서버 시작
echo "Starting MCP server..." >&2
exec node /Users/hyemin/mcp-server-mysql/dist/index.js

