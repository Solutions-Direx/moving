class CreateQuoteDocuments < ActiveRecord::Migration
  def change
    create_table :quote_documents do |t|
      t.integer :quote_id
      t.integer :document_id

      t.timestamps
    end
  end
end
