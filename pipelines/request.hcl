// usage: flowpipe pipeline run send_request --pipeline-arg system_content="You are a standup comedian." --pipeline-arg user_content="Tell a joke about programmers."
pipeline "send_request" {
  description = "Make a request to the GPT-3.5 language model."

  param "token" {
    type        = string
    description = "OpenAI API key used for authentication."
    default     = var.token
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

  step "http" "send_request" {
    title  = "Send request to GPT-3.5 language model."
    method = "post"
    url    = "https://api.openai.com/v1/chat/completions"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.token}"
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

  output "gpt_responses" {
    value = join(" ", [for choice in jsondecode(step.http.send_request.response_body).choices : choice.message.content])
  }
}


