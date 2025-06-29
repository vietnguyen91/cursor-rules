# 🚀 Quick Install Guide
## Cursor Rules Agent v2.0.0 - Multi-Source Website Clone System

*Test the installation process and verify everything works correctly.*

---

## 🎯 **One-Line Installation (Recommended)**

```bash
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
```

---

## 🧪 **Testing Installation**

### **Test 1: New Project Setup**
```bash
# Create test directory
mkdir test-cursor-rules && cd test-cursor-rules

# Run installer
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Verify structure
ls -la .cursor/rules/
ls -la docs/
```

### **Test 2: Website Clone Project**
```bash
# Create clone project
mkdir my-movie-clone && cd my-movie-clone

# Run installer (should detect as website-clone type)
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Check configuration
cat .cursor-rules-config.js
```

### **Test 3: Existing Project Integration**
```bash
# Go to existing project
cd your-existing-project

# Install cursor rules
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# Verify no conflicts with existing files
```

---

## ✅ **Verification Checklist**

### **Directory Structure Created:**
```
✅ .cursor/rules/core/
✅ .cursor/rules/modes/
✅ .cursor/rules/utilities/
✅ .cursor/rules/templates/
✅ docs/specs/
✅ docs/features/
✅ docs/targets/
✅ docs/blueprints/
✅ docs/tasks/
```

### **Core Files Present:**
```
✅ .cursor/rules/core/master-orchestrator.mdc
✅ .cursor/rules/core/context-loader.mdc
✅ .cursor/rules/modes/multi-source-analysis-mode.mdc
✅ .cursor/rules/modes/target-analysis-mode.mdc
✅ .cursor/rules/modes/architecture-planning-mode.mdc
✅ .cursor/rules/modes/developing-mode.mdc
✅ .cursor/rules/modes/integration-testing-mode.mdc
✅ .cursor/rules/modes/content-sync-mode.mdc
```

### **Templates & Documentation:**
```
✅ USER_RULES_TEMPLATE.md
✅ MULTI_SOURCE_WORKFLOW_EXAMPLE.md
✅ WEBSITE_CLONE_WORKFLOW_EXAMPLE.md
✅ docs/tasks/task-index.json
✅ .cursor-rules-config.js
```

---

## 🎬 **Quick Start Test**

### **1. Setup User Rules in Cursor:**
```bash
# Copy content from USER_RULES_TEMPLATE.md
cat USER_RULES_TEMPLATE.md
```
- Open Cursor Settings > Rules
- Paste the content
- Save settings

### **2. Test Basic Workflow:**
Open Cursor IDE in your project and try:

```
"bootstrap project structure"
```

Expected response: Agent detects Initializing Mode and sets up project.

### **3. Test Multi-Source Analysis:**
```
"analyze all sources for data consistency"
```

Expected response: Agent switches to Multi-Source Analysis Mode.

### **4. Test Website Clone Workflow:**
```
"clone website https://example.com"
```

Expected response: Agent enters Target Analysis Mode.

---

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **Issue: "curl command not found"**
```bash
# Install curl on macOS
brew install curl

# Install curl on Ubuntu/Debian
sudo apt-get install curl

# Install curl on CentOS/RHEL
sudo yum install curl
```

#### **Issue: "Permission denied"**
```bash
# Ensure write permissions
chmod 755 .
```

#### **Issue: "Files not downloading"**
```bash
# Check internet connection
ping github.com

# Try manual download
wget https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/README.md
```

#### **Issue: "Cursor not recognizing rules"**
1. Ensure `.cursor/rules/` directory exists in project root
2. Check Cursor Settings > Rules has content from USER_RULES_TEMPLATE.md
3. Restart Cursor IDE
4. Try typing a workflow command

---

## 📊 **Performance Test**

### **Installation Speed Test:**
```bash
time curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash
```

Expected: < 30 seconds for complete installation

### **File Size Verification:**
```bash
# Check total size
du -sh .cursor/rules/
du -sh docs/

# Count files
find .cursor/rules/ -type f | wc -l
```

Expected: 
- Rules directory: ~500KB
- Documentation: ~200KB  
- Total files: 15+ rule files

---

## 🎯 **Advanced Testing**

### **Test Multi-Source Configuration:**
```javascript
// Test .cursor-rules-config.js for website-clone projects
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
  }
}
```

### **Test Task Index Structure:**
```json
{
  "project": {
    "name": "test-project",
    "version": "1.0.0",
    "type": "website-clone",
    "created": "2025-01-16T..."
  },
  "features": [],
  "statistics": {
    "total_tasks": 0,
    "completed_tasks": 0,
    "active_features": 0
  }
}
```

---

## 🚀 **Real-World Test Scenarios**

### **Scenario 1: Movie Site Clone**
```bash
mkdir rophim-clone && cd rophim-clone
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# In Cursor IDE:
"analyze target website rophim.me with multi-source support"
```

### **Scenario 2: E-commerce Aggregation**
```bash
mkdir ecom-aggregator && cd ecom-aggregator  
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# In Cursor IDE:
"analyze all e-commerce sources for product data consistency"
```

### **Scenario 3: News Aggregation**
```bash
mkdir news-aggregator && cd news-aggregator
curl -fsSL https://raw.githubusercontent.com/vietnguyen91/cursor-rules/main/scripts/install.sh | bash

# In Cursor IDE:
"compare multiple news sources for content syndication"
```

---

## ✨ **Success Indicators**

### **✅ Installation Successful When:**
1. All directories and files created without errors
2. Installer shows green "Installation Complete!" message
3. Configuration file matches project type
4. Task index file is valid JSON
5. Cursor IDE recognizes workflow commands

### **✅ Workflow Active When:**
1. Typing workflow commands triggers appropriate mode
2. Agent shows mode-specific responses
3. Context loading works correctly
4. MCP tools integration functions

### **✅ Ready for Production When:**
1. All test scenarios work
2. Real project commands execute properly
3. Multi-source analysis functions correctly
4. Documentation is accessible

---

## 📞 **Get Help**

If you encounter issues:

1. **Check Installation Log:** Look for error messages during installation
2. **Verify File Permissions:** Ensure read/write access to project directory
3. **Check Cursor Settings:** Verify User Rules are properly configured
4. **Try Manual Setup:** Use the manual installation method if automated fails
5. **Report Issues:** https://github.com/vietnguyen91/cursor-rules/issues

---

**🎉 Ready to build your next multi-source website clone? Happy coding! 🚀** 