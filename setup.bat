@echo off
REM Quick setup script for Glue Pipeline development (Windows)

echo.
echo 🚀 Setting up Glue Pipeline Development Environment...
echo.

REM Check Python version
python --version
echo ✓ Python found

REM Create virtual environment
if not exist "venv" (
    echo 📦 Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
echo 🔧 Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo 📥 Upgrading pip...
python -m pip install --upgrade pip setuptools wheel

REM Install dependencies
echo 📚 Installing dependencies...
pip install -r requirements.txt

REM Install development dependencies
echo 🛠️  Installing development dependencies...
pip install pytest pytest-cov black flake8 mypy pre-commit

REM Create directories
echo 📁 Creating directories...
if not exist logs mkdir logs
if not exist data\input mkdir data\input
if not exist data\output mkdir data\output

REM Display summary
echo.
echo ✅ Setup complete!
echo.
echo 📖 Next steps:
echo    1. Activate virtual environment: venv\Scripts\activate.bat
echo    2. Update configuration files in config/
echo    3. Run tests: pytest tests/ -v
echo    4. Deploy: python scripts/deploy_glue_job.py --environment dev
echo.
echo 📚 Documentation:
echo    - README.md - Project overview
echo    - ARCHITECTURE.md - System design
echo    - DEPLOYMENT.md - Deployment guide
echo    - DEVELOPMENT.md - Development guide
echo.
pause
