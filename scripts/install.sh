#!/bin/bash

# 🤖 Cursor Rules Agent Installer Script
# Multi-Source Website Clone & AI Workflow System

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub configuration
GITHUB_REPO="vietnguyen91/cursor-rules"
GITHUB_BASE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/main"

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           🤖 Cursor Rules Agent v2.0.0 Installer            ║${NC}"
    echo -e "${BLUE}║        Multi-Source Website Clone & AI Workflow System      ║${NC}"
    echo -e "${BLUE}║                  Private Repository Support                  ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check for GitHub token and set authentication
setup_github_auth() {
    if [ -n "$GITHUB_TOKEN" ]; then
        print_status "GitHub token detected - using authenticated access"
        CURL_AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
        return 0
    fi
    
    # Check if token is in environment file
    if [ -f ".env" ] && grep -q "GITHUB_TOKEN" .env; then
        print_status "Loading GitHub token from .env file"
        export $(grep "GITHUB_TOKEN" .env | xargs)
        if [ -n "$GITHUB_TOKEN" ]; then
            CURL_AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
            return 0
        fi
    fi
    
    # Prompt user for token if repository is private
    print_warning "No GitHub token found. If this is a private repository, you'll need to provide a token."
    
    # Test if repository is accessible without token
    if curl -f -s "$GITHUB_BASE_URL/README.md" > /dev/null 2>&1; then
        print_status "Repository is publicly accessible"
        CURL_AUTH_HEADER=""
        return 0
    else
        print_error "Repository requires authentication. Please provide a GitHub token."
        echo ""
        echo "To create a GitHub token:"
        echo "1. Go to https://github.com/settings/tokens"
        echo "2. Click 'Generate new token (classic)'"
        echo "3. Select 'repo' scope for private repositories"
        echo "4. Copy the token and set it as an environment variable:"
        echo "   export GITHUB_TOKEN=your_token_here"
        echo ""
        echo "Then run this installer again."
        exit 1
    fi
}

# Download file with authentication
download_file() {
    local url="$1"
    local output="$2"
    local description="$3"
    
    if [ -n "$CURL_AUTH_HEADER" ]; then
        if curl -f -s -H "$CURL_AUTH_HEADER" "$url" -o "$output"; then
            print_status "Downloaded: $description"
            return 0
        else
            print_error "Failed to download: $description"
            print_error "URL: $url"
            return 1
        fi
    else
        if curl -f -s "$url" -o "$output"; then
            print_status "Downloaded: $description"
            return 0
        else
            print_error "Failed to download: $description"
            print_error "URL: $url"
            return 1
        fi
    fi
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed. Please install Git first."
        exit 1
    fi
    
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        print_error "Curl is required but not installed. Please install Curl first."
        exit 1
    fi
    
    # Check if we're in a directory where we can create files
    if [ ! -w "." ]; then
        print_error "No write permission in current directory. Please check permissions."
        exit 1
    fi
    
    print_success "Prerequisites check passed!"
}

# Detect project type
detect_project_type() {
    print_status "Detecting project type..."
    
    PROJECT_TYPE="general"
    
    # Check for package.json (Node.js project)
    if [ -f "package.json" ]; then
        if grep -q "scraping\|scraper\|spider" package.json 2>/dev/null; then
            PROJECT_TYPE="website-clone"
        elif grep -q "nuxt\|next\|react\|vue" package.json 2>/dev/null; then
            PROJECT_TYPE="web-app"
        fi
    fi
    
    # Check for specific patterns in directory names
    if [[ $(pwd) == *"clone"* ]] || [[ $(pwd) == *"scraper"* ]] || [[ $(pwd) == *"scraping"* ]]; then
        PROJECT_TYPE="website-clone"
    fi
    
    print_status "Detected project type: $PROJECT_TYPE"
}

# Create directory structure
create_directory_structure() {
    print_status "Creating directory structure..."
    
    # Create main directories
    mkdir -p .cursor/rules/{core,modes,utilities,templates}
    mkdir -p docs/{specs,features,targets,blueprints}
    mkdir -p docs/tasks
    
    print_success "Directory structure created!"
}

