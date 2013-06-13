require 'logger'
require 'sinatra'
require 'sinatra_auth_github'
require 'sinatra/activerecord'
require './models/code'
require './models/code_matcher'
require './models/user'
require './models/github_auth'

module PpwmMatcher
  class App < Sinatra::Base
    enable :sessions

    set :github_options, PpwmMatcher::GithubAuth.options
    LOGGER = Logger.new(STDOUT)

    register Sinatra::Auth::Github

    helpers do
      def repos
        github_request("user/repos")
      end
    end

    get '/' do
      authenticate!
      setup_for_root_path
      erb :index, layout: :layout
    end

    get '/code/create' do
      authenticate!
      code = Code.create
    end

    get '/code' do
      authenticate!

      user = User.current(github_user) # TODO: refactor to helper method ?
      @pair = user.pair
      @code_value = user.code.value
      erb :code, layout: :layout
    end

    post '/code' do
      authenticate!

      matcher = CodeMatcher.new({
        github_user: github_user,
        email: params['email'],
        code: params['code']
      })

      if matcher.valid?
        code, user = matcher.assign_code_to_user
        @pair = user.pair
        @code_value = code.value
        erb :code, layout: :layout
      else
        setup_for_root_path(matcher.error_messages)
        erb :index, layout: :layout
      end
    end

    def setup_for_root_path(messages = nil)
      @code = params['code']
      @messages = messages
      @email = params['email'] || github_user.email
      @login = github_user.login
    end

  end
end
