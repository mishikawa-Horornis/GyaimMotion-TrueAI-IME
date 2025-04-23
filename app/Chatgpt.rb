require 'net/http'
require 'json'
require 'uri'

module ChatGPT
  def self.query(persona, prompt)
    api_key = ENV["OPENAI_API_KEY"]
    uri = URI("https://api.openai.com/v1/chat/completions")
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    }
    system_prompt = case persona
      when "女子高生" then "あなたは明るく元気な女子高生として話します。"
      when "極道" then "あなたは昭和任侠映画の極道として話します。"
      when "執事" then "あなたは冷静沈着な執事として話します。"
      else "親しみやすく丁寧に話してください。"
    end
    body = {
      model: "gpt-4o",
      messages: [
        { role: "system", content: system_prompt },
        { role: "user", content: prompt }
      ],
      max_tokens: 100,
      temperature: 0.8
    }
    res = Net::HTTP.post(uri, body.to_json, headers)
    json = JSON.parse(res.body)
    if json["choices"]
      json["choices"][0]["message"]["content"]
    else
      "ChatGPT応答エラー: #{json["error"]["message"]}"
    end
  end
end