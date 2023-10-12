pipeline "send_request" {
  description = "Make a request to the GPT-3.5 language model."

  param "api_key" {
    type    = string
    default = var.token
  }

  param "model" {
    type = string
    default = "gpt-3.5-turbo"
  }

  param "system_content" {
    type = string
  }

  param "user_content" {
    type = string
  }

  step "http" "send_request" {
    title  = "Send request to GPT-3.5 language model."
    method = "post"
    url    = "https://api.openai.com/v1/chat/completions"

    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Bearer ${param.api_key}"
    }

    request_body = jsonencode({
      "model" : "${param.model}",
      "temperature" : 1,
      "max_tokens" : 10,
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

  output "response_body" {
    value = step.http.send_request.response_body
  }
  output "response_headers" {
    value = step.http.send_request.response_headers
  }
  output "status_code" {
    value = step.http.send_request.status_code
  }
}

