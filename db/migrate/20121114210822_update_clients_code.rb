class UpdateClientsCode < ActiveRecord::Migration
  def change
  	Client.all.each do |client|
      client.update_attribute(:updated_at, Time.now)
    end
  end
end