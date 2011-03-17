class ChangeColumnCorrectInAnswers < ActiveRecord::Migration
  def self.up
    change_column :answers, :correct, :boolean, :default => false
  end

  def self.down
    change_column :answers, :correct, :boolean, :default => 0
  end
end