# Download cursor rules files with authentication
download_cursor_rules() {
    print_status "Downloading Cursor Rules Agent files..."
    
    # Create arrays of files to download
    declare -A core_files=(
        ["master-orchestrator.mdc"]="Core orchestrator"
        ["context-loader.mdc"]="Context loader"
    )
    
    declare -A mode_files=(
        ["multi-source-analysis-mode.mdc"]="Multi-source analysis mode"
        ["target-analysis-mode.mdc"]="Target analysis mode"
        ["architecture-planning-mode.mdc"]="Architecture planning mode"
        ["developing-mode.mdc"]="Developing mode"
        ["integration-testing-mode.mdc"]="Integration testing mode"
        ["content-sync-mode.mdc"]="Content sync mode"
        ["brainstorming-mode.mdc"]="Brainstorming mode"
        ["planning-agent.mdc"]="Planning agent mode"
        ["documenting-mode.mdc"]="Documenting mode"
        ["initializing-mode.mdc"]="Initializing mode"
    )
    
    declare -A utility_files=(
        ["safe-code-generation.mdc"]="Safe code generation utility"
        ["enforcer.mdc"]="Enforcer utility"
    )
    
    declare -A template_files=(
        ["target-analysis-template.md"]="Target analysis template"
        ["scraping-blueprint-template.yaml"]="Scraping blueprint template"
        ["blueprint-template.yaml"]="Blueprint template"
        ["task-template.md"]="Task template"
        ["task-index-template.json"]="Task index template"
        ["task-index-feature-template.json"]="Task index feature template"
    )
    
    declare -A doc_files=(
        ["USER_RULES_TEMPLATE.md"]="User rules template"
        ["MULTI_SOURCE_WORKFLOW_EXAMPLE.md"]="Multi-source workflow example"
        ["WEBSITE_CLONE_WORKFLOW_EXAMPLE.md"]="Website clone workflow example"
        ["QUICK_INSTALL_GUIDE.md"]="Quick install guide"
    )
    
    # Download core files
    for file in "${!core_files[@]}"; do
        download_file "$GITHUB_BASE_URL/src/core/$file" ".cursor/rules/core/$file" "${core_files[$file]}"
    done
    
    # Download mode files
    for file in "${!mode_files[@]}"; do
        download_file "$GITHUB_BASE_URL/src/modes/$file" ".cursor/rules/modes/$file" "${mode_files[$file]}"
    done
    
    # Download utility files
    for file in "${!utility_files[@]}"; do
        download_file "$GITHUB_BASE_URL/src/utilities/$file" ".cursor/rules/utilities/$file" "${utility_files[$file]}"
    done
    
    # Download template files
    for file in "${!template_files[@]}"; do
        download_file "$GITHUB_BASE_URL/src/templates/$file" ".cursor/rules/templates/$file" "${template_files[$file]}"
    done
    
    # Download documentation files to current directory
    for file in "${!doc_files[@]}"; do
        download_file "$GITHUB_BASE_URL/$file" "$file" "${doc_files[$file]}"
    done
    
    print_success "Cursor Rules Agent files downloaded!"
}

# Create task index based on project type
create_task_index() {
    print_status "Creating task index..."
    
    local project_name=$(basename "$(pwd)")
    local task_index_file="docs/tasks/task-index.json"
    
    cat > "$task_index_file" << EOF
{
  "project": {
    "name": "$project_name",
    "version": "1.0.0",
    "type": "$PROJECT_TYPE",
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  },
  "features": [],
  "statistics": {
    "total_tasks": 0,
    "completed_tasks": 0,
    "active_features": 0
  },
  "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
    
    print_success "Task index created!"
}

# Create project-specific configuration
create_project_config() {
    print_status "Creating project configuration..."
    
    case $PROJECT_TYPE in
        "website-clone")
            cat > .cursor-rules-config.js << 'EOF'
module.exports = {
  mode: "website-clone",
  target_analysis: {
    legal_compliance: true,
    performance_baseline: true,
    content_structure_mapping: true
  },
  scraping_strategy: {
    multi_layer_architecture: true,
    intelligent_rate_limiting: true,
    content_deduplication: true
  },
  deployment: {
    staging_validation: true,
    production_monitoring: true,
    automated_rollback: true
  }
}
EOF
            ;;
        *)
            cat > .cursor-rules-config.js << 'EOF'
