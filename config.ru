require 'thoth'

log = File.new('log/sinatra.log', 'a')
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application
