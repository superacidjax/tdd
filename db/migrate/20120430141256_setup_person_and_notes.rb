class SetupPersonAndNotes < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :company_name
      t.timestamps
    end
    
    create_table :notes do |t|
      t.string :note_text
      t.belongs_to :person
      t.timestamps
    end
  end

  def down
    drop_table :people
    drop_table :notes
  end
end
