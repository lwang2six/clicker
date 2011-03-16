class AddProblemSetIdToRepsonses < ActiveRecord::Migration
  def self.up
    add_column :responses, :problem_set_id, :integer, :default => 0
  end

  def self.down
    remove_column :responses, :problem_set_id
  end
end
