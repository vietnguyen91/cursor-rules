# 🚀 Quick Install Guide - Cursor Rules Agent

## 📋 Installation Methods

### 🔓 Public Repository Installation

If the repository is public, installation is straightforward:

```bash
# Method 1: Shell script (recommended)
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Method 2: NPX
npx cursor-rules-agent-installer

# Method 3: Git clone
git clone https://github.com/vietnguyen91/cursor-rules.git
cd cursor-rules/cursor-rules-agent
npm run install-local
```

---

### 🔐 Private Repository Installation

For private repositories, you'll need a GitHub token:

#### **Step 1: Create GitHub Token**

1. Go to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. Configure token:
   - **Name**: `Cursor Rules Agent`
   - **Scopes**: Select `repo` (for private repositories)
   - **Expiration**: Choose appropriate duration
4. **Copy the token** - you'll need it for installation

#### **Step 2: Install with Token**

Choose one of these methods:

**🔧 Method A: Environment Variable (Recommended)**
```bash
# Set token and install in one command
export GITHUB_TOKEN=your_github_token_here
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
```

**🔧 Method B: .env File**
```bash
# Create .env file in your project directory
echo "GITHUB_TOKEN=your_github_token_here" > .env

# Run installer (it will auto-detect the token)
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
```

**🔧 Method C: NPX with Token**
```bash
# Set token for Node.js installer
export GITHUB_TOKEN=your_github_token_here
npx cursor-rules-agent-installer
```

**🔧 Method D: Git Clone with Authentication**
```bash
# Clone with token authentication
git clone https://your_token@github.com/vietnguyen91/cursor-rules.git
cd cursor-rules/cursor-rules-agent
GITHUB_TOKEN=your_token npm run install-local
```

---

## 🔄 For Existing Projects

Already have a project and want to integrate this workflow system?

### Quick Setup for Existing Projects

```bash
# One-line setup for existing projects
curl -sSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/setup-existing.sh | bash

# Or manual integration
git clone https://github.com/vietnguyen91/cursor-rules.git .cursor-rules-temp
cp -r .cursor-rules-temp/cursor-rules-agent/src .cursor-rules/
cp .cursor-rules-temp/cursor-rules-agent/EXISTING_PROJECT_SETUP.md ./
rm -rf .cursor-rules-temp
```

### What the Setup Does:
- ✅ **Analyzes your existing code** and project structure
- ✅ **Auto-detects project type** (web app, scraping, etc.)
- ✅ **Creates documentation structure** without affecting your code
- ✅ **Configures workflow modes** based on current project state
- ✅ **Preserves all existing files** and folder structure

### Project State Detection:
- **Has Source Code** → Developing Mode or Planning Mode
- **Scraping Project** → Integration Testing Mode  
- **Production System** → Content Sync Mode
- **Need New Features** → Brainstorming/Planning Mode

📋 **[Complete Existing Project Guide](./EXISTING_PROJECT_SETUP.md)** - Detailed integration instructions

---

## ⚡ Quick Start Commands

After installation, try these commands in Cursor:

### 🌐 For Website Cloning Projects
```bash
"clone website https://example.com"
"analyze all sources for data consistency"
"setup multi-source scraping architecture"
```

### 🛠 For General Development Projects
```bash
"bootstrap project structure"
"brainstorm new feature ideas"
"plan feature: User Authentication"
"work on TASK_001"
```

---

## 🔧 Environment Configuration

### Required Environment Variables

```bash
# .env file template
# GitHub Authentication (for private repositories)
GITHUB_TOKEN=your_github_token_here

# Database Configuration (for website clones)
MONGODB_URI=mongodb://localhost:27017/your_database
REDIS_URL=redis://localhost:6379

# Storage Configuration
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_S3_BUCKET=your_s3_bucket

# Application Configuration
NODE_ENV=development
PORT=3000
API_BASE_URL=http://localhost:3000
```

### User Rules Setup

1. Copy content from `USER_RULES_TEMPLATE.md`
2. Paste into **Cursor Settings > Rules > User Rules**
3. This enables the AI workflow system

---

## 🐛 Troubleshooting

### Common Issues

**❌ "Repository requires authentication"**
```bash
# Solution: Set GitHub token
export GITHUB_TOKEN=your_token_here

# Or create .env file:
echo "GITHUB_TOKEN=your_token_here" > .env
```

**❌ "Failed to download files"**
- Check your GitHub token has `repo` scope
- Verify token hasn't expired
- Ensure you're connected to the internet

**❌ "Permission denied"**
```bash
# Ensure you have write permissions
chmod +w .
sudo chown $USER:$USER .
```

**❌ "Command not found: curl"**
```bash
# Install curl (Ubuntu/Debian)
sudo apt update && sudo apt install curl

# Install curl (macOS)
brew install curl

# Install curl (Windows/WSL)
sudo apt install curl
```

---

## 📂 What Gets Installed

```
your-project/
├── .cursor/rules/              # AI workflow rules
│   ├── core/                   # Core orchestrator files
│   ├── modes/                  # Mode-specific rules
│   ├── utilities/              # Safety & enforcement
│   └── templates/              # Task & blueprint templates
├── docs/                       # Documentation structure
│   ├── specs/                  # Technical specifications
│   ├── features/               # Feature definitions
│   ├── targets/                # Target analysis (website clones)
│   ├── blueprints/             # Architecture templates
│   └── tasks/                  # Task management
│       └── task-index.json     # Central task tracking
├── .env.example                # Environment template
├── .gitignore                  # Git ignore rules
├── USER_RULES_TEMPLATE.md      # Cursor user rules
├── MULTI_SOURCE_WORKFLOW_EXAMPLE.md
├── WEBSITE_CLONE_WORKFLOW_EXAMPLE.md
└── QUICK_INSTALL_GUIDE.md      # This guide
```

---

## 🚀 Advanced Installation Options

### Docker Installation
```bash
# Run installer in Docker
docker run --rm -v $(pwd):/workspace -w /workspace \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  node:18-alpine sh -c "
    apk add --no-cache curl bash &&
    curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
  "
```

### CI/CD Integration
```yaml
# GitHub Actions example
- name: Install Cursor Rules Agent
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
```

### Automated Team Setup
```bash
#!/bin/bash
# team-setup.sh - Deploy to entire team

# Set your team's private repository
export GITHUB_TOKEN=${TEAM_GITHUB_TOKEN}

# Install in multiple projects
for project in project1 project2 project3; do
  cd $project
  curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
  cd ..
done
```

---

## 📚 Next Steps

1. **Configure Cursor**: Add User Rules to Cursor Settings
2. **Set Environment**: Copy `.env.example` to `.env` and configure
3. **Try Commands**: Start with `"bootstrap project structure"`
4. **Read Examples**: Check `WEBSITE_CLONE_WORKFLOW_EXAMPLE.md`
5. **Join Community**: [GitHub Discussions](https://github.com/vietnguyen91/cursor-rules/discussions)

---

## 🤝 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/vietnguyen91/cursor-rules/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/vietnguyen91/cursor-rules/discussions)
- 📖 **Documentation**: [README.md](README.md)

---

**Happy coding! 🎉** 