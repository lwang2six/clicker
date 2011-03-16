class AddQuestionNumberToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :count, :integer, :default => 0
  end

  def self.down
    remove_column :questions, :count
  end
end
