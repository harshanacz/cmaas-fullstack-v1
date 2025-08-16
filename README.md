# Email Authentication System

A full-stack email authentication system using Ballerina backend with Appwrite and Next.js frontend.

## Architecture

- **Backend**: Ballerina with Appwrite integration
- **Frontend**: Next.js 15 with TypeScript
- **Authentication**: Appwrite Auth service
- **Database**: Appwrite Database

## Setup Instructions

### 1. Appwrite Setup

1. Create an account at [Appwrite Cloud](https://cloud.appwrite.io)
2. Create a new project
3. Go to Settings > API Keys and create a new API key with the following scopes:
   - `users.read`
   - `users.write`
   - `sessions.read`
   - `sessions.write`
4. Note down your:
   - Project ID
   - API Key
   - Endpoint (usually `https://cloud.appwrite.io`)

### 2. Backend Configuration

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Update `Config.toml` with your Appwrite credentials:
   ```toml
   appwriteEndpoint = "https://cloud.appwrite.io"
   appwriteProjectId = "YOUR_PROJECT_ID"
   appwriteApiKey = "YOUR_API_KEY"
   ```

3. Install Ballerina if not already installed:
   - Download from [ballerina.io](https://ballerina.io/downloads/)

4. Run the backend:
   ```bash
   bal run
   ```

The backend will start on `http://localhost:8080`

### 3. Frontend Configuration

1. Navigate to the client directory:
   ```bash
   cd client
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Update `.env.local` with your configuration:
   ```env
   NEXT_PUBLIC_APPWRITE_ENDPOINT=https://cloud.appwrite.io
   NEXT_PUBLIC_APPWRITE_PROJECT_ID=YOUR_PROJECT_ID
   NEXT_PUBLIC_API_URL=http://localhost:8080/api
   ```

4. Run the frontend:
   ```bash
   npm run dev
   ```

The frontend will start on `http://localhost:3000`

## Features

- ✅ User registration with email and password
- ✅ User login with email and password
- ✅ Protected dashboard for authenticated users
- ✅ User logout functionality
- ✅ Form validation with error handling
- ✅ Responsive design with Tailwind CSS
- ✅ TypeScript support
- ✅ CORS configuration for cross-origin requests

## API Endpoints

### Backend (Ballerina)

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/user` - Get current user (requires session token)
- `DELETE /api/auth/logout` - Logout user (requires session token)

### Request/Response Examples

#### Register
```json
// Request
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}

// Response
{
  "$id": "user_id",
  "name": "John Doe",
  "email": "john@example.com"
}
```

#### Login
```json
// Request
{
  "email": "john@example.com",
  "password": "password123"
}

// Response
{
  "$id": "session_id",
  "secret": "session_token",
  "userId": "user_id"
}
```

## Security Features

- Password validation (minimum 8 characters for registration)
- Email format validation
- Session-based authentication
- CORS protection
- Secure session token storage

## Development

### Project Structure

```
├── backend/
│   ├── Ballerina.toml
│   ├── Config.toml
│   └── main.bal
├── client/
│   ├── app/
│   ├── components/
│   ├── contexts/
│   ├── lib/
│   └── package.json
└── README.md
```

### Running in Development

1. Start the Ballerina backend:
   ```bash
   cd backend && bal run
   ```

2. Start the Next.js frontend:
   ```bash
   cd client && npm run dev
   ```

3. Open `http://localhost:3000` in your browser

## Troubleshooting

### Common Issues

1. **CORS Errors**: Ensure the backend CORS configuration matches your frontend URL
2. **Appwrite Connection**: Verify your Appwrite credentials in `Config.toml` and `.env.local`
3. **Session Issues**: Check that session tokens are being stored and sent correctly

### Logs

- Backend logs are displayed in the terminal where `bal run` is executed
- Frontend logs can be viewed in the browser console

## Next Steps

- Add email verification
- Implement password reset functionality
- Add social login options
- Implement role-based access control
- Add user profile management