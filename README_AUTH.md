# Phoenix LiveView Authentication System

A comprehensive, secure authentication system built with Phoenix LiveView that provides user registration, login, password management, and session handling with real-time features.

## 🚀 Features

### Core Authentication

- **User Registration** with email verification
- **Secure Login** with remember me option
- **Password Reset** via email
- **Account Settings** management
- **Email Change** with verification
- **Session Management** with secure tokens

### LiveView Integration

- **Real-time Authentication** state management
- **Interactive Components** for auth status
- **Protected Content** wrapper components
- **User Avatar** generation with initials
- **Live Navigation** updates

### Security Features

- **bcrypt Password Hashing** with configurable cost
- **CSRF Protection** on all forms
- **Session Tokens** instead of predictable IDs
- **Secure Cookies** for remember me functionality
- **Email Verification** for new accounts
- **Rate Limiting** ready (can be added with Hammer)

## 🏗 Architecture

The system is organized into several key modules:

- `LivePlayground.Accounts` - User context and data operations
- `LivePlaygroundWeb.UserAuth` - Authentication plugs and session management
- `LivePlaygroundWeb.AuthLive.*` - Custom LiveView modules for enhanced UX
- `LivePlaygroundWeb.AuthLive.Components` - Reusable authentication components
- `LivePlaygroundWeb.AuthLive.Helpers` - Utility functions for auth operations

## 📁 File Structure

```
lib/
├── live_playground/
│   └── accounts/
│       ├── user.ex                    # User schema
│       ├── user_token.ex              # Session token management
│       └── user_notifier.ex           # Email notifications
├── live_playground_web/
│   ├── user_auth.ex                   # Authentication plugs
│   ├── live/
│   │   ├── auth_live/
│   │   │   ├── components.ex          # Reusable auth components
│   │   │   ├── helpers.ex             # Auth utility functions
│   │   │   ├── demo.ex                # Interactive demo page
│   │   │   ├── navigation.ex          # Feature showcase
│   │   │   ├── login.ex               # Enhanced login (alternative)
│   │   │   ├── register.ex            # Enhanced registration
│   │   │   ├── forgot_password.ex     # Password reset request
│   │   │   ├── reset_password.ex      # Password reset form
│   │   │   ├── settings.ex            # Account settings
│   │   │   └── user_management.ex     # Admin user management
│   │   ├── user_login_live.ex         # Generated login LiveView
│   │   ├── user_registration_live.ex  # Generated registration
│   │   ├── user_settings_live.ex      # Generated settings
│   │   └── ...other generated files
│   └── router.ex                      # Route definitions
```

## 🛠 Setup & Installation

### 1. Generate Base Authentication System

```bash
mix phx.gen.auth Accounts User users
```

### 2. Install Dependencies

```bash
mix deps.get
```

### 3. Run Database Migrations

```bash
mix ecto.migrate
```

### 4. Start the Server

```bash
mix phx.server
```

## 🔗 Available Routes

### Public Routes (No Authentication Required)

- `/auth-demo` - Interactive authentication demo
- `/auth-nav` - Feature navigation and overview
- `/users/register` - User registration
- `/users/log_in` - User login
- `/users/reset_password` - Password reset request
- `/users/reset_password/:token` - Password reset form
- `/users/confirm/:token` - Email confirmation
- `/users/confirm` - Request confirmation instructions

### Protected Routes (Authentication Required)

- `/users/settings` - Account settings
- `/auth/user-management` - User management (demo)

### Session Management

- `POST /users/log_in` - Process login
- `DELETE /users/log_out` - Process logout

## 🧩 Components Usage

### Authentication Menu Banner

```heex
<.auth_menu current_user={@current_user} />
```

### User Avatar

```heex
<.avatar user={@current_user} class="w-8 h-8" />
```

### Protected Content Wrapper

```heex
<.protected_content current_user={@current_user}>
  <!-- Your protected content here -->
</.protected_content>
```

## 🔒 Security Implementation

### Password Security

- **bcrypt hashing** with cost factor 12
- **Salt generation** using secure random bytes
- **Password validation** with length and complexity rules

### Session Security

- **Cryptographically secure tokens** (256-bit)
- **Session rotation** on login/logout
- **HttpOnly cookies** for remember me
- **CSRF token validation** on all state-changing operations

### Email Security

- **Time-limited verification tokens**
- **Secure token generation** using Phoenix.Token
- **Email rate limiting** (can be implemented)

## 📱 LiveView Features

### Real-time Authentication State

```elixir
# In your LiveView
def mount(_params, _session, socket) do
  case socket.assigns.current_user do
    nil ->
      {:ok, redirect(socket, to: "/users/log_in")}
    user ->
      {:ok, assign(socket, :user, user)}
  end
end
```

### Protected LiveView Routes

```elixir
# In your router
live_session :protected,
  on_mount: [{LivePlaygroundWeb.UserAuth, :ensure_authenticated}] do
  live "/dashboard", DashboardLive
  live "/profile", ProfileLive
end
```

## 🎨 Customization

### Styling

All components use Tailwind CSS classes and can be customized by modifying the class attributes in the component files.

### Adding Custom Fields

1. Create a migration to add the field
2. Update the User schema
3. Update changeset functions
4. Modify forms in LiveViews

### Email Templates

Customize email templates in `UserNotifier` module. HTML emails can be added alongside the existing text emails.

### Authentication Logic

Add custom authentication requirements by implementing additional plugs or modifying the existing `UserAuth` module.

## 🧪 Testing

The system includes comprehensive tests for:

- User registration and login flows
- Password reset functionality
- Email verification
- Session management
- LiveView authentication features

Run tests with:

```bash
mix test
```

## 🚀 Deployment Considerations

### Environment Configuration

- Set secure session keys in production
- Configure email delivery service
- Set up proper database credentials
- Enable SSL/TLS for security

### Production Security

- Use HTTPS in production
- Set secure cookie flags
- Configure proper CORS headers
- Implement rate limiting
- Set up monitoring and alerting

## 📚 Additional Resources

- [Phoenix Authentication Guide](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Auth.html)
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/)
- [Comeonin (bcrypt) Documentation](https://hexdocs.pm/comeonin/)
- [Phoenix Security Best Practices](https://phoenixframework.readme.io/docs/security-considerations)

## 🤝 Contributing

This authentication system is designed to be a comprehensive example and starting point. Feel free to extend it with additional features such as:

- Two-factor authentication
- OAuth integration
- Role-based access control
- Audit logging
- Advanced session management

## 📄 License

This project is part of the Phoenix Playground and follows the same licensing terms.
