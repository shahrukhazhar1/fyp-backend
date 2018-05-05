class AddQuestionToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :question, index: true
  end
end
