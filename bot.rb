require 'twitter'
require 'open-uri'

exit unless [0,2,4].include?(Time.now.min / 10)

class QueerEveryword
  WORD_LIST_URL = 'https://gist.githubusercontent.com/farisj/85c40bf777053442ae3686a326436aa6/raw'.freeze

  def tweet
    unless most_recent_word_index == word_list.length
      next_word = word_list[most_recent_word_index + 1]

      client.update("queer #{next_word}")
    end
  end

  private

  def most_recent_tweet
    @most_recent_tweet ||= client.user_timeline('queereveryword').first
  end

  def most_recent_word
    most_recent_word ||= most_recent_tweet.text.split[1]
  end

  def most_recent_word_index
    most_recent_word_index ||= word_list.find_index(most_recent_word)
  end

  def word_list
    @word_list ||= open(WORD_LIST_URL).read.split("\n")
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["consumer_key"]
      config.consumer_secret = ENV["consumer_secret"]
      config.access_token = ENV["access_token"]
      config.access_token_secret = ENV["access_token_secret"]
    end
  end
end

QueerEveryword.new.tweet
