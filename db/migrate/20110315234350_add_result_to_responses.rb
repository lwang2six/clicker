class AddResultToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :result, :boolean
  end

  def self.down
    remove_column :responses, :result
  end
end