module.exports = {
  mode: "general",
  workflow: {
    auto_mode_detection: true,
    context_optimization: true,
    mcp_tools_integration: true
  },
  development: {
    safe_code_generation: true,
    automated_testing: true,
    documentation_sync: true
  }
}
EOF
            ;;
    esac
    
    print_success "Project configuration created!"
}

# Create environment template
create_env_template() {
    if [ ! -f ".env.example" ]; then
        print_status "Creating environment template..."
        cat > .env.example << 'EOF'
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
EOF
        print_success "Environment template created!"
    fi
}

# Setup gitignore if needed
setup_gitignore() {
    if [ ! -f .gitignore ]; then
        print_status "Creating .gitignore..."
        cat > .gitignore << 'EOF'
# Cursor Rules Agent
.cursor-rules-config.local.js
docs/tasks/active/
*.log

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
        print_success ".gitignore created!"
    fi
}

# Print next steps
print_next_steps() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    🎉 Installation Complete!                ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📁 Files installed:${NC}"
    echo "   ✅ .cursor/rules/ - All workflow rules"
    echo "   ✅ docs/ - Project documentation structure"
    echo "   ✅ Configuration files"
    echo "   ✅ Templates and examples"
    echo ""
    
    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${BLUE}🔐 Authentication:${NC}"
        echo "   ✅ GitHub token configured for private repository access"
        echo ""
    fi
    
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo ""
    echo -e "${YELLOW}1.${NC} Open Cursor IDE in this directory"
    echo -e "${YELLOW}2.${NC} Copy USER_RULES_TEMPLATE.md content to Cursor Settings > Rules"
    
    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        echo -e "${YELLOW}3.${NC} Copy .env.example to .env and configure your environment variables"
        echo -e "${YELLOW}4.${NC} Start using the agent with one of these commands:"
    else
        echo -e "${YELLOW}3.${NC} Start using the agent with one of these commands:"
    fi
    
    echo ""
    
    case $PROJECT_TYPE in
        "website-clone")
            echo -e "   ${GREEN}\"clone website https://example.com\"${NC}"
            echo -e "   ${GREEN}\"analyze all sources for data consistency\"${NC}"
            ;;
        *)
            echo -e "   ${GREEN}\"bootstrap project structure\"${NC}"
            echo -e "   ${GREEN}\"brainstorm new feature ideas\"${NC}"
            echo -e "   ${GREEN}\"plan feature: User Authentication\"${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "   📖 MULTI_SOURCE_WORKFLOW_EXAMPLE.md - Real-world example"
    echo "   🌐 WEBSITE_CLONE_WORKFLOW_EXAMPLE.md - Clone methodology"
    echo "   ⚙️ USER_RULES_TEMPLATE.md - Customization guide"
    echo "   🚀 QUICK_INSTALL_GUIDE.md - Installation options"
    echo ""
    echo -e "${BLUE}🤝 Support:${NC}"
    echo "   🐛 Issues: https://github.com/vietnguyen91/cursor-rules/issues"
    echo "   💬 Discussions: https://github.com/vietnguyen91/cursor-rules/discussions"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
    echo ""
}

# Main installation function
main() {
    print_header
    check_prerequisites
    setup_github_auth
    detect_project_type
    create_directory_structure
    download_cursor_rules
    create_task_index
    create_project_config
    create_env_template
    setup_gitignore
    print_next_steps
}

# Run the installer
main "$@" 