class AddRoleAndOrganizationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, default: 'employee'
    add_reference :users, :organization, null: true, foreign_key: true
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    
    # Remove tenant_id as we're using organization_id now
    remove_reference :users, :tenant, foreign_key: true if column_exists?(:users, :tenant_id)
  end
end
