require 'sinatra'
require 'sinatra/contrib'
require 'any2tmx'

module Any2TmxWeb
  class Application < Sinatra::Base
    Options = Struct.new(:source, :target, :source_locale, :target_locale)

    get '/' do
      erb :index
    end

    post '/convert' do
      content_type 'application/octet-stream'
      headers['Content-Disposition'] = "attachment; filename=\"#{params['target-locale']}.tmx\""
      source = params['source-file'][:tempfile].read
      target = params['target-file'][:tempfile].read
      options = Options.new(source, target, params['source-locale'], params['target-locale'])
      transform = transformer_class(params['file-type']).new(options)
      result = transform.result
      io = StringIO.new
      result.write(io)
      io.string
    end

    private

    def transformer_class(type)
      case type
        when 'yaml'
          Any2Tmx::Transforms::YamlTransform
        when 'json'
          Any2Tmx::Transforms::JsonTransform
        when 'xml'
          Any2Tmx::Transforms::AndroidTransform
      end
    end
  end
end
