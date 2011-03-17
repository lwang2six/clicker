class ChangeAnswersCorrectDefault < ActiveRecord::Migration
  def self.up
    change_column :answers, :correct, :boolean, :default => false
  end

  def self.down
  end
end
