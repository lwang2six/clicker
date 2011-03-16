class ChangeAnswersCorrectDefault < ActiveRecord::Migration
  def self.up
    change_column :answers, :correct, :boolean, :default => 0
  end

  def self.down
  end
end
