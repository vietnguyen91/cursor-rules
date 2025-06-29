#!/usr/bin/env node

const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const inquirer = require('inquirer');
const ora = require('ora');
const axios = require('axios');

// Package info
const packageInfo = {
  name: 'Cursor Rules Agent',
  version: '1.0.0',
  github: 'https://github.com/vietnguyen91/cursor-rules'
};

// GitHub configuration
const GITHUB_REPO = 'vietnguyen91/cursor-rules';
const GITHUB_BASE_URL = 'https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main';
const GITHUB_API_URL = 'https://api.github.com/repos/vietnguyen91/cursor-rules';

// Configure axios instance for GitHub API
let githubAuth = {};
if (process.env.GITHUB_TOKEN) {
  githubAuth.headers = {
    'Authorization': `token ${process.env.GITHUB_TOKEN}`,
    'User-Agent': 'Cursor-Rules-Agent-Installer'
  };
}

const githubApi = axios.create({
  baseURL: GITHUB_API_URL,
  ...githubAuth
});

const rawFiles = axios.create({
  baseURL: GITHUB_BASE_URL,
  ...githubAuth
});

// Check GitHub authentication
async function checkGitHubAuth() {
  if (process.env.GITHUB_TOKEN) {
    console.log(chalk.green('✅ GitHub token detected - using authenticated access'));
    return true;
  }
  
  // Check if .env file has token
  const envPath = path.join(process.cwd(), '.env');
  if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf8');
    const tokenMatch = envContent.match(/GITHUB_TOKEN=(.+)/);
    if (tokenMatch) {
      process.env.GITHUB_TOKEN = tokenMatch[1].trim();
      githubAuth.headers = {
        'Authorization': `token ${process.env.GITHUB_TOKEN}`,
        'User-Agent': 'Cursor-Rules-Agent-Installer'
      };
      console.log(chalk.green('✅ GitHub token loaded from .env file'));
      return true;
    }
  }
  
  // Test if repository is accessible
  try {
    await rawFiles.get('/README.md');
    console.log(chalk.blue('ℹ️ Repository is publicly accessible'));
    return true;
  } catch (error) {
    if (error.response && error.response.status === 404) {
      console.log(chalk.red('❌ Repository requires authentication'));
      console.log('');
      console.log('To create a GitHub token:');
      console.log('1. Go to https://github.com/settings/tokens');
      console.log('2. Click "Generate new token (classic)"');
      console.log('3. Select "repo" scope for private repositories');
      console.log('4. Copy the token and set it as an environment variable:');
      console.log('   export GITHUB_TOKEN=your_token_here');
      console.log('');
      console.log('Then run this installer again.');
      process.exit(1);
    }
    return true;
  }
}

// Download file with authentication
async function downloadFile(url, outputPath, description) {
  try {
    const response = await rawFiles.get(url);
    await fs.ensureDir(path.dirname(outputPath));
    await fs.writeFile(outputPath, response.data);
    console.log(chalk.gray(`   ✓ Downloaded: ${description}`));
    return true;
  } catch (error) {
    console.error(chalk.red(`   ❌ Failed to download: ${description}`));
    console.error(chalk.red(`   URL: ${GITHUB_BASE_URL}${url}`));
    if (error.response) {
      console.error(chalk.red(`   Status: ${error.response.status} ${error.response.statusText}`));
    }
    return false;
  }
}

