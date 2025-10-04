// 预设的模型列表
export const presetModels = [
  { value: 'claude-opus-4-1-20250805', label: 'Claude Opus 4.1' },
  { value: 'claude-3-opus-20240229', label: 'Claude 3 Opus' },
  { value: 'claude-sonnet-4-5-20250929', label: 'Claude Sonnet 4.5' },
  { value: 'claude-3-5-sonnet-20241022', label: 'Claude 3.5 Sonnet' },
  { value: 'claude-3-5-haiku-20241022', label: 'Claude 3.5 Haiku' },
  { value: 'claude-3-haiku-20240307', label: 'Claude 3 Haiku' }
]

// 预设的错误消息模板
export const errorMessageTemplates = {
  'claude-opus-4-1-20250805': {
    zh: '由于Claude限制原因, 暂时关闭Opus 4.1使用, 具体恢复时间不详, 请使用其他模型。',
    en: 'Opus 4.1 is temporarily unavailable due to Claude restrictions. Please use another model.',
    httpCode: 402
  },
  'claude-sonnet-4-5-20250929': {
    zh: 'Sonnet 4.5 功能暂时不可用，请使用标准版本。',
    en: 'Sonnet 4.5 is temporarily disabled. Please use the standard version.',
    httpCode: 402
  },
  'claude-3-opus-20240229': {
    zh: 'Claude 3 Opus 已停用，建议使用 Claude 3.5 Sonnet。',
    en: 'Claude 3 Opus has been discontinued. Please use Claude 3.5 Sonnet instead.',
    httpCode: 402
  },
  'claude-3-5-sonnet-20241022': {
    zh: '该模型暂时不可用，请稍后重试或使用其他模型。',
    en: 'This model is temporarily unavailable. Please try again later or use another model.',
    httpCode: 503
  }
}

// 获取默认错误消息
export function getDefaultErrorMessage(model, lang = 'zh') {
  const template = errorMessageTemplates[model]
  if (template) {
    return {
      message: template[lang],
      httpCode: template.httpCode || 402
    }
  }
  return {
    message:
      lang === 'zh'
        ? `模型 ${model} 暂时不可用，请使用其他模型。`
        : `Model ${model} is temporarily unavailable. Please use another model.`,
    httpCode: 402
  }
}

// 获取模型显示名称
export function getModelDisplayName(modelId) {
  const model = presetModels.find((m) => m.value === modelId)
  if (model) {
    return model.label
  }
  // 尝试简化模型ID显示
  if (modelId.includes('opus')) return 'Opus'
  if (modelId.includes('sonnet')) return 'Sonnet'
  if (modelId.includes('haiku')) return 'Haiku'
  return modelId
}

// 初始化自定义错误消息
export function initializeCustomErrorMessage(model) {
  const defaultMsg = getDefaultErrorMessage(model, 'zh')
  return {
    httpCode: defaultMsg.httpCode,
    message: defaultMsg.message
  }
}
