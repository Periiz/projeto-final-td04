class ChangeDataTypeForBirthDate < ActiveRecord::Migration[6.0]
  def self.up
    change_table :collaborators do |t|
      t.change :birth_date, :date
    end
  end
  def self.down
    change_table :collaborators do |t|
      t.change :birth_date, :datetime
    end
  end
end
