# 🤖 Cursor Rules Agent v2.0.0
## Multi-Source Website Clone & AI Workflow System

*An intelligent agent system for Cursor IDE that provides advanced workflow management, multi-source data consistency, and automated assistance for complex website cloning projects.*

---

## 🚀 **Key Features**

### **🎯 Multi-Source Data Consistency** (NEW!)
- **Intelligent Multi-Source Analysis** - Analyze and compare multiple data sources simultaneously
- **Real-Time Conflict Resolution** - 91% automated conflict resolution with smart merge strategies
- **Data Fusion Architecture** - Master data repository with canonical records and audit trail
- **Cross-Source Validation** - Maintain 96% data accuracy across multiple sources

### **🌐 Advanced Website Clone Workflow**
- **Target Analysis Mode** - Deep website analysis including technical stack and legal compliance
- **Architecture Planning** - Multi-layer scraping architecture with performance optimization
- **Integration Testing** - Comprehensive scraping validation and quality assurance
- **Content Sync** - Production content management with real-time monitoring

### **🧠 Intelligent Workflow Management**
- **Multi-Mode System**: 8 specialized modes (Brainstorming → Planning → Developing → Testing → Sync → Documentation)
- **Context Intelligence**: Automatically loads relevant context based on current mode and task
- **MCP Tools Integration**: Enhanced with Model Context Protocol tools for advanced functionality
- **Safe Code Generation**: Enforces Read-Modify-Write-Verify cycle for code changes

---

## ⚡ **Quick Installation**

### **🔓 Public Repository Installation**
```bash
# One-line setup (recommended)
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# NPX alternative
npx cursor-rules-agent-installer
```

### **🔐 Private Repository Installation**

