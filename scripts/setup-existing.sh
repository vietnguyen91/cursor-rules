#!/bin/bash

# 🔄 Existing Project Setup Script
# Automatically integrates Cursor Rules Agent workflow into existing projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script info
SCRIPT_VERSION="2.0.0"
REPO_URL="https://github.com/vietnguyen91/cursor-rules.git"

echo -e "${BLUE}🔄 Cursor Rules Agent - Existing Project Setup v${SCRIPT_VERSION}${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in a project directory
check_project_directory() {
    print_info "Checking project directory..."
    
    if [[ ! -f "package.json" && ! -f "*.py" && ! -f "*.php" && ! -f "*.rb" && ! -f "*.go" && ! -f "*.java" ]]; then
        print_warning "No obvious project files detected. Are you in a project directory?"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "Project directory confirmed"
}

# Check for existing .cursor-rules setup
check_existing_setup() {
    print_info "Checking for existing workflow setup..."
    
    if [[ -d ".cursor-rules" ]]; then
        print_warning "Existing .cursor-rules directory found"
        read -p "Overwrite existing setup? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        rm -rf .cursor-rules
    fi
    
    if [[ -f ".cursor-rules" ]]; then
        print_warning "Existing .cursor-rules file found"
        cp .cursor-rules .cursor-rules.backup
        print_info "Backed up to .cursor-rules.backup"
    fi
}

