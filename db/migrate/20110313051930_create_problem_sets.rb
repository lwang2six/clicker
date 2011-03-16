class CreateProblemSets < ActiveRecord::Migration
  def self.up
    create_table :problem_sets do |t|
      t.string :title
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :problem_sets
  end
end
