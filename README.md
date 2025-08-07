# ProjectHub - Project Management SaaS

A comprehensive multi-tenant Project Management SaaS application built with Ruby on Rails 8.

## Features

### 🏢 Multi-Tenancy
- Organizations as tenants with data isolation
- User-organization relationships
- Subscription-based feature access

### 👥 User Management
- Role-based access control (Admin/Employee)
- Team member invitations via email
- User profile management

### 📋 Project Management
- Create, view, edit, and delete projects
- File uploads and management
- Project status tracking (Planning, Active, On Hold, Completed)
- Due date management
- Project limits based on subscription plan

### 💳 Subscription & Billing
- Stripe integration for secure payments
- Multiple subscription plans:
  - **Free**: 1 project
  - **Premium**: Unlimited projects
- Billing portal integration
- Webhook handling for subscription events

### 🎨 Modern UI
- Bootstrap 5.3.2 responsive design
- Professional dashboard with statistics
- Interactive forms and components

## Quick Start

### Prerequisites
- Ruby 3.4.0
- Rails 8.0.2
- SQLite3 (for development)

### Installation

1. **Clone and setup:**
   ```bash
   cd saas-app
   bundle install
   ```

2. **Database setup:**
   ```bash
   rails db:migrate
   rails db:seed
   ```

3. **Start the server:**
   ```bash
   rails server
   ```

4. **Access the application:**
   - Open http://localhost:3000
   - Login with demo credentials:
     - **Admin**: admin@demo.com / password123
     - **Employee**: employee@demo.com / password123

## Development Setup

The application includes sample data for development:

- **Demo Organization**: "Demo Company" with premium plan
- **Admin User**: Full access to all features
- **Employee User**: Limited access (view/manage projects)
- **Sample Projects**: 3 projects with different statuses

## Architecture

### Models
- `Organization`: Multi-tenant organizations with subscription plans
- `User`: Authentication with Devise + role-based access
- `Project`: Project management with file attachments

### Key Technologies
- **ActsAsTenant**: Multi-tenancy implementation
- **Devise + DeviseInvitable**: Authentication and invitations
- **Stripe**: Payment processing
- **Bootstrap**: UI framework
- **Active Storage**: File management

## Configuration

### Environment Variables
For production, set these environment variables:

```env
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_STARTER_PRICE_ID=price_...
STRIPE_PROFESSIONAL_PRICE_ID=price_...
STRIPE_ENTERPRISE_PRICE_ID=price_...
```

### Stripe Setup
1. Create a Stripe account
2. Set up Products and Pricing in Stripe Dashboard
3. Configure webhook endpoints for subscription events
4. Update the environment variables

## Usage

### Admin Features
- **Dashboard**: Overview of organization statistics
- **Project Management**: Full CRUD operations
- **Team Management**: Invite and manage users
- **Billing**: Manage subscriptions and payments
- **Organization Settings**: Update organization details

### Employee Features
- **Dashboard**: View project statistics
- **Projects**: View and manage assigned projects
- **Profile**: Update personal information

### Project Management
- Create projects with descriptions and due dates
- Upload and manage project files
- Track project status and progress
- Organize by teams and deadlines

---

**Built with ❤️ using Ruby on Rails 8**
