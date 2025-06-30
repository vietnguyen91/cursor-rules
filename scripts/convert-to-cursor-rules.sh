#!/bin/bash

# 🎯 Convert Workflow Rules to Cursor IDE Format
# Auto-converts workflow rules to .cursor/rules structure with appropriate apply modes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TARGET_PROJECT="${1:-$PROJECT_ROOT}"

echo "🎯 Converting Workflow Rules to Cursor IDE Format"
echo "Target project: $TARGET_PROJECT"

# Create .cursor/rules folder structure
create_cursor_structure() {
    local target_dir="$1/.cursor/rules"
    
    echo "📁 Creating .cursor/rules folder structure..."
    
    mkdir -p "$target_dir/core"
    mkdir -p "$target_dir/modes" 
    mkdir -p "$target_dir/utilities"
    mkdir -p "$target_dir/templates"
    mkdir -p "$target_dir/knowledge"
    
    echo "✅ Folder structure created"
}

# Convert rule to Cursor MDC format
convert_rule() {
    local source_file="$1"
    local target_file="$2"
    local rule_type="$3"
    local description="$4"
    local globs="$5"
    local always_apply="$6"
    
    echo "🔄 Converting $(basename "$source_file") → $(basename "$target_file")"
    
    # Extract content (skip workflow metadata and existing frontmatter)
    local content=""
    local in_yaml_frontmatter=false
    local yaml_frontmatter_count=0
    local skip_workflow_metadata=false
    
    while IFS= read -r line; do
        # Skip YAML frontmatter blocks (---)
        if [[ "$line" == "---" ]]; then
            ((yaml_frontmatter_count++))
            if [[ $yaml_frontmatter_count -eq 1 ]]; then
                in_yaml_frontmatter=true
                continue
            elif [[ $yaml_frontmatter_count -eq 2 ]]; then
                in_yaml_frontmatter=false
                continue
            fi
        fi
        
        # Skip workflow metadata block starting with "# Rule Metadata"
        if [[ "$line" == "# Rule Metadata" ]]; then
            skip_workflow_metadata=true
            continue
        fi
        
        # Stop skipping when we hit first real content header
        if [[ $skip_workflow_metadata == true && "$line" =~ ^#[[:space:]].+ && "$line" != "# Rule Metadata" ]]; then
            skip_workflow_metadata=false
        fi
        
        # Include content if not in frontmatter and not in metadata block
        if [[ $in_yaml_frontmatter == false && $skip_workflow_metadata == false ]]; then
            content+="$line"$'\n'
        fi
    done < "$source_file"
    
    # Create new file with proper Cursor YAML frontmatter
    cat > "$target_file" << EOF
---
description: "$description"
globs: "$globs"
alwaysApply: $always_apply
---
$content
EOF
    
    echo "✅ Converted $(basename "$target_file")"
}

# Main conversion logic
convert_workflow_rules() {
    local target_dir="$1/.cursor/rules"
    local source_dir="$PROJECT_ROOT/src"
    
    echo "🔄 Converting workflow rules..."
    
    # ALWAYS RULES (Core orchestration)
    if [[ -f "$source_dir/core/master-orchestrator.mdc" ]]; then
        convert_rule \
            "$source_dir/core/master-orchestrator.mdc" \
            "$target_dir/core/master-orchestrator-always.mdc" \
            "always" \
            "" \
            "" \
            "true"
    fi
    
    if [[ -f "$source_dir/core/context-loader.mdc" ]]; then
        convert_rule \
            "$source_dir/core/context-loader.mdc" \
            "$target_dir/core/context-loader-always.mdc" \
            "always" \
            "" \
            "" \
            "true"
    fi
    
    # AGENT REQUESTED RULES (Mode-specific)
    if [[ -f "$source_dir/modes/brainstorming-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/brainstorming-mode.mdc" \
            "$target_dir/modes/brainstorming-mode-agent.mdc" \
            "agent" \
            "Creative ideation and feature brainstorming when user needs to explore new ideas, generate concepts, or think through feature possibilities" \
            "" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/planning-agent.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/planning-agent.mdc" \
            "$target_dir/modes/planning-agent-agent.mdc" \
            "agent" \
            "Strategic planning and task decomposition when user needs to break down features, create blueprints, or structure development approach" \
            "" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/target-analysis-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/target-analysis-mode.mdc" \
            "$target_dir/modes/target-analysis-mode-agent.mdc" \
            "agent" \
            "Website analysis and technical feasibility assessment when cloning or analyzing target websites" \
            "" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/multi-source-analysis-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/multi-source-analysis-mode.mdc" \
            "$target_dir/modes/multi-source-analysis-mode-agent.mdc" \
            "agent" \
            "Multi-source data analysis and consistency management when working with multiple data sources" \
            "" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/documenting-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/documenting-mode.mdc" \
            "$target_dir/modes/documenting-mode-agent.mdc" \
            "agent" \
            "Documentation generation and maintenance when tasks are completed and need documentation" \
            "" \
            "false"
    fi
    
    # AUTO ATTACHED RULES (File-specific)
    if [[ -f "$source_dir/modes/developing-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/developing-mode.mdc" \
            "$target_dir/modes/developing-mode-auto.mdc" \
            "auto" \
            "" \
            "src/**/*.ts, src/**/*.js, src/**/*.tsx, src/**/*.jsx" \
            "false"
    fi
    
    if [[ -f "$source_dir/utilities/safe-code-generation.mdc" ]]; then
        convert_rule \
            "$source_dir/utilities/safe-code-generation.mdc" \
            "$target_dir/utilities/safe-code-generation-auto.mdc" \
            "auto" \
            "" \
            "src/**/*.*, lib/**/*.*, components/**/*.*" \
            "false"
    fi
    
    if [[ -f "$source_dir/utilities/enforcer.mdc" ]]; then
        convert_rule \
            "$source_dir/utilities/enforcer.mdc" \
            "$target_dir/utilities/enforcer-always.mdc" \
            "always" \
            "" \
            "" \
            "true"
    fi
    
    if [[ -f "$source_dir/modes/architecture-planning-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/architecture-planning-mode.mdc" \
            "$target_dir/modes/architecture-planning-mode-auto.mdc" \
            "auto" \
            "" \
            "docs/**/*.md, specs/**/*.*, architecture/**/*.*" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/integration-testing-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/integration-testing-mode.mdc" \
            "$target_dir/modes/integration-testing-mode-auto.mdc" \
            "auto" \
            "" \
            "**/*.test.*, **/*.spec.*, tests/**/*.*, __tests__/**/*.*" \
            "false"
    fi
    
    if [[ -f "$source_dir/modes/content-sync-mode.mdc" ]]; then
        convert_rule \
            "$source_dir/modes/content-sync-mode.mdc" \
            "$target_dir/modes/content-sync-mode-auto.mdc" \
            "auto" \
            "" \
            "content/**/*.*, data/**/*.*, scraped/**/*.*" \
            "false"
    fi
    
    # MANUAL RULES (Templates & Knowledge)
    if [[ -d "$source_dir/templates" ]]; then
        echo "🔄 Converting template files..."
        for template_file in "$source_dir/templates"/*.yaml "$source_dir/templates"/*.md; do
            if [[ -f "$template_file" ]]; then
                local base_name=$(basename "$template_file" | sed 's/\.[^.]*$//')
                convert_rule \
                    "$template_file" \
                    "$target_dir/templates/${base_name}-manual.mdc" \
                    "manual" \
                    "" \
                    "" \
                    "false"
            fi
        done
    fi
    
    if [[ -d "$source_dir/../knowledge" ]]; then
        echo "🔄 Converting knowledge files..."
        for knowledge_file in "$source_dir/../knowledge"/*.md; do
            if [[ -f "$knowledge_file" ]]; then
                local base_name=$(basename "$knowledge_file" | sed 's/\.[^.]*$//')
                convert_rule \
                    "$knowledge_file" \
                    "$target_dir/knowledge/${base_name}-manual.mdc" \
                    "manual" \
                    "" \
                    "" \
                    "false"
            fi
        done
    fi
    
    echo "✅ Workflow rules converted successfully"
}

# Create MCP configuration
create_mcp_config() {
    local target_dir="$1/.cursor"
    
    echo "🔧 Creating MCP configuration..."
    
    cat > "$target_dir/mcp.json" << 'EOF'
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["@context7/mcp-server"],
      "env": {}
    },
    "web-search": {
      "command": "npx", 
      "args": ["@modelcontextprotocol/server-web-search"],
      "env": {}
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["@sequential-thinking/mcp-server"], 
      "env": {}
    }
  }
}
EOF
    
    echo "✅ MCP configuration created"
}

# Create custom agent modes
create_agent_modes() {
    local target_dir="$1/.cursor"
    
    echo "🤖 Creating custom agent modes..."
    
    cat > "$target_dir/modes.json" << 'EOF'
{
  "modes": [
    {
      "name": "Website Clone Agent",
      "description": "Specialized agent for website cloning and scraping projects",
      "systemPrompt": "You are an expert in website cloning, scraping, and data extraction. Focus on legal compliance, technical feasibility, and efficient implementation of website clone projects.",
      "model": "claude-3.5-sonnet",
      "tools": {
        "codebase": true,
        "terminal": true,
        "web": true,
        "files": true
      }
    },
    {
      "name": "Multi-Source Data Agent", 
      "description": "Expert in multi-source data integration and consistency management",
      "systemPrompt": "You specialize in analyzing and integrating data from multiple sources while maintaining consistency and resolving conflicts. Focus on data quality, fusion strategies, and automated conflict resolution.",
      "model": "claude-3.5-sonnet",
      "tools": {
        "codebase": true,
        "terminal": true,
        "web": true,
        "files": true
      }
    },
    {
      "name": "Architecture Planner",
      "description": "System architecture and technical planning specialist", 
      "systemPrompt": "You are an expert system architect focused on scalable, maintainable system design. Emphasize best practices, performance optimization, and future-proof architecture decisions.",
      "model": "claude-3.5-sonnet",
      "tools": {
        "codebase": true,
        "web": true,
        "files": true
      }
    },
    {
      "name": "Safe Code Developer",
      "description": "Development agent with emphasis on code safety and quality",
      "systemPrompt": "You are a senior developer focused on writing safe, tested, and maintainable code. Always follow RMWV (Read-Modify-Write-Verify) cycle and include comprehensive error handling and logging.",
      "model": "claude-3.5-sonnet", 
      "tools": {
        "codebase": true,
        "terminal": true,
        "files": true
      }
    }
  ]
}
EOF
    
    echo "✅ Custom agent modes created"
}

# Create .cursorindexignore file
create_cursor_ignore() {
    local target_dir="$1"
    
    echo "🚫 Creating .cursorindexignore..."
    
    cat > "$target_dir/.cursorindexignore" << 'EOF'
# Workflow backup files
backup/
**/workflow-rules-backup/

# Large data files
data/
scraped/
content/large/

# Generated files
dist/
build/
*.generated.*

# Dependencies
node_modules/
venv/
__pycache__/

# Logs and temporary files
*.log
tmp/
temp/

# Development files
.env
.env.local
.vscode/settings.json

# Documentation archives
docs/archive/
legacy/
EOF
    
    echo "✅ .cursorindexignore created"
}

# Validate conversion
validate_conversion() {
    local target_dir="$1/.cursor/rules"
    
    echo "🔍 Validating conversion..."
    
    local error_count=0
    
    # Check required always rules
    if [[ ! -f "$target_dir/core/master-orchestrator-always.mdc" ]]; then
        echo "❌ Missing: master-orchestrator-always.mdc"
        ((error_count++))
    fi
    
    if [[ ! -f "$target_dir/core/context-loader-always.mdc" ]]; then
        echo "❌ Missing: context-loader-always.mdc" 
        ((error_count++))
    fi
    
    # Check MDC format for all files
    for rule_file in "$target_dir"/**/*.mdc; do
        if [[ -f "$rule_file" ]]; then
            if ! head -1 "$rule_file" | grep -q "^---$"; then
                echo "❌ Invalid frontmatter in $(basename "$rule_file")"
                ((error_count++))
            fi
        fi
    done
    
    if [[ $error_count -eq 0 ]]; then
        echo "✅ Validation passed - all rules converted correctly"
    else
        echo "⚠️  Validation found $error_count issues"
        return 1
    fi
}

# Generate summary report
generate_report() {
    local target_dir="$1/.cursor/rules"
    
    echo ""
    echo "📊 CONVERSION SUMMARY"
    echo "===================="
    
    echo ""
    echo "📁 Folder Structure:"
    find "$1/.cursor" -type d | sed 's|[^/]*/|  |g'
    
    echo ""
    echo "📄 Rules by Type:"
    
    local always_count=$(find "$target_dir" -name "*-always.mdc" | wc -l)
    local agent_count=$(find "$target_dir" -name "*-agent.mdc" | wc -l)  
    local auto_count=$(find "$target_dir" -name "*-auto.mdc" | wc -l)
    local manual_count=$(find "$target_dir" -name "*-manual.mdc" | wc -l)
    
    echo "  Always Apply:    $always_count rules"
    echo "  Agent Requested: $agent_count rules"
    echo "  Auto Attached:   $auto_count rules"
    echo "  Manual:          $manual_count rules"
    echo "  --------------------------------"
    echo "  Total:           $((always_count + agent_count + auto_count + manual_count)) rules"
    
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Open Cursor IDE in project: $TARGET_PROJECT"
    echo "2. Check Settings > Rules to verify rules are loaded"
    echo "3. Test agent modes in chat interface"
    echo "4. Validate MCP tools are working (if configured)"
    
    echo ""
    echo "🚀 Conversion completed successfully!"
}

# Main execution
main() {
    echo "Starting conversion process..."
    
    # Create target directory if it doesn't exist
    if [[ ! -d "$TARGET_PROJECT" ]]; then
        mkdir -p "$TARGET_PROJECT"
        echo "📁 Created project directory: $TARGET_PROJECT"
    fi
    
    # Execute conversion steps
    create_cursor_structure "$TARGET_PROJECT"
    convert_workflow_rules "$TARGET_PROJECT"
    create_mcp_config "$TARGET_PROJECT"
    create_agent_modes "$TARGET_PROJECT"
    create_cursor_ignore "$TARGET_PROJECT"
    
    # Validate and report
    if validate_conversion "$TARGET_PROJECT"; then
        generate_report "$TARGET_PROJECT"
    else
        echo "❌ Conversion completed with errors. Please review manually."
        exit 1
    fi
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 