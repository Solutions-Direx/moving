class AddInternalNoteToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :internal_note, :text
  end
end
