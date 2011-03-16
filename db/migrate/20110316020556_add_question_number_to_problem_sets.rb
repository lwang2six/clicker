class AddQuestionNumberToProblemSets < ActiveRecord::Migration
  def self.up
    add_column :problem_sets, :question_count, :integer, :default => 0
  end

  def self.down
    remove_column :problem_sets, :question_count
  end
end