// Rules data structure (embedded as fallback)
const rulesData = {
  core: {
    'master-orchestrator.mdc': `---
description: "Core orchestrator that determines which mode the agent should operate in"
alwaysApply: true
---

# Master Orchestrator

You are the central decision maker for the Cursor Rules Agent workflow system.

## Your Primary Responsibility
Analyze the user's request and determine EXACTLY ONE operating mode from:
- **INITIALIZING**: Setting up project structure, creating blueprints
- **BRAINSTORMING**: Generating and organizing ideas, research
- **PLANNING**: Creating task breakdowns, specifications
- **DEVELOPING**: Writing code, implementing features
- **DOCUMENTING**: Updating docs, syncing progress

## Detection Logic
1. **INITIALIZING** triggers:
   - "bootstrap", "setup project", "initialize"
   - Missing core directories: docs/, features/, specs/
   
2. **BRAINSTORMING** triggers:
   - "brainstorm", "ideas for", "research", "explore options"
   
3. **PLANNING** triggers:
   - "plan feature", "create tasks", "break down"
   - References to features/ or blueprints/
   
4. **DEVELOPING** triggers:
   - "implement", "code", "work on TASK_"
   - File operations, debugging
   
5. **DOCUMENTING** triggers:
   - "update docs", "sync documentation"
   - Working with .md files in docs/

## Output Format
Always start your response with:
**🎯 MODE: [MODE_NAME]**

Then proceed with mode-specific behavior.`,

    'context-loader.mdc': `---
description: "Intelligent context loader that loads relevant information based on current mode"
alwaysApply: true
---

# Context Loader

Load the most relevant context based on the detected mode.

## Loading Rules by Mode

### INITIALIZING Mode
- Load: initializing-mode.mdc
- Focus: Project setup, directory creation

### BRAINSTORMING Mode  
- Load: brainstorming-mode.mdc
- Focus: Idea generation, research tools

### PLANNING Mode
- Load: planning-agent.mdc, blueprint-template.yaml
- Focus: Task creation, specification linking

### DEVELOPING Mode
- Load: developing-mode.mdc, safe-code-generation.mdc
- Focus: Code implementation, file operations

### DOCUMENTING Mode
- Load: documenting-mode.mdc
- Focus: Documentation updates, progress sync

## Context Priority
1. **Task-specific knowledge**: If working on TASK_XXX, load linked specs
2. **Mode-specific rules**: Load appropriate mode file
3. **Utilities**: Load based on task type (safety, enforcement)
4. **Templates**: Load when creating new items`
  },
  
  modes: {
    'initializing-mode.mdc': `---
description: "Mode for setting up new projects and initializing structures"
---

# Initializing Mode

## Responsibilities
- Create project directory structure
- Set up initial configuration files
- Generate template files
- Initialize Git repository if needed

## Required Directory Structure
Create these directories if they don't exist:
\`\`\`
project/
├── .cursor/rules/           # Rules are already here
├── docs/                    # Documentation
├── features/                # Feature specifications
├── specs/                   # Detailed technical specs
├── blueprints/              # Architectural templates
└── task-index.json          # Task management
\`\`\`

## Initial Files to Create
1. **task-index.json**: Empty task management structure
2. **blueprints/README.md**: Explanation of blueprint system
3. **features/README.md**: Feature organization guide
4. **specs/README.md**: Specification writing guide

## Success Criteria
- All directories created
- Template files generated
- User can proceed to BRAINSTORMING or PLANNING mode`,

    'brainstorming-mode.mdc': `---
description: "Mode for generating and organizing ideas, conducting research"
---

# Brainstorming Mode

## Responsibilities
- Generate creative solutions and ideas
- Research current best practices
- Analyze feasibility and priority
- Create structured idea backlogs

## Enhanced Tools Usage
- **Web Search**: Research latest trends and solutions
- **Context7**: Explore available libraries and APIs
- **Sequential Thinking**: Structure complex ideation
- **Interactive MCP**: Validate ideas in real-time

## Brainstorming Process
1. **Understand Context**: What problem are we solving?
2. **Research Phase**: Use web search for current solutions
3. **Idea Generation**: Create multiple solution approaches
4. **Feasibility Analysis**: Technical and business evaluation
5. **Prioritization**: RICE scoring (Reach, Impact, Confidence, Effort)

## Output Format
Create structured idea documents in \`docs/features/ideas/\`:
- Problem statement
- Multiple solution approaches
- Feasibility analysis
- Recommended next steps`,

    'planning-agent.mdc': `---
description: "Intelligent planning agent for breaking down features into actionable tasks"
---

# Planning Agent

## Core Responsibility
Transform feature ideas into actionable, well-defined tasks with clear specifications.

## Task Creation Process
1. **Analyze Feature**: Understand scope and requirements
2. **Check Blueprints**: Look for existing architectural patterns
3. **Create Specifications**: Link tasks to detailed specs
4. **Break into Tasks**: Each task = 3-8 story points
5. **Update Task Index**: Maintain progress tracking

## Task Template
\`\`\`json
{
  "id": "TASK_001",
  "title": "Implement User Authentication",
  "description": "Clear, actionable description",
  "story_points": 5,
  "status": "pending",
  "knowledge_sources": [
    "docs/specs/auth-specification.md",
    "blueprints/security-blueprint.yaml"
  ],
  "acceptance_criteria": [
    "User can register with email/password",
    "Login returns JWT token",
    "Protected routes validate token"
  ]
}
\`\`\`

## Quality Gates
- Each task must have linked specifications
- Acceptance criteria must be testable
- Dependencies clearly identified`,

    'developing-mode.mdc': `---
description: "Mode for implementing features and writing code with safety patterns"
---

# Developing Mode

## Core Principles
- **Knowledge-First**: Always load task specifications before coding
- **Safety Pattern**: Use RMWV + Surgical Edit approach
- **Progressive Disclosure**: Load context incrementally

## Development Workflow
1. **Load Task Context**: Read task-index.json for current task
2. **Load Specifications**: Read all knowledge_sources linked to task
3. **Apply Safety Pattern**: Use safe-code-generation.mdc rules
4. **Implement Incrementally**: Small, testable changes
5. **Update Progress**: Mark completion in task-index

## RMWV + Surgical Edit Pattern
- **Read**: Understand current code structure
- **Minimal**: Make smallest possible change
- **Well-tested**: Verify change works
- **Verify**: Check integration with existing code
- **Surgical**: Precise edits, avoid broad rewrites

## Context Loading Priority
1. Current task specifications
2. Related blueprint files
3. Existing code in modification area
4. Safety and quality rules`,

    'documenting-mode.mdc': `---
description: "Mode for updating documentation and syncing progress"
---

# Documenting Mode

## Responsibilities
- Update API documentation
- Sync architectural diagrams
- Mark completed tasks in documentation
- Update README files and guides

## Documentation Types
1. **API Docs**: Auto-sync from code comments
2. **Architecture**: Update diagrams and blueprints
3. **User Guides**: Keep tutorials current
4. **Progress Reports**: Task completion status

## Update Process
1. **Scan Completed Tasks**: Check task-index.json
2. **Identify Doc Changes**: What needs updating?
3. **Sync API Changes**: Update OpenAPI specs
4. **Update Guides**: Reflect new features
5. **Archive Completed**: Move tasks to completed section

## Quality Checks
- All public APIs documented
- Examples still work
- Links are not broken
- Version numbers updated`
  },
  
  utilities: {
    'safe-code-generation.mdc': `---
description: "Safety utilities for secure and reliable code generation"
---

# Safe Code Generation

## RMWV + Surgical Edit Pattern
This pattern ensures precise, safe code modifications:

### Read (R)
- Understand existing code structure
- Identify dependencies and interactions
- Map current functionality

### Minimal (M)
- Make the smallest change possible
- Avoid broad rewrites or refactors
- Focus on single responsibility

### Well-tested (W)
- Verify change works as expected
- Test edge cases and error conditions
- Ensure backward compatibility

### Verify (V)
- Check integration with existing code
- Validate no regressions introduced
- Confirm acceptance criteria met

### Surgical Edit
- Use precise edit_file operations
- Include sufficient context in edits
- Avoid changing unrelated code

## Code Safety Checklist
- [ ] Change is minimal and focused
- [ ] Existing tests still pass
- [ ] New functionality is tested
- [ ] Error handling is appropriate
- [ ] Dependencies are satisfied`,

    'enforcer.mdc': `---
description: "Quality enforcement and blueprint gate validation"
---

# Enforcer

## Blueprint Gates
Ensure quality standards are met before proceeding:

### Gate 1: Specification Complete
- Task has detailed specification
- Acceptance criteria defined
- Dependencies identified

### Gate 2: Implementation Ready
- Code follows project patterns
- Tests are written
- Documentation updated

### Gate 3: Review Ready
- All acceptance criteria met
- Code passes quality checks
- Integration tests pass

## Enforcement Rules
- No task marked complete without meeting gates
- Blueprint deviations must be approved
- Breaking changes require architecture review

## Quality Metrics
- Code coverage > 80%
- No critical security vulnerabilities
- Performance benchmarks met`
  },
  
  templates: {
    'blueprint-template.yaml': `# Blueprint Template
name: "Feature Blueprint"
version: "1.0"
description: "Architectural template for new features"

architecture:
  patterns:
    - "Repository Pattern"
    - "Service Layer"
    - "DTO Mapping"
  
  structure:
    controllers: "Handle HTTP requests"
    services: "Business logic layer" 
    repositories: "Data access layer"
    models: "Data structures"

quality_gates:
  - specification_complete
  - implementation_ready
  - review_ready

standards:
  code_style: "ESLint + Prettier"
  testing: "Jest + Supertest"
  documentation: "JSDoc + OpenAPI"`,

    'task-template.md': `# Task Template

## Task Information
- **ID**: TASK_XXX
- **Title**: [Clear, actionable title]
- **Story Points**: [1-8 points]
- **Status**: [pending/in_progress/completed]

## Description
[Detailed description of what needs to be accomplished]

## Knowledge Sources
- \`docs/specs/[related-spec].md\`
- \`blueprints/[relevant-blueprint].yaml\`

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Implementation Notes
[Technical details, edge cases, considerations]

## Dependencies
- Depends on: [List other tasks]
- Blocks: [List blocked tasks]`,

    'task-index-template.json': `{
  "project": {
    "name": "Project Name",
    "version": "1.0.0",
    "last_updated": "2024-01-01"
  },
  "features": {},
  "tasks": {},
  "completed": {},
  "statistics": {
    "total_tasks": 0,
    "completed_tasks": 0,
    "completion_rate": 0
  }
}`
  }
};

class CursorRulesInstaller {
  constructor() {
    this.currentDir = process.cwd();
    this.rulesDir = path.join(this.currentDir, '.cursor', 'rules');
  }

  async run() {
    console.log(chalk.cyan.bold(`\n🤖 ${packageInfo.name} Installer v${packageInfo.version}\n`));
    
    try {
      await checkGitHubAuth();
      await this.checkPrerequisites();
      await this.confirmInstallation();
      await this.createDirectoryStructure();
      await this.downloadCursorRules();
      await this.initializeProject();
      await this.setupUserRules();
      this.showSuccess();
    } catch (error) {
      console.error(chalk.red('❌ Installation failed:'), error.message);
      process.exit(1);
    }
  }

  async checkPrerequisites() {
    const spinner = ora('Checking prerequisites...').start();
    
    // Check if already installed
    if (fs.existsSync(this.rulesDir)) {
      spinner.stop();
      const { overwrite } = await inquirer.prompt([{
        type: 'confirm',
        name: 'overwrite',
        message: 'Cursor Rules already exist. Overwrite?',
        default: false
      }]);
      
      if (!overwrite) {
        console.log(chalk.yellow('Installation cancelled.'));
        process.exit(0);
      }
    }
    
    spinner.succeed('Prerequisites checked');
  }

  async confirmInstallation() {
    console.log(chalk.white('This installer will set up:'));
    console.log(chalk.gray('  ✓ .cursor/rules/ directory with all workflow rules'));
    console.log(chalk.gray('  ✓ Organized project structure (docs/, docs/specs/, docs/features/, blueprints/)'));
    console.log(chalk.gray('  ✓ Template files and configuration'));
    console.log(chalk.gray('  ✓ Interactive User Rules setup\n'));

    const { proceed } = await inquirer.prompt([{
      type: 'confirm',
      name: 'proceed',
      message: 'Continue with installation?',
      default: true
    }]);

    if (!proceed) {
      console.log(chalk.yellow('Installation cancelled.'));
      process.exit(0);
    }
  }

  async createDirectoryStructure() {
    const spinner = ora('Creating directory structure...').start();
    
    const directories = [
      '.cursor/rules/core',
      '.cursor/rules/modes', 
      '.cursor/rules/utilities',
      '.cursor/rules/templates',
      'docs',
      'docs/specs',
      'docs/features',
      'docs/targets',
      'docs/blueprints',
      'docs/tasks'
    ];

    for (const dir of directories) {
      await fs.ensureDir(path.join(this.currentDir, dir));
    }
    
    spinner.succeed('Directory structure created');
  }

  async downloadCursorRules() {
    const spinner = ora('Downloading Cursor Rules Agent files...').start();
    spinner.stop();
    
    console.log(chalk.blue('📥 Downloading files from GitHub repository...'));
    
    const fileGroups = {
      'Core files': {
        basePath: '/src/core',
        files: {
          'master-orchestrator.mdc': '.cursor/rules/core/master-orchestrator.mdc',
          'context-loader.mdc': '.cursor/rules/core/context-loader.mdc'
        }
      },
      'Mode files': {
        basePath: '/src/modes',
        files: {
          'multi-source-analysis-mode.mdc': '.cursor/rules/modes/multi-source-analysis-mode.mdc',
          'target-analysis-mode.mdc': '.cursor/rules/modes/target-analysis-mode.mdc',
          'architecture-planning-mode.mdc': '.cursor/rules/modes/architecture-planning-mode.mdc',
          'developing-mode.mdc': '.cursor/rules/modes/developing-mode.mdc',
          'integration-testing-mode.mdc': '.cursor/rules/modes/integration-testing-mode.mdc',
          'content-sync-mode.mdc': '.cursor/rules/modes/content-sync-mode.mdc',
          'brainstorming-mode.mdc': '.cursor/rules/modes/brainstorming-mode.mdc',
          'planning-agent.mdc': '.cursor/rules/modes/planning-agent.mdc',
          'documenting-mode.mdc': '.cursor/rules/modes/documenting-mode.mdc',
          'initializing-mode.mdc': '.cursor/rules/modes/initializing-mode.mdc'
        }
      },
      'Utility files': {
        basePath: '/src/utilities',
        files: {
          'safe-code-generation.mdc': '.cursor/rules/utilities/safe-code-generation.mdc',
          'enforcer.mdc': '.cursor/rules/utilities/enforcer.mdc'
        }
      },
      'Template files': {
        basePath: '/src/templates',
        files: {
          'target-analysis-template.md': '.cursor/rules/templates/target-analysis-template.md',
          'scraping-blueprint-template.yaml': '.cursor/rules/templates/scraping-blueprint-template.yaml',
          'blueprint-template.yaml': '.cursor/rules/templates/blueprint-template.yaml',
          'task-template.md': '.cursor/rules/templates/task-template.md',
          'task-index-template.json': '.cursor/rules/templates/task-index-template.json',
          'task-index-feature-template.json': '.cursor/rules/templates/task-index-feature-template.json'
        }
      },
      'Documentation files': {
        basePath: '',
        files: {
          'USER_RULES_TEMPLATE.md': 'USER_RULES_TEMPLATE.md',
          'MULTI_SOURCE_WORKFLOW_EXAMPLE.md': 'MULTI_SOURCE_WORKFLOW_EXAMPLE.md',
          'WEBSITE_CLONE_WORKFLOW_EXAMPLE.md': 'WEBSITE_CLONE_WORKFLOW_EXAMPLE.md',
          'QUICK_INSTALL_GUIDE.md': 'QUICK_INSTALL_GUIDE.md'
        }
      }
    };

    let downloadErrors = [];
    
    for (const [groupName, group] of Object.entries(fileGroups)) {
      console.log(chalk.blue(`\n📁 ${groupName}:`));
      
      for (const [filename, outputPath] of Object.entries(group.files)) {
        const url = `${group.basePath}/${filename}`;
        const success = await downloadFile(url, path.join(this.currentDir, outputPath), filename);
        if (!success) {
          downloadErrors.push({ filename, url, outputPath });
        }
      }
    }
    
    if (downloadErrors.length > 0) {
      console.log(chalk.yellow(`\n⚠️ ${downloadErrors.length} file(s) failed to download. Using embedded fallback where available.`));
      await this.installEmbeddedRules(downloadErrors);
    }
    
    console.log(chalk.green('\n✅ Cursor Rules Agent files downloaded!'));
  }

  async installEmbeddedRules(failedFiles) {
    // Install embedded rules as fallback for failed downloads
    for (const [filename, content] of Object.entries(rulesData.core)) {
      if (failedFiles.some(f => f.filename === filename)) {
        await fs.writeFile(
          path.join(this.rulesDir, 'core', filename),
          content.trim()
        );
        console.log(chalk.gray(`   ✓ Installed embedded: ${filename}`));
      }
    }
  }

  async initializeProject() {
    const spinner = ora('Initializing project files...').start();
    
    // Create task-index.json
    const taskIndex = {
      project: {
        name: path.basename(this.currentDir),
        version: "1.0.0",
        created: new Date().toISOString(),
        type: this.detectProjectType()
      },
      features: [],
      statistics: {
        total_tasks: 0,
        completed_tasks: 0,
        active_features: 0
      },
      last_updated: new Date().toISOString()
    };
    
    await fs.writeFile(
      path.join(this.currentDir, 'docs', 'tasks', 'task-index.json'),
      JSON.stringify(taskIndex, null, 2)
    );

    // Create README files
    const readmeFiles = {
      'docs/README.md': '# Documentation\n\nThis directory contains project documentation, specifications, and feature definitions.',
      'docs/features/README.md': '# Features\n\nThis directory contains feature specifications and requirements.',
      'docs/specs/README.md': '# Specifications\n\nThis directory contains detailed technical specifications.',
      'docs/blueprints/README.md': '# Blueprints\n\nThis directory contains architectural blueprints and design templates.',
      'docs/targets/README.md': '# Target Analysis\n\nThis directory contains analysis results for target websites and systems.'
    };

    for (const [filepath, content] of Object.entries(readmeFiles)) {
      await fs.writeFile(path.join(this.currentDir, filepath), content);
    }

    // Create .env.example
    const envExample = `# GitHub Authentication (for private repositories)
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
`;

    await fs.writeFile(path.join(this.currentDir, '.env.example'), envExample);
    
    spinner.succeed('Project files initialized');
  }

