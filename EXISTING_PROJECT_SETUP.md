# 🔧 Existing Project Setup Guide

Hướng dẫn chi tiết để tích hợp **Website Clone Workflow System** vào dự án có sẵn và tiếp tục phát triển các phase.

## 📋 Prerequisites

- Dự án đã có sẵn (website clone, scraping project, etc.)
- Node.js >= 16.x
- Git repository đã được khởi tạo
- Quyền write access vào project directory

## 🚀 Manual Installation Steps

### Step 1: Download Workflow Files

```bash
# Clone workflow repository
git clone https://github.com/vietnguyen91/cursor-rules.git temp-workflow
cd temp-workflow

# Copy workflow files to your existing project
cp -r src/ /path/to/your/project/.cursor-rules/
cp USER_RULES_TEMPLATE.md /path/to/your/project/.cursor-rules/
cp WEBSITE_CLONE_WORKFLOW_EXAMPLE.md /path/to/your/project/
cp MULTI_SOURCE_WORKFLOW_EXAMPLE.md /path/to/your/project/

# Clean up
cd ..
rm -rf temp-workflow
```

### Step 2: Create Project Structure

```bash
cd /path/to/your/project

# Create required directories
mkdir -p docs/{tasks,features,specs,blueprints,targets}
mkdir -p .cursor-rules/src/{core,modes,templates,utilities}
mkdir -p .cursor-rules/knowledge

# Copy workflow files if not done in Step 1
# ... (same as Step 1)
```

### Step 3: Initialize Task Index

Tạo file `docs/tasks/task-index.json`:

```json
{
  "project_name": "Your_Project_Name",
  "version": "1.0.0",
  "last_updated": "2024-01-15T10:00:00Z",
  "features": []
}
```

### Step 4: Analyze Current Project State

#### Option A: Có Source Code Đầy Đủ
Nếu dự án đã có source code hoàn chình:

```bash
# Create feature analysis
mkdir -p docs/features/F01_ExistingSystem/requirements/
```

Tạo file `docs/features/F01_ExistingSystem/requirements/current-state-analysis.md`:

```markdown
# Current State Analysis - [Project Name]

## 📊 Project Overview
- **Start Date**: [Date]
- **Current Status**: [Production/Development/Testing]
- **Technology Stack**: [List technologies]
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
List existing features and their completion status.

## 🚧 Pending Work
List incomplete features and next development phases.

## 📈 Performance Metrics
- Page Load Speed: [time]
- SEO Score: [score]
- Mobile Friendly: [Yes/No]
- Accessibility: [score]

## 🔍 Technical Debt
List known issues and areas for improvement.
```

#### Option B: Dự Án Mới/Incomplete
Nếu dự án đang trong giai đoạn đầu:

```bash
# Create target analysis
mkdir -p docs/targets/
```

Sử dụng Target Analysis Mode để phân tích website cần clone.

### Step 5: Configure .cursor-rules

Tạo file `.cursor-rules` trong project root:

```markdown
## 🎯 Project-Specific Rules

### Project Context
- **Name**: [Your Project Name]  
- **Type**: Website Clone/Scraping System
- **Current Phase**: [Analysis/Planning/Development/Production]

### Workflow Configuration
- **Current Mode**: Auto-detect based on project state
- **Primary Features**: [List main features]
- **Data Sources**: [List target websites/APIs]

### Development Priorities
1. [Priority 1]
2. [Priority 2] 
3. [Priority 3]

## 📁 Project Structure Integration
The workflow system will create and manage these directories:
- `docs/` - All documentation and planning
- `.cursor-rules/` - Workflow system files
- Source code structure remains unchanged

## 🔄 Workflow Activation
Run analysis to determine current mode and next steps:
```

### Step 6: Update package.json (if Node.js project)

```json
{
  "scripts": {
    "workflow:init": "node .cursor-rules/bin/init-existing-project.js",
    "workflow:analyze": "node .cursor-rules/bin/analyze-project-state.js", 
    "workflow:status": "node .cursor-rules/bin/check-workflow-status.js"
  },
  "devDependencies": {
    "@cursor-rules/workflow": "^1.0.0"
  }
}
```

