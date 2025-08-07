# This file should ensure the existence of records required to run the application.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample organization and admin user for development
if Rails.env.development?
  puts "Creating sample data for development..."
  
  # Create organization
  organization = Organization.find_or_create_by!(name: "Demo Company") do |org|
    org.plan = "premium"
  end
  
  puts "Created organization: #{organization.name}"
  
  # Create admin user
  admin_user = User.find_or_create_by!(email: "admin@demo.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.first_name = "Admin"
    user.last_name = "User"
    user.role = "admin"
    user.organization = organization
    user.confirmed_at = Time.current
  end
  
  puts "Created admin user: #{admin_user.email}"
  
  # Create employee user
  employee_user = User.find_or_create_by!(email: "employee@demo.com") do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    user.first_name = "Employee"
    user.last_name = "User"
    user.role = "employee"
    user.organization = organization
    user.confirmed_at = Time.current
  end
  
  puts "Created employee user: #{employee_user.email}"
  
  # Create sample projects
  ActsAsTenant.with_tenant(organization) do
    project1 = Project.find_or_create_by!(title: "Website Redesign") do |project|
      project.description = "Redesign the company website with modern UI/UX"
      project.status = "active"
      project.due_date = 1.month.from_now
      project.organization = organization
    end
    
    project2 = Project.find_or_create_by!(title: "Mobile App Development") do |project|
      project.description = "Develop iOS and Android mobile applications"
      project.status = "planning"
      project.due_date = 3.months.from_now
      project.organization = organization
    end
    
    project3 = Project.find_or_create_by!(title: "Database Migration") do |project|
      project.description = "Migrate legacy database to cloud infrastructure"
      project.status = "completed"
      project.due_date = 1.week.ago
      project.organization = organization
    end
    
    puts "Created sample projects: #{Project.count} total"
  end
  
  puts "Sample data created successfully!"
  puts "Login credentials:"
  puts "Admin: admin@demo.com / password123"
  puts "Employee: employee@demo.com / password123"
else
  puts "Seeds are only run in development environment"
end
