#!/bin/bash

# Exit on error
set -e

# Start MySQL with Docker Compose
if [ -f docker-compose.yml ]; then
  echo "Starting MySQL with Docker Compose..."
  docker-compose up -d
else
  echo "docker-compose.yml not found!"
  exit 1
fi

# Install backend dependencies
if [ -d backend ]; then
  echo "Installing backend dependencies..."
  cd backend
  if [ -f requirements.txt ]; then
    pip install -r requirements.txt
  else
    pip install fastapi uvicorn sqlalchemy pymysql python-dotenv pydantic
  fi
  cd ..
else
  echo "backend directory not found!"
  exit 1
fi

# Start backend server
cd backend
nohup uvicorn src.main:app --reload --host 0.0.0.0 --port 8090 &
cd ..

# Install frontend dependencies
if [ -d frontend/operations-chatbot ]; then
  echo "Installing frontend dependencies..."
  cd frontend/operations-chatbot
  npm install
  # Start frontend server
  nohup npm run dev &
  cd ../..
else
  echo "frontend/operations-chatbot directory not found!"
  exit 1
fi

echo "All services started!"
echo "Backend: http://localhost:8090"
echo "Frontend: http://localhost:5173 (or as shown in terminal)" 