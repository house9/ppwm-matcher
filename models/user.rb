module PpwmMatcher
  class User < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    attr_accessible :email, :code_id
    belongs_to :code

    def has_pair?
      !!pair
    end

    def pair
      return false unless code_id

      User.where(:code_id => self.code_id).detect{|u| u != self }
    end

    def update_with_code(code)
      update_attribute(:code_id, code.id)
    end
  end
end
