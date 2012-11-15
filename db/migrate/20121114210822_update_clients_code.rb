class UpdateClientsCode < ActiveRecord::Migration
  def change
  	Client.all.each do |client|
      code_generation = "%05d" % (client.id)
      code = client.commercial? ? "C#{code_generation}" : "R#{code_generation}"
      client.update_column(:code, code)
    end
    PgSearch::Multisearch.rebuild(Client)
  end
end