module PpwmMatcher
  class User < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    attr_accessible :email, :code_id
    belongs_to :code
    validates :email, presence: true

    def has_pair?
      !!pair
    end

    def pair
      return false unless code_id

      User.where(:code_id => self.code_id).detect{|u| u != self }
    end

    def self.current(github_user)
      where(:github_login => github_user.login).limit(1).first
    end

    def self.find_or_create(email, github_user)
      user = where(:email => email).limit(1).first
      unless user
        user = User.new(email: email)
        user.gravatar_id = github_user.gravatar_id
        user.github_login = github_user.login
        user.save
      end
      user
    end
  end
end
