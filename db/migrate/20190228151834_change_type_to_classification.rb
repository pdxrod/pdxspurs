class ChangeTypeToClassification < ActiveRecord::Migration[5.2]
  def change
    remove_column :fruits, :type
    add_column :fruits, :classification, :string
  end
end
