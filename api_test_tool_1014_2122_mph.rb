# 代码生成时间: 2025-10-14 21:22:49
# api_test_tool.rb
# This is a simple API testing tool using the Hanami framework.

require 'hanami'
require 'hanami/model'
require 'hanami/controller'
require 'hanami/router'
require 'hanami/validations'
require 'hanami/helpers'
require 'hanami/interactor'
require 'webrick'
require 'json'

# Define the API Test Tool
module ApiTestTool
  # Configuration
  class Configuration
    attr_accessor :host, :port

    def initialize
      @host = 'localhost'
      @port = 2300
    end
  end

  # Define the API Test Tool Controller
  class ApiController < Hanami::Controller
    include Hanami::Helpers::HttpRedirection
    include Hanami::Helpers::HttpBasicAuth
    include Hanami::Helpers::Parametrization

    # Define the index action
    def index
      @params = params.to_h
      render('index')
    end

    # Define the test action
    def test
      @params = params.to_h
      # Validate the parameters
      begin
        params['method'] = params['method'].to_sym
        params['url'] = URI.encode(params['url'])
        params['headers'] = JSON.parse(params['headers']) if params['headers']
        params['body'] = JSON.parse(params['body']) if params['body']

        # Perform the HTTP request
        response = Net::HTTP.start(uri.host, uri.port) do |http|
          case params['method']
          when :get
            http.get(uri.request_uri, params['headers'] || {})
          when :post
            http.post(uri.request_uri, params['body'].to_json, params['headers'] || {})
          when :put
            http.put(uri.request_uri, params['body'].to_json, params['headers'] || {})
          when :delete
            http.delete(uri.request_uri)
          else
            raise 'Unsupported HTTP method'
          end
        end

        # Return the response
        response_hash = response.to_hash
        response_hash['body'] = response.body
        response_hash
      rescue => e
        { error: e.message }
      end
    end
  end

  # Define the API Test Tool View
  class IndexView < Hanami::View
    def prepare
    end
  end

  # Define the API Test Tool Router
  class Router < Hanami::Router
    get '/', to: 'api_test_tool#index'
    post '/test', to: 'api_test_tool#test'
  end

  # Define the API Test Tool Server
  class Server < WEBrick::HTTPServer
    def initialize(config)
      super(config)
      @config = config
    end
  end

  # Start the API Test Tool
  def self.start
    config = Configuration.new
    Hanami::Model._load!
    Hanami::Controller._load!
    Hanami::View._load!
    Hanami::Router._load!

    server = Server.new(Port: config.port, Host: config.host)
    trap('INT') { server.shutdown }
    server.mount('/') { |req, res| ApiTestTool::Router.handle(req, res) }
    server.start
  end
end

# Start the API Test Tool
ApiTestTool.start