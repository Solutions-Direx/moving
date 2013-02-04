class UpdateClientCode < ActiveRecord::Migration
  def up
    Client.all.each do |client|
      code_generation = "%05d" % (client.id)
      code = client.commercial? ? "C#{code_generation}" : "R#{code_generation}"
      client.update_column(:code, code)
    end
  end

  def down
  end
end