# Download and setup workflow files
setup_workflow() {
    print_info "Downloading workflow system..."
    
    # Clone temp repository
    git clone --depth 1 $REPO_URL .cursor-rules-temp 2>/dev/null || {
        print_error "Failed to clone repository. Check internet connection."
        exit 1
    }
    
    # Copy workflow files
    print_info "Installing workflow files..."
    cp -r .cursor-rules-temp/cursor-rules-agent/src .cursor-rules/
    cp .cursor-rules-temp/cursor-rules-agent/USER_RULES_TEMPLATE.md .cursor-rules/
    cp .cursor-rules-temp/cursor-rules-agent/EXISTING_PROJECT_SETUP.md ./
    cp .cursor-rules-temp/cursor-rules-agent/WEBSITE_CLONE_WORKFLOW_EXAMPLE.md ./
    cp .cursor-rules-temp/cursor-rules-agent/MULTI_SOURCE_WORKFLOW_EXAMPLE.md ./
    
    # Create knowledge directory
    mkdir -p .cursor-rules/knowledge
    cp .cursor-rules-temp/cursor-rules-agent/knowledge/* .cursor-rules/knowledge/
    
    # Clean up
    rm -rf .cursor-rules-temp
    
    print_success "Workflow files installed"
}

# Create project structure
create_project_structure() {
    print_info "Creating project structure..."
    
    # Create required directories
    mkdir -p docs/{tasks,features,specs,blueprints,targets}
    mkdir -p docs/templates
    
    # Get project name
    PROJECT_NAME=$(basename "$(pwd)")
    
    # Create task index if not exists
    if [[ ! -f "docs/tasks/task-index.json" ]]; then
        cat > docs/tasks/task-index.json << EOF
{
  "project_name": "${PROJECT_NAME}",
  "version": "1.0.0",
  "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "features": []
}
EOF
        print_success "Created task index"
    else
        print_info "Task index already exists"
    fi
    
    print_success "Project structure created"
}

# Analyze project type and state
analyze_project_state() {
    print_info "Analyzing project state..."
    
    PROJECT_TYPE="unknown"
    CURRENT_STATE="unknown"
    
    # Detect project type
    if [[ -f "package.json" ]]; then
        if grep -q "nuxt\|next\|vue\|react" package.json; then
            PROJECT_TYPE="web-app"
        fi
        if grep -q "scraping\|crawl\|spider" package.json; then
            PROJECT_TYPE="scraping"
        fi
    fi
    
    # Detect current state
    if [[ -d "src" || -d "app" || -d "pages" ]]; then
        CURRENT_STATE="has-code"
    elif [[ -d "docs" && $(find docs -name "*.md" | wc -l) -gt 0 ]]; then
        CURRENT_STATE="has-docs"
    else
        CURRENT_STATE="early-stage"
    fi
    
    print_info "Project type: ${PROJECT_TYPE}"
    print_info "Current state: ${CURRENT_STATE}"
}

# Create initial configuration
create_configuration() {
    print_info "Creating project configuration..."
    
    # Create .cursor-rules file
    cat > .cursor-rules << 'EOF'
## 🎯 Project-Specific Rules

### Project Context
- **Name**: {{PROJECT_NAME}}
- **Type**: {{PROJECT_TYPE}}
- **Current Phase**: {{CURRENT_STATE}}

### Workflow Configuration
- **Current Mode**: Auto-detect based on project state
- **Primary Features**: [To be documented]
- **Data Sources**: [To be identified]

### Development Priorities
1. [Priority 1 - To be defined]
2. [Priority 2 - To be defined]
3. [Priority 3 - To be defined]

## 📁 Project Structure Integration
The workflow system will create and manage these directories:
- `docs/` - All documentation and planning
- `.cursor-rules/` - Workflow system files
- Source code structure remains unchanged

## 🔄 Workflow Activation
The workflow will auto-detect your current mode based on project state.
No additional configuration required.

## 🚀 Next Steps
1. Open Cursor IDE in this project
2. Workflow will automatically detect current state
3. Follow the mode-specific guidance provided
4. See EXISTING_PROJECT_SETUP.md for detailed instructions
EOF

    # Replace placeholders
    sed -i.bak "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" .cursor-rules
    sed -i.bak "s/{{PROJECT_TYPE}}/${PROJECT_TYPE}/g" .cursor-rules
    sed -i.bak "s/{{CURRENT_STATE}}/${CURRENT_STATE}/g" .cursor-rules
    rm .cursor-rules.bak 2>/dev/null || true
    
    print_success "Configuration created"
}

# Create project analysis document
create_project_analysis() {
    print_info "Creating project analysis template..."
    
    mkdir -p docs/features/F01_ExistingSystem/requirements/
    
    cat > docs/features/F01_ExistingSystem/requirements/current-state-analysis.md << EOF
# Current State Analysis - ${PROJECT_NAME}

## 📊 Project Overview
- **Start Date**: $(date +"%Y-%m-%d")
- **Current Status**: [Development/Testing/Production]
- **Technology Stack**: [To be documented]
- **Team Size**: [Number]

## 🏗️ Architecture Assessment
### Frontend
- Framework: [React/Vue/Angular/etc.]
- UI Library: [Tailwind/Bootstrap/etc.]
- Build Tool: [Vite/Webpack/etc.]

### Backend
- Runtime: [Node.js/Python/PHP/etc.]
- Database: [MySQL/MongoDB/PostgreSQL/etc.]
- API Style: [REST/GraphQL/etc.]

### Infrastructure
- Hosting: [AWS/Vercel/etc.]
- Domain: [your-domain.com]
- CDN: [Cloudflare/etc.]

## 🎯 Current Features
[List existing features and their completion status]

## 🚧 Pending Work
[List incomplete features and next development phases]

## 📈 Performance Metrics
- Page Load Speed: [time]
- SEO Score: [score]
- Mobile Friendly: [Yes/No]
- Accessibility: [score]

## 🔍 Technical Debt
[List known issues and areas for improvement]

## 🎯 Next Development Phases
[List planned features and improvements]
EOF

    print_success "Project analysis template created"
}

# Add npm scripts if package.json exists
add_npm_scripts() {
    if [[ -f "package.json" ]]; then
        print_info "Adding workflow scripts to package.json..."
        
        # Check if jq is available for JSON manipulation
        if command -v jq >/dev/null 2>&1; then
            # Use jq for clean JSON manipulation
            jq '.scripts."workflow:status" = "echo \"Workflow Status: $(find docs/tasks -name \"*.json\" | wc -l) tasks configured\""' package.json > package.json.tmp
            jq '.scripts."workflow:docs" = "find docs -name \"*.md\" -exec echo \"📄 {}\" \\;"' package.json.tmp > package.json
            rm package.json.tmp
            print_success "Workflow scripts added to package.json"
        else
            print_warning "jq not available. Please manually add workflow scripts to package.json"
        fi
    fi
}

# Show completion message with next steps
show_completion() {
    echo ""
    echo -e "${GREEN}🎉 Setup Complete!${NC}"
    echo -e "${GREEN}==================${NC}"
    echo ""
    echo -e "${BLUE}📁 Files Created:${NC}"
    echo "  ✅ .cursor-rules/ - Workflow system"
    echo "  ✅ docs/ - Documentation structure"
    echo "  ✅ .cursor-rules - Project configuration"
    echo "  ✅ EXISTING_PROJECT_SETUP.md - Detailed guide"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo "  1. Open this project in Cursor IDE"
    echo "  2. Workflow will auto-detect your current state"
    echo "  3. Follow the mode-specific guidance"
    echo "  4. Read EXISTING_PROJECT_SETUP.md for details"
    echo ""
    echo -e "${BLUE}💡 Common Commands:${NC}"
    echo "  • \"analyze current project state\""
    echo "  • \"plan next development phase\""
    echo "  • \"start working on [feature]\""
    echo "  • \"document existing features\""
    echo ""
    echo -e "${YELLOW}📚 Documentation:${NC}"
    echo "  • EXISTING_PROJECT_SETUP.md - Setup guide"
    echo "  • WEBSITE_CLONE_WORKFLOW_EXAMPLE.md - Example workflow"
    echo "  • MULTI_SOURCE_WORKFLOW_EXAMPLE.md - Advanced example"
    echo ""
    print_success "Ready to enhance your project with intelligent workflows!"
}

# Main execution
main() {
    check_project_directory
    check_existing_setup
    setup_workflow
    create_project_structure
    analyze_project_state
    create_configuration
    create_project_analysis
    add_npm_scripts
    show_completion
}

# Run main function
main "$@" 