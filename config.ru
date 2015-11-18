require "json"
require "rack"
require "rack/request"
require "rack/response"
require "faker"

module Slack
  class TeamChat
    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new

      room = if req["text"].nil?
               [:ingverb, :adjective, :noun].map { |m|
                 Faker::Hacker.send(m)
               }.join("-").gsub(" ", "-")
             else
               req["text"].split(" ").join("-")
             end

      hash = { "text" => "https://teamch.at/#{room}" }

      res.write hash.to_json
      res["Content-Type"] = "application/json"
      res.status = 200
      res.finish
    end
  end
end

run Slack::TeamChat.new
