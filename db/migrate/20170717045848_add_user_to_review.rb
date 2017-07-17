class AddUserToReview < ActiveRecord::Migration[5.1]
  def change
    add_reference :reviews, :user, foreign_key: true, index: true
  end
end
