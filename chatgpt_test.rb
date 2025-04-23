require 'net/http'
require 'json'
require 'uri'

def chatgpt_query(prompt)
  api_key = ENV["OPENAI_API_KEY"]
  if !api_key
    puts "❌ エラー: OPENAI_API_KEY が設定されていません。"
    return
  end

  uri = URI("https://api.openai.com/v1/chat/completions")
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }
  body = {
    model: "gpt-3.5-turbo",
    messages: [
      { role: "system", content: "あなたはツンデレキャラです。短く答えてください。" },
      { role: "user", content: prompt }
    ],
    temperature: 0.8,
    max_tokens: 100
  }

  res = Net::HTTP.post(uri, body.to_json, headers)
  data = JSON.parse(res.body)

  if data["choices"]
    puts data["choices"][0]["message"]["content"]
  elsif data["error"]
    puts "❌ OpenAI API エラー: #{data["error"]["message"]}"
  else
    puts "⚠️ 予期しない応答: #{res.body}"
  end
end

chatgpt_query(ARGV.join(" "))
