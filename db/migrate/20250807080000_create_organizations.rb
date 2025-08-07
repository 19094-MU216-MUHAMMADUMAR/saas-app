class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :plan, default: 'free'
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      
      t.timestamps
    end
    
    add_index :organizations, :stripe_customer_id
  end
end