  detectProjectType() {
    const packageJsonPath = path.join(this.currentDir, 'package.json');
    
    if (fs.existsSync(packageJsonPath)) {
      const packageJson = fs.readJsonSync(packageJsonPath);
      const dependencies = { ...packageJson.dependencies, ...packageJson.devDependencies };
      
      if (Object.keys(dependencies).some(dep => dep.includes('scraping') || dep.includes('scraper'))) {
        return 'website-clone';
      }
      
      if (Object.keys(dependencies).some(dep => ['nuxt', 'next', 'react', 'vue'].includes(dep))) {
        return 'web-app';
      }
    }
    
    const currentDirName = path.basename(this.currentDir).toLowerCase();
    if (currentDirName.includes('clone') || currentDirName.includes('scraper')) {
      return 'website-clone';
    }
    
    return 'general';
  }

  async setupUserRules() {
    const { setupUserRules } = await inquirer.prompt([{
      type: 'confirm',
      name: 'setupUserRules',
      message: 'Would you like to see the User Rules template for Cursor Settings?',
      default: true
    }]);

    if (setupUserRules) {
      console.log(chalk.cyan('\n📋 Copy this to Cursor Settings > Rules (User Rules):'));
      console.log(chalk.gray('─'.repeat(60)));
      
      const userRulesTemplate = `# 💬 User Rules for Cursor Rules Agent

**Communication Style**: Friendly, direct, technical terms in English
**Decision Making**: Logic-driven, always explain "why"
**Visual Clarity**: Use ✅ ❌ 🚀 💡 ⚠️ emojis appropriately

## Smart Confirmation Rules
- Ask for confirmation when requirements are unclear
- Make autonomous decisions for best practices
- Always be transparent about errors

## Response Format
1. Mode indicator at start
2. Technical content with explanations  
3. Proper markdown formatting
4. Concise but thorough responses`;
      
      console.log(chalk.white(userRulesTemplate));
      console.log(chalk.gray('─'.repeat(60)));
    }
  }

  showSuccess() {
    console.log(chalk.green.bold('\n🎉 Installation Complete!\n'));
    
    if (process.env.GITHUB_TOKEN) {
      console.log(chalk.blue('🔐 Authentication: GitHub token configured for private repository access\n'));
    }
    
    console.log(chalk.white('Next steps:'));
    console.log(chalk.gray('1. Open Cursor in this project'));
    console.log(chalk.gray('2. Copy USER_RULES_TEMPLATE.md content to Cursor Settings > Rules'));
    
    if (!fs.existsSync(path.join(this.currentDir, '.env')) && fs.existsSync(path.join(this.currentDir, '.env.example'))) {
      console.log(chalk.gray('3. Copy .env.example to .env and configure your environment variables'));
      console.log(chalk.gray('4. Try: ') + chalk.cyan('"bootstrap project structure"'));
    } else {
      console.log(chalk.gray('3. Try: ') + chalk.cyan('"bootstrap project structure"'));
    }
    
    const projectType = this.detectProjectType();
    
    console.log(chalk.white('\nUseful commands:'));
    if (projectType === 'website-clone') {
      console.log(chalk.gray('• ') + chalk.cyan('clone website https://example.com'));
      console.log(chalk.gray('• ') + chalk.cyan('analyze all sources for data consistency'));
    } else {
      console.log(chalk.gray('• ') + chalk.cyan('brainstorm ideas for [feature]'));
      console.log(chalk.gray('• ') + chalk.cyan('plan feature: [name]'));
      console.log(chalk.gray('• ') + chalk.cyan('work on TASK_001'));
    }
    console.log(chalk.gray('• ') + chalk.cyan('update documentation'));
    
    console.log(chalk.white(`\nLearn more: ${packageInfo.github}\n`));
  }
}

// Run the installer
if (require.main === module) {
  const installer = new CursorRulesInstaller();
  installer.run().catch(console.error);
}

module.exports = CursorRulesInstaller; 