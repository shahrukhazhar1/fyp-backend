class ChangeDataTypesForQuestionAndAnswers < ActiveRecord::Migration
  def change
  	change_column :questions, :text, :text
  	change_column :answers, :text, :text
  end
end
