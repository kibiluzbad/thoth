When /^I search for ([\w\s]+)$/ do |query|
  browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  browser.get "/search/#{query.gsub(/\s/,'%20')}"
  @result = browser.last_response.body
end

Then /^([a-z]+) should contains ([\w\s]+)$/ do |attribute,value|
  json = JSON::parse(@result)
  json.each do |item|
      item[attribute].include?(value)
  end
  pending
end

