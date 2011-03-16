class AddSummaryToProblemSets < ActiveRecord::Migration
  def self.up
    add_column :problem_sets, :summary, :text
  end

  def self.down
    remove_column :problem_sets, :summary
  end
end