## 🎯 Project State Analysis

### Automatic Mode Detection

Workflow sẽ tự động detect mode dựa trên:

1. **Target Analysis Mode**: Nếu `docs/targets/` trống hoặc không có target analysis
2. **Planning Mode**: Nếu có targets nhưng chưa có blueprints  
3. **Developing Mode**: Nếu có tasks với status "approved" hoặc "developing"
4. **Integration Testing Mode**: Nếu có code hoàn thành cần test
5. **Content Sync Mode**: Nếu đang trong production và cần sync content

### Manual Mode Selection

Nếu cần force specific mode:

```bash
# Add to .cursor-rules
FORCE_MODE=Planning  # or Target_Analysis, Developing, etc.
```

## 📊 Integration Scenarios

### Scenario 1: Website Clone Project (50% Complete)

```bash
# 1. Analyze existing target
cp existing-website-analysis.md docs/targets/target-001-analysis.md

# 2. Create feature mapping
mkdir -p docs/features/F01_CoreClone/requirements/
# Document what's been built vs what's needed

# 3. Update task index
# Add completed and pending tasks
```

### Scenario 2: Scraping System (Early Stage)

```bash
# 1. Run target analysis on source websites
# Use Target Analysis Mode

# 2. Create scraping architecture plan
# Use Architecture Planning Mode  

# 3. Build scraper incrementally
# Use Developing Mode
```

### Scenario 3: Multi-Source Project (Complex)

```bash
# 1. Analyze all data sources
mkdir -p docs/targets/
# Create analysis for each source

# 2. Design data fusion architecture
# Use Multi-Source Analysis Mode

# 3. Implement conflict resolution
# Use Architecture Planning + Developing Modes
```

## 🔧 Advanced Configuration

### Custom Templates

Copy and modify templates in `.cursor-rules/src/templates/`:

```bash
cp .cursor-rules/src/templates/task-template.md docs/templates/custom-task.md
# Customize for your project needs
```

### Project-Specific Utilities

Create custom utilities in `.cursor-rules/utilities/`:

```markdown
# .cursor-rules/utilities/project-specific.mdc

## Custom Project Rules
- Specific coding standards
- Testing requirements  
- Deployment procedures
- Review processes
```

## 🚀 Getting Started

### Quick Start Commands

```bash
# 1. Initialize workflow in existing project
cd your-existing-project
git clone https://github.com/vietnguyen91/cursor-rules.git .cursor-rules-temp
cp -r .cursor-rules-temp/src .cursor-rules/
rm -rf .cursor-rules-temp

# 2. Create basic structure  
mkdir -p docs/{tasks,features,specs,blueprints,targets}
echo '{"project_name":"'$(basename $(pwd))'","version":"1.0.0","features":[]}' > docs/tasks/task-index.json

# 3. Start workflow
# Open Cursor and the workflow will auto-detect current state
```

### Validation Steps

1. **Structure Check**: Verify all required directories exist
2. **Mode Detection**: Confirm workflow detects correct starting mode
3. **Context Loading**: Test that project context loads properly
4. **Feature Mapping**: Ensure existing features are properly documented

## 📚 Next Steps

1. **Run Target Analysis** (nếu clone website)
2. **Document Current Architecture** (nếu có code sẵn)
3. **Plan Next Features** using Planning Mode
4. **Implement Incrementally** using Developing Mode
5. **Test and Deploy** using Integration Testing Mode

## 🆘 Troubleshooting

### Common Issues

**Mode Detection Fails**
```bash
# Force initialize mode
echo "FORCE_MODE=Initializing" >> .cursor-rules
```

**Missing Context**
```bash
# Recreate task index
cp .cursor-rules/src/templates/task-index-template.json docs/tasks/task-index.json
```

**Workflow Not Loading**
```bash
# Check .cursor-rules file exists and is properly formatted
cat .cursor-rules
```

## 📞 Support

- 📖 **Documentation**: Check workflow example files
- 🐛 **Issues**: Create GitHub issue with project context
- 💬 **Questions**: Include current project state and desired outcome

---

**Ready to enhance your existing project with the advanced workflow system!** 🚀 