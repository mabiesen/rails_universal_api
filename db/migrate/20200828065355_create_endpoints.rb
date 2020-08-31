class CreateEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :endpoints do |t|
      t.text :name
      t.text :url_path
      t.json :params
      t.text :client_tag
      t.text :request_method
      t.json :body_template

      t.timestamps
    end
  end
end
