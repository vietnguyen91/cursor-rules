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
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed. Please install Git first."
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

# Download cursor rules files
download_cursor_rules() {
    print_status "Downloading Cursor Rules Agent files..."
    
    local base_url="https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main"
    
    # Core files
    curl -fsSL "$base_url/src/core/master-orchestrator.mdc" -o .cursor/rules/core/master-orchestrator.mdc
    curl -fsSL "$base_url/src/core/context-loader.mdc" -o .cursor/rules/core/context-loader.mdc
    
    # Mode files
    curl -fsSL "$base_url/src/modes/multi-source-analysis-mode.mdc" -o .cursor/rules/modes/multi-source-analysis-mode.mdc
    curl -fsSL "$base_url/src/modes/target-analysis-mode.mdc" -o .cursor/rules/modes/target-analysis-mode.mdc
    curl -fsSL "$base_url/src/modes/architecture-planning-mode.mdc" -o .cursor/rules/modes/architecture-planning-mode.mdc
    curl -fsSL "$base_url/src/modes/developing-mode.mdc" -o .cursor/rules/modes/developing-mode.mdc
    curl -fsSL "$base_url/src/modes/integration-testing-mode.mdc" -o .cursor/rules/modes/integration-testing-mode.mdc
    curl -fsSL "$base_url/src/modes/content-sync-mode.mdc" -o .cursor/rules/modes/content-sync-mode.mdc
    curl -fsSL "$base_url/src/modes/brainstorming-mode.mdc" -o .cursor/rules/modes/brainstorming-mode.mdc
    curl -fsSL "$base_url/src/modes/planning-agent.mdc" -o .cursor/rules/modes/planning-agent.mdc
    curl -fsSL "$base_url/src/modes/documenting-mode.mdc" -o .cursor/rules/modes/documenting-mode.mdc
    curl -fsSL "$base_url/src/modes/initializing-mode.mdc" -o .cursor/rules/modes/initializing-mode.mdc
    
    # Utility files
    curl -fsSL "$base_url/src/utilities/safe-code-generation.mdc" -o .cursor/rules/utilities/safe-code-generation.mdc
    curl -fsSL "$base_url/src/utilities/enforcer.mdc" -o .cursor/rules/utilities/enforcer.mdc
    
    # Template files
    curl -fsSL "$base_url/src/templates/target-analysis-template.md" -o .cursor/rules/templates/target-analysis-template.md
    curl -fsSL "$base_url/src/templates/scraping-blueprint-template.yaml" -o .cursor/rules/templates/scraping-blueprint-template.yaml
    curl -fsSL "$base_url/src/templates/blueprint-template.yaml" -o .cursor/rules/templates/blueprint-template.yaml
    curl -fsSL "$base_url/src/templates/task-template.md" -o .cursor/rules/templates/task-template.md
    curl -fsSL "$base_url/src/templates/task-index-template.json" -o .cursor/rules/templates/task-index-template.json
    curl -fsSL "$base_url/src/templates/task-index-feature-template.json" -o .cursor/rules/templates/task-index-feature-template.json
    
    # Documentation files
    curl -fsSL "$base_url/USER_RULES_TEMPLATE.md" -o USER_RULES_TEMPLATE.md
    curl -fsSL "$base_url/MULTI_SOURCE_WORKFLOW_EXAMPLE.md" -o MULTI_SOURCE_WORKFLOW_EXAMPLE.md
    curl -fsSL "$base_url/WEBSITE_CLONE_WORKFLOW_EXAMPLE.md" -o WEBSITE_CLONE_WORKFLOW_EXAMPLE.md
    
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

# Setup gitignore if needed
setup_gitignore() {
    if [ ! -f .gitignore ]; then
        print_status "Creating .gitignore..."
        cat > .gitignore << 'EOF'
# Cursor Rules Agent
.cursor-rules-config.local.js
docs/tasks/active/
*.log

# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

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
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo ""
    echo -e "${YELLOW}1.${NC} Open Cursor IDE in this directory"
    echo -e "${YELLOW}2.${NC} Copy USER_RULES_TEMPLATE.md content to Cursor Settings > Rules"
    echo -e "${YELLOW}3.${NC} Start using the agent with one of these commands:"
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
    detect_project_type
    create_directory_structure
    download_cursor_rules
    create_task_index
    create_project_config
    setup_gitignore
    print_next_steps
}

# Run the installer
main "$@" 