#!/bin/bash

# 测试 Opus 4.1 模型限制

API_KEY="cr_7d295b442d80b04fbf008883e3019156340bfa4dedcc3f1104358627a837ed49"
API_URL="http://localhost:3000/api/v1/messages"

echo "🧪 测试 Opus 4.1 模型限制..."
echo "================================"

# 发送请求到 Opus 4.1 模型
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{
    "model": "claude-opus-4-1-20250805",
    "messages": [
      {
        "role": "user",
        "content": "Hello"
      }
    ],
    "max_tokens": 10
  }' \
  --max-time 5 \
  -w "\n\nHTTP Status: %{http_code}\n"

echo ""
echo "================================"
echo "✅ 如果返回 402 状态码和自定义错误消息，说明限制生效"
echo "❌ 如果返回 200 状态码或实际响应，说明限制未生效"