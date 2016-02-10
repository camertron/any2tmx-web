require_relative 'app'

map '/' do
  use Any2TmxWeb::Application
  run Sinatra::Base
end