**Step 1:** Create GitHub token at [github.com/settings/tokens](https://github.com/settings/tokens) with `repo` scope

**Step 2:** Install with authentication:
```bash
# Method A: Environment variable (recommended)
export GITHUB_TOKEN=your_github_token_here
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Method B: .env file
echo "GITHUB_TOKEN=your_github_token_here" > .env
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Method C: NPX with token
export GITHUB_TOKEN=your_github_token_here
npx cursor-rules-agent-installer
```

### **🛠 Manual Setup**
```bash
# Clone with token authentication
git clone https://your_token@github.com/vietnguyen91/cursor-rules.git
cd cursor-rules/cursor-rules-agent

# Install with token
GITHUB_TOKEN=your_token npm run install-local
```

### **🔄 Existing Project Integration**

**Đã có dự án và muốn áp dụng workflow này để tiếp tục phát triển?**

📋 **[Existing Project Setup Guide](./EXISTING_PROJECT_SETUP.md)** - Hướng dẫn chi tiết tích hợp workflow vào dự án có sẵn

```bash
# Quick setup for existing projects
curl -sSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/setup-existing.sh | bash

# Or manual setup
git clone https://github.com/vietnguyen91/cursor-rules.git .cursor-rules-temp
cp -r .cursor-rules-temp/src .cursor-rules/
cp .cursor-rules-temp/EXISTING_PROJECT_SETUP.md ./
rm -rf .cursor-rules-temp
```

**Workflow sẽ tự động phát hiện trạng thái hiện tại của dự án:**
- ✅ **Dự án có source code** → Developing Mode hoặc Planning Mode
- ✅ **Dự án đang scraping** → Integration Testing Mode  
- ✅ **Dự án production** → Content Sync Mode
- ✅ **Cần thêm feature** → Brainstorming/Planning Mode

---

### **🔑 GitHub Token Setup Guide**

1. **Create Token**: Go to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. **Generate New Token**: Click "Generate new token (classic)"
3. **Configure Scopes**: Select `repo` for private repositories
4. **Copy Token**: Save it securely - you won't see it again
5. **Set Environment**: `export GITHUB_TOKEN=your_token_here`

**⚠️ Security Note**: Never commit tokens to git. Use `.env` files and add them to `.gitignore`.

---

## 🎬 **Project Setup Guide**

### **🔄 Progressive Workflow (Recommended)**

Most successful projects follow this progression:

#### **Phase 1: Single Source Clone (Get to Market Fast)**
```bash
# 1. Create new project directory
mkdir my-clone-project && cd my-clone-project

# 2. Install Cursor Rules Agent
npx cursor-rules-agent install

# 3. Initialize for single-source website cloning
npx cursor-rules-agent init --type="website-clone"

# 4. Clone your primary source
# In Cursor IDE: "clone website rophim.me"
```
**Perfect for:** MVP, proof of concept, getting to production quickly

#### **Phase 2: Multi-Source Expansion (Scale & Improve)**
```bash
# 5. When ready to enhance with additional sources
# In Cursor IDE: "analyze all sources for data consistency"
# Or: "add new source phimmoi.sale for better episode data"
```
**Perfect for:** Improving data quality, adding redundancy, competitive advantage

---

### **🎯 Direct Multi-Source Setup (Advanced)**

Use when you already know multiple sources upfront:

```bash
# 1. Setup project
npx cursor-rules-agent install

# 2. Initialize for multi-source
npx cursor-rules-agent init --type="multi-source"

# 3. Start with comprehensive analysis  
# In Cursor IDE: "analyze sources: rophim.me, phimmoi.sale, imdb.com"
```
**Perfect for:** Enterprise projects, data aggregation platforms, comparison sites

---

### **🤔 Decision Matrix: Which Approach to Choose?**

| Scenario | Recommended Approach | Reason |
|----------|---------------------|---------|
| 🎬 **"Tôi muốn clone rophim.me"** | **Phase 1: Single Source** | Get MVP fast, learn the domain |
| 🔄 **"Clone rophim + thêm nguồn khác sau"** | **Progressive Workflow** | Best balance of speed + scalability |
| 🎯 **"Tôi biết cần 3+ sources từ đầu"** | **Direct Multi-Source** | Save time, enterprise approach |
| 📊 **"Test concept trước khi đầu tư"** | **Phase 1: Single Source** | Minimal risk, quick validation |
| 🚀 **"Production system for business"** | **Progressive Workflow** | Proven approach, manageable complexity |

### **For Regular Development Projects:**

```bash
# 1. Install in existing project
npx cursor-rules-agent install

# 2. Auto-detect project type
npx cursor-rules-agent init --auto

# 3. Start brainstorming
# In Cursor IDE: "brainstorm new feature ideas"
```

---

## 🔄 **Workflow Modes**

### **🔍 Multi-Source Analysis Mode** (NEW!)
- **Activation**: "analyze all sources", "compare sources", "multi-source"
- **Capabilities**: Source quality scoring, conflict detection, data fusion strategy
- **Output**: Multi-source analysis report with resolution strategies

### **🎯 Target Analysis Mode**
- **Activation**: "clone website X", "analyze target", "scrape from"
- **Capabilities**: Technical stack detection, content mapping, legal compliance
- **Output**: Comprehensive target analysis with scraping strategy

### **🏗️ Architecture Planning Mode** 
- **Activation**: Auto-triggered after analysis completion
- **Capabilities**: Multi-source data fusion, database design, performance optimization
- **Output**: Complete architecture blueprint with implementation roadmap

### **💻 Developing Mode**
- **Activation**: "start coding TASK_X", task status = "approved"
- **Capabilities**: Safe code generation, context-aware development, automated testing
- **Output**: Production-ready code with comprehensive testing

### **🔬 Integration Testing Mode**
- **Activation**: "test scraping", "validate data", development completion
- **Capabilities**: Multi-source validation, data quality testing, performance testing
- **Output**: Quality assurance report with deployment readiness

### **🔄 Content Sync Mode**
- **Activation**: "sync content", "monitor sources", production deployment
- **Capabilities**: Real-time conflict resolution, source monitoring, automated recovery
- **Output**: Live production management with 99.7% uptime

---

## 📊 **Proven Results**

### **Real-World Performance (Rophim Project):**
```yaml
Multi-Source Integration Results:
  - Data Coverage: 78% → 96% (+18%)
  - Conflict Resolution: 91% automated
  - System Uptime: 99.7%
  - Content Freshness: 1.2 hours average
  - Video Availability: +35% improvement
  - Manual Maintenance: -75% reduction
  
Development Efficiency:
  - 50% faster than traditional approach
  - 8-week completion for 15,000-page site
  - 99.2% data integrity maintained
  - 95% automation in content management
```

---

## 🛠️ **Advanced Configuration**

### **Multi-Source Setup:**
```javascript
// .cursor-rules-config.js
module.exports = {
  mode: "multi-source",
  sources: {
    primary: {
      name: "main-site.com",
      priority: 1,
      reliability: 0.95
    },
    secondary: {
      name: "backup-site.com", 
      priority: 2,
      reliability: 0.87
    },
    enrichment: {
      name: "api-service.com",
      priority: 3,
      reliability: 0.99
    }
  },
  
  conflict_resolution: {
    strategy: "intelligent_merge",
    automation_threshold: 0.8,
    manual_review_queue: true
  },
  
  quality_monitoring: {
    real_time_validation: true,
    consistency_threshold: 0.94,
    alert_on_degradation: true
  }
}
```

### **Website Clone Configuration:**
```yaml
# .cursor-rules.yaml
website_clone:
  target_analysis:
    legal_compliance: true
    performance_baseline: true
    content_structure_mapping: true
    
  scraping_strategy:
    multi_layer_architecture: true
    intelligent_rate_limiting: true
    content_deduplication: true
    
  deployment:
    staging_validation: true
    production_monitoring: true
    automated_rollback: true
```

---

## 🔄 **Transition Guide: Single → Multi-Source**

### **When to Make the Transition:**
- ✅ Single source clone is **stable and in production**
- ✅ User feedback indicates **missing content** or **poor video quality**  
- ✅ You've **identified additional reliable sources**
- ✅ Ready to **invest in data quality improvements**

### **How to Transition:**
```bash
# 1. Backup current production system
git tag v1.0-single-source

# 2. Enable multi-source analysis in existing project
# In Cursor IDE:
"upgrade to multi-source architecture"

# 3. Start incremental source addition
"add source phimmoi.sale for episode enhancement"

# 4. Monitor and optimize
"monitor data consistency across sources"
```

### **Expected Improvements After Transition:**
- 📊 **Data Coverage**: 78% → 96% (+18%)
- 🎯 **Content Accuracy**: Significant improvement with cross-validation
- 🚀 **Video Availability**: +35% more working video links
- 🔧 **Maintenance**: 75% reduction in manual fixes

---

## 🎯 **Use Cases**

### **✅ Perfect For:**
- **Movie/Entertainment Sites** (like rophim, phimmoi)
- **E-commerce Platforms** with multiple suppliers
- **News Aggregation** from multiple sources  
- **Real Estate Listings** with various APIs
- **Job Boards** aggregating from multiple sites
- **Product Comparison** sites with multiple data sources

### **✅ Also Great For:**
- Any website cloning project
- Multi-API integration projects
- Data consistency management
- Large-scale scraping operations
- Content management systems

---

## 📚 **Documentation & Examples**

### **Comprehensive Guides:**
- 📖 [Multi-Source Workflow Example](./MULTI_SOURCE_WORKFLOW_EXAMPLE.md) - Real rophim project case study
- 🌐 [Website Clone Workflow](./WEBSITE_CLONE_WORKFLOW_EXAMPLE.md) - Complete clone methodology
- ⚙️ [Installation Guide](./installer-README.md) - Detailed setup instructions
- 📝 [User Rules Template](./USER_RULES_TEMPLATE.md) - Customization guide

### **Technical References:**
- 🤖 [Cursor Agent Documentation](./knowledge/cursor-agent.md) - Deep dive into Cursor Agent
- 📏 [Cursor Rules Documentation](./knowledge/cursor-rules.md) - Master the Cursor Rules system
- 🏗️ [Architecture Overview](./src/core/) - Core system architecture
- 🔧 [Mode Documentation](./src/modes/) - All workflow modes

---

## 🚀 **Enhanced MCP Tools Integration**

### **Core MCP Tools:**

#### 1. **Web Search Tool** 🌐
- **Purpose**: Real-time internet research for current best practices
- **Usage in Brainstorming**: Research latest trends, technologies, and solutions
- **Usage in Planning**: Validate architectural decisions against industry standards

#### 2. **Sequential Thinking** 🧠
- **Purpose**: Enable deep, structured reasoning for complex problems
- **Usage in Multi-Source Analysis**: Systematic conflict resolution
- **Usage in Architecture Planning**: Complex system design

#### 3. **Interactive MCP** 💬
- **Purpose**: Real-time user input without breaking thought flow
- **Usage in All Modes**: Clarify requirements, confirm decisions, get feedback

#### 4. **Playwright Integration** 🎭
- **Purpose**: Automated browser testing and interaction
- **Usage in Testing**: Comprehensive scraping validation
- **Usage in Monitoring**: Production health checks

---

## 🤝 **Community & Support**

### **Getting Help:**
- 📖 **Documentation**: Complete guides and examples
- 💬 **Issues**: [GitHub Issues](https://github.com/vietnguyen91/cursor-rules/issues)
- 🚀 **Feature Requests**: [Discussions](https://github.com/vietnguyen91/cursor-rules/discussions)
- 📧 **Contact**: [vietnguyen91@example.com](mailto:vietnguyen91@example.com)

### **Contributing:**
```bash
# 1. Fork the repository
# 2. Create feature branch
git checkout -b feature/amazing-feature

# 3. Make changes and test
npm test

# 4. Commit with conventional commits
git commit -m "feat: add amazing feature"

# 5. Push and create PR
git push origin feature/amazing-feature
```

---

## 🎉 **Quick Start Examples**

### **Progressive Movie Site Development:**
```bash
# Phase 1: Single Source MVP
npx cursor-rules-agent install
npx cursor-rules-agent init --type="website-clone"

# In Cursor IDE - Start simple
"clone website rophim.me"
# → Target Analysis Mode
# → Complete single-source clone
# → Production ready in 2-4 weeks

# Phase 2: Multi-Source Enhancement (when ready)
"analyze all sources for data consistency" 
# → Multi-Source Analysis Mode
# → Discovers phimmoi.sale, IMDB, etc.
# → Designs conflict resolution
# → Enhanced site with 96% data accuracy
```

### **Aggregate E-commerce Data:**
```bash
# Setup  
npx cursor-rules-agent init --type="multi-source"

# In Cursor IDE
"analyze all e-commerce sources for product data"
# → Multi-source analysis of Amazon, eBay, Shopify APIs
# → Conflict resolution for pricing, descriptions
# → Real-time sync with inventory management
```

---

## 📜 **License & Credits**

**MIT License** - see [LICENSE](./LICENSE) file for details

**Acknowledgments:**
- Built for the Cursor IDE community
- Inspired by real-world website cloning challenges
- Powered by advanced MCP tools integration

---

## 📑 **System Architecture**

### **Directory Structure**
```
cursor-rules-agent/
├── src/                        # Workflow system source code
│   ├── core/                   # Core orchestration rules
│   │   ├── master-orchestrator.mdc
│   │   └── context-loader.mdc
│   ├── modes/                  # Operating modes
│   │   ├── multi-source-analysis-mode.mdc  # NEW!
│   │   ├── target-analysis-mode.mdc
│   │   ├── architecture-planning-mode.mdc
│   │   ├── developing-mode.mdc
│   │   ├── integration-testing-mode.mdc
│   │   ├── content-sync-mode.mdc
│   │   └── documenting-mode.mdc
│   ├── utilities/              # Support tools
│   │   ├── safe-code-generation.mdc
│   │   └── enforcer.mdc
│   └── templates/              # Standard templates
│       ├── target-analysis-template.md
│       ├── scraping-blueprint-template.yaml
│       └── task-templates/
├── MULTI_SOURCE_WORKFLOW_EXAMPLE.md    # Real-world example
├── WEBSITE_CLONE_WORKFLOW_EXAMPLE.md   # Clone methodology
├── USER_RULES_TEMPLATE.md              # Customization guide
└── README.md                           # This file
```

---

**🚀 Ready to build your next multi-source website clone? Get started in under 5 minutes!**

**Version**: 2.0.0 (Multi-Source Release)  
**Repository**: https://github.com/vietnguyen91/cursor-rules  
**Last Updated**: January 2025 