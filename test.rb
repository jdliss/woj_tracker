# frozen_string_literal: true

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

tweets = client.user_timeline('wojespnbot', count: 200)

tweets.each do |tweet|
  text = tweet.full_text
  if /has been traded/.match?(text)
    match = /(.+?) has been traded for (.+) and (.+),/.match(text)
    player1 = match[1]
    player2 = match[2]
    package = match[3]

    puts "[#{player1}] traded for [#{player2}] and [#{package}]"
  elsif /will opt out/.match?(text)
    match = /(.+) will opt out of his contract and\s+will sign with the (.+),/.match(text)
    player = match[1]
    team = match[2]

    puts "[#{player}] opts out and signs with [#{team}]"
  elsif /have turned down/.match?(text)
    match = /The (.+) have turned down (.+)\'s option, who\s+will sign with the (.+),/.match(text)
    team1 = match[1]
    player = match[2]
    team2 = match[3]

    puts "[#{team1}] decline [#{player}]'s option, and he will sign with the [#{team2}]"
  elsif /will not pick up/.match?(text)
    match = /(.+) will not pick up (.+)\'s option, and he will sign with the (.+),/.match(text)
    team1 = match[1]
    player = match[2]
    team2 = match[3]

    puts "[#{team1}] will not pick up [#{player}]'s option, and he will sign with the [#{team2}]"
  elsif /will sign with/.match?(text)
    match = /(.+) will sign with the (.+?)(?= after|,)/.match(text)
    player = match[1]
    team = match[2]

    puts "[#{player}] signs with the [#{team}]"
  else
    puts "Unknown tweet category: #{text}"
  end
end
