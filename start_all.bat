@echo off
setlocal enabledelayedexpansion

echo Starting all services...

REM Start MySQL with Docker Compose
if exist docker-compose.yml (
    echo Starting MySQL with Docker Compose...
    docker-compose up -d
) else (
    echo docker-compose.yml not found!
    exit /b 1
)

REM Install backend dependencies
if exist backend (
    echo Installing backend dependencies...
    cd backend
    if exist requirements.txt (
        pip install -r requirements.txt
    ) else (
        pip install fastapi uvicorn sqlalchemy pymysql python-dotenv pydantic
    )
    cd ..
) else (
    echo backend directory not found!
    exit /b 1
)

REM Start backend server
cd backend
start "Backend Server" cmd /k "uvicorn src.main:app --reload --host 0.0.0.0 --port 8090"
cd ..

REM Install frontend dependencies
if exist frontend\operations-chatbot (
    echo Installing frontend dependencies...
    cd frontend\operations-chatbot
    npm install
    REM Start frontend server
    start "Frontend Server" cmd /k "npm run dev"
    cd ..\..
) else (
    echo frontend\operations-chatbot directory not found!
    exit /b 1
)

echo All services started!
echo Backend: http://localhost:8090
echo Frontend: http://localhost:5173 (or as shown in terminal)

pause 