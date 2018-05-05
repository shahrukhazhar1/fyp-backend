class AddedAuthTokenToUser < ActiveRecord::Migration

  def up
    change_table :users do |t|
      t.string :authentication_token
      t.index :authentication_token
    end
    User.all.each do |user|
      user.authentication_token = Devise.friendly_token
      user.save
    end
  end

  def down
    change_table :users do |t|
      t.remove :authentication_token
    end
  end
end
