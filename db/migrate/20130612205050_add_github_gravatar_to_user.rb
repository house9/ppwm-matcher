class AddGithubGravatarToUser < ActiveRecord::Migration
  def up
    add_column :ppwm_matcher_users, :gravatar_id, :string
    add_column :ppwm_matcher_users, :github_login, :string
  end

  def down
    remove_column :ppwm_matcher_users, :gravatar_id
    remove_column :ppwm_matcher_users, :github_login
  end
end