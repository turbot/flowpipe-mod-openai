pipeline "create_chat_completion" {
  title       = "Create Chat Completion"
  description = "Creates a model response for the given chat conversation."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = "Name for credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "model" {
    type        = string
    description = "ID of the model to use. See the [model endpoint compatibility](https://platform.openai.com/docs/models/model-endpoint-compatibility) table for details on which models work with the Chat API."
    default     = "gpt-3.5-turbo"
  }

  param "system_content" {
    type        = string
    description = "The role of the messages author. System in this case."
  }

  param "user_content" {
    type        = string
    description = "The role of the messages author. User in this case."
  }

  param "max_tokens" {
    type        = number
    description = "The maximum number of tokens to generate in the chat completion."
    default     = 50
  }

  param "temperature" {
    type        = number
    description = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic."
    default     = 1
  }

  step "http" "create_chat_completion" {
    method = "post"
    url    = "https://api.openai.com/v1/chat/completions"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${credential.openai[param.cred].api_key}"
    }

    request_body = jsonencode({
      "model" : "${param.model}",
      "temperature" : "${param.temperature}",
      "max_tokens" : "${param.max_tokens}",
      "messages" : [
        {
          "role" : "system",
          "content" : "${param.system_content}"
        },
        {
          "role" : "user",
          "content" : "${param.user_content}"
        }
      ]
    })
  }

  output "chat_completion_choices" {
    value = step.http.create_chat_completion.response_body.choices
  }
}


