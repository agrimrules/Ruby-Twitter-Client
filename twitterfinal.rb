require 'json'
require 'jsonpath'
require 'rubygems'
require 'oauth'
require 'net/https'
require 'uri'

print "What hashtag are you searching for?"
input = gets.chomp
query=URI.encode_www_form("q" => input)
uri = URI.parse("https://api.twitter.com/1.1/search/tweets.json?#{query}&result_type=recent")
http = Net::HTTP.new(uri.host, uri.port)
http.read_timeout = 30
http.use_ssl=true
http.verify_mode=OpenSSL::SSL::VERIFY_PEER
consumer_key ||= OAuth::Consumer.new "Your Consumer Key","Your Consumer Secret"
access_token ||= OAuth::Token.new "Your Access Token","Your Access Secret"
request = Net::HTTP::Get.new(uri.request_uri)

request.oauth! http, consumer_key, access_token
http.start
response=http.request request

def print_line(tweets)
	path=JsonPath.new("$..text")
	puts path.on(tweets)
end

if response.code =='200' then
	tweets=JSON.parse(response.body)
	print_line(tweets)
else
	puts response.code
	puts uri
end
nil
