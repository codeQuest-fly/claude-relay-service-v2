#!/bin/bash

# 测试客户端模型限制功能
# 验证当请求被限制的模型时，是否返回自定义错误消息

API_KEY="${1:-cr_7d295b442d80b04fbf008883e3019156340bfa4dedcc3f1104358627a837ed49}"
API_URL="${2:-http://localhost:3000}"

echo "🧪 测试模型限制功能（客户端视角）"
echo "================================"
echo "API Key: $API_KEY"
echo "API URL: $API_URL"
echo ""

# 测试限制的模型列表
MODELS=(
  "claude-opus-4-1-20250805"
  "claude-sonnet-4-5-20250929"
  "claude-3-5-haiku-20241022"
)

for MODEL in "${MODELS[@]}"; do
  echo "📝 测试模型: $MODEL"
  echo "---"

  RESPONSE=$(curl -s -X POST "$API_URL/api/v1/messages" \
    -H "Content-Type: application/json" \
    -H "X-API-Key: $API_KEY" \
    -d "{
      \"model\": \"$MODEL\",
      \"messages\": [{
        \"role\": \"user\",
        \"content\": \"Hello\"
      }],
      \"max_tokens\": 10
    }" \
    --max-time 5 \
    -w "\nHTTP_CODE:%{http_code}")

  # 提取 HTTP 状态码
  HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d':' -f2)
  BODY=$(echo "$RESPONSE" | sed '/HTTP_CODE:/d')

  echo "HTTP 状态码: $HTTP_CODE"

  if [ "$HTTP_CODE" = "402" ]; then
    echo "✅ 返回 402 状态码（符合预期）"

    # 检查是否有自定义错误消息
    ERROR_MESSAGE=$(echo "$BODY" | jq -r '.error.message // empty' 2>/dev/null)
    ERROR_TYPE=$(echo "$BODY" | jq -r '.error.type // empty' 2>/dev/null)

    if [ -n "$ERROR_MESSAGE" ]; then
      echo "✅ 包含错误消息:"
      echo "   类型: $ERROR_TYPE"
      echo "   消息: $ERROR_MESSAGE"
    else
      echo "❌ 缺少错误消息（格式可能不正确）"
      echo "   响应体: $BODY"
    fi
  else
    echo "❌ 状态码不是 402（实际: $HTTP_CODE）"
    echo "   响应: $BODY"
  fi

  echo ""
done

echo "================================"
echo ""
echo "💡 预期行为："
echo "  - 所有被限制的模型都应该返回 402 状态码"
echo "  - 响应应该包含自定义的错误消息"
echo "  - 错误消息应该是友好的中文提示"
echo ""
echo "💡 如果看到通用错误消息而不是自定义消息，请检查："
echo "  1. 账户是否正确配置了 enableModelRestriction=true"
echo "  2. restrictedModels 是否包含该模型"
echo "  3. customErrorMessages 是否为该模型设置了消息"
echo "  4. 后端日志中是否有相关错误信息"
