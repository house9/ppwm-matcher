module PpwmMatcher
  class CodeMatcher
    def initialize(args = {})
      user_klass = args.fetch(:user_klass) { PpwmMatcher::User }
      code_klass = args.fetch(:code_klass) { PpwmMatcher::Code }

      github_user = args.fetch(:github_user)
      email = args.fetch(:email)
      submitted_code = args.fetch(:code)

      @user = user_klass.find_or_create(email, github_user)
      @code = code_klass.where(:value => submitted_code).limit(1).first
    end

    attr_reader :code, :user

    def assign_code_to_user
      PpwmMatcher::App::LOGGER.info "Matched #{user.email} to #{code.value}"
      code.assign_user user
      [code, user]
    end

    def valid?
      code && code.valid? && user.valid?
    end

    def error_messages
      messages = []
      messages << user.errors.full_messages unless user.errors.empty?
      messages << "Unknown code, try again" unless code

      if code && code.errors.any?
        messages << code.errors.full_messages
      end

      messages.flatten
    end
  end
end