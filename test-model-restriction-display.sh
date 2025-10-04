#!/bin/bash

# 测试账户模型限制配置的回显功能

API_KEY="your_admin_api_key_here"
API_URL="http://localhost:3000"

echo "🧪 测试模型限制配置回显功能..."
echo "================================"

# 1. 获取所有 Claude 账户
echo ""
echo "📋 步骤 1: 获取所有 Claude 账户"
ACCOUNTS=$(curl -s -X GET "$API_URL/admin/claude-accounts" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json")

echo "$ACCOUNTS" | jq -r '.data[] | "\(.id): \(.name)"'

# 2. 选择第一个账户查看详情
ACCOUNT_ID=$(echo "$ACCOUNTS" | jq -r '.data[0].id')
echo ""
echo "🔍 步骤 2: 查看账户 $ACCOUNT_ID 的模型限制配置"

ACCOUNT=$(echo "$ACCOUNTS" | jq -r ".data[] | select(.id==\"$ACCOUNT_ID\")")
echo "启用模型限制: $(echo "$ACCOUNT" | jq -r '.enableModelRestriction')"
echo "限制的模型: $(echo "$ACCOUNT" | jq -r '.restrictedModels')"
echo "自定义错误消息: $(echo "$ACCOUNT" | jq -r '.customErrorMessages')"

# 3. 更新账户的模型限制配置
echo ""
echo "✏️ 步骤 3: 更新账户的模型限制配置"
UPDATE_RESULT=$(curl -s -X PUT "$API_URL/admin/claude-accounts/$ACCOUNT_ID" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "enableModelRestriction": true,
    "restrictedModels": ["claude-opus-4-1-20250805", "claude-sonnet-4-5-20250929"],
    "customErrorMessages": {
      "claude-opus-4-1-20250805": "Opus 4.1 暂时不可用，请使用其他模型",
      "claude-sonnet-4-5-20250929": "Sonnet 4.5 (思维扩展) 暂时关闭"
    }
  }')

echo "$UPDATE_RESULT" | jq '.'

# 4. 再次获取账户验证更新
echo ""
echo "🔄 步骤 4: 再次获取账户验证更新是否生效"
UPDATED_ACCOUNTS=$(curl -s -X GET "$API_URL/admin/claude-accounts" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json")

UPDATED_ACCOUNT=$(echo "$UPDATED_ACCOUNTS" | jq -r ".data[] | select(.id==\"$ACCOUNT_ID\")")
echo "启用模型限制: $(echo "$UPDATED_ACCOUNT" | jq -r '.enableModelRestriction')"
echo "限制的模型: $(echo "$UPDATED_ACCOUNT" | jq -r '.restrictedModels')"
echo "自定义错误消息: $(echo "$UPDATED_ACCOUNT" | jq -r '.customErrorMessages')"

echo ""
echo "================================"
echo "✅ 测试完成"
echo ""
echo "💡 如果数据能正确回显，说明功能正常"
echo "💡 如果数据为 null 或空，请检查后端日志"
