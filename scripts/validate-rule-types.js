#!/usr/bin/env node

/**
 * Rule Type Validation Script
 * Validates all rule files against the rule type system requirements
 */

const fs = require('fs');
const path = require('path');

// Valid rule types
const VALID_RULE_TYPES = [
  'ORCHESTRATION_RULES',
  'MODE_BRAINSTORMING', 'MODE_TARGET_ANALYSIS', 'MODE_MULTI_SOURCE',
  'MODE_ARCHITECTURE_PLANNING', 'MODE_DEVELOPING', 'MODE_INTEGRATION_TESTING',
  'MODE_CONTENT_SYNC', 'MODE_DOCUMENTING',
  'UTILITY_SAFE_CODE', 'UTILITY_ENFORCER', 'UTILITY_QUALITY', 'UTILITY_SECURITY',
  'PROJECT_RULES',
  'TEMPLATE_TASK', 'TEMPLATE_BLUEPRINT', 'TEMPLATE_ANALYSIS', 'TEMPLATE_FEATURE',
  'KNOWLEDGE_CURSOR', 'KNOWLEDGE_AGENT', 'KNOWLEDGE_BEST_PRACTICES', 'KNOWLEDGE_TROUBLESHOOTING'
];

// Valid priority levels
const VALID_PRIORITIES = [1, 2, 3, 4, 5, 6];

console.log('🔍 Rule Type Validation');
console.log('========================\n');

let totalFiles = 0;
let validFiles = 0;
let invalidFiles = 0;
const errors = [];

/**
 * Extract metadata from rule file content
 */
function extractMetadata(content, filePath) {
  const metadataMatch = content.match(/```yaml\s*\n# Rule Metadata\s*\n([\s\S]*?)\n```/);
  
  if (!metadataMatch) {
    return null;
  }
  
  try {
    const metadataContent = metadataMatch[1];
    const metadata = {};
    
    // Simple YAML parser for basic key-value pairs
    const lines = metadataContent.split('\n');
    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed && !trimmed.startsWith('#') && trimmed.includes(':')) {
        const [key, ...valueParts] = trimmed.split(':');
        let value = valueParts.join(':').trim();
        
        // Remove quotes
        if ((value.startsWith('"') && value.endsWith('"')) || 
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.slice(1, -1);
        }
        
        // Parse arrays (simple format)
        if (value.startsWith('[') && value.endsWith(']')) {
          value = value.slice(1, -1).split(',').map(v => v.trim().replace(/['"]/g, ''));
        }
        
        // Parse numbers
        if (!isNaN(value) && value !== '') {
          value = Number(value);
        }
        
        metadata[key.trim()] = value;
      }
    }
    
    return metadata;
  } catch (error) {
    throw new Error(`Failed to parse metadata in ${filePath}: ${error.message}`);
  }
}

/**
 * Validate rule metadata
 */
function validateMetadata(metadata, filePath) {
  const issues = [];
  
  // Check required fields
  const requiredFields = ['rule_type', 'priority', 'scope', 'requires', 'conflicts', 'activation_conditions', 'description', 'version'];
  
  for (const field of requiredFields) {
    if (!metadata.hasOwnProperty(field)) {
      issues.push(`Missing required field: ${field}`);
    }
  }
  
  // Validate rule_type
  if (metadata.rule_type && !VALID_RULE_TYPES.includes(metadata.rule_type)) {
    issues.push(`Invalid rule_type: ${metadata.rule_type}`);
  }
  
  // Validate priority
  if (metadata.priority && !VALID_PRIORITIES.includes(metadata.priority)) {
    issues.push(`Invalid priority: ${metadata.priority}. Must be between 1-6`);
  }
  
  // Validate version format (semantic versioning)
  if (metadata.version && !/^\d+\.\d+\.\d+$/.test(metadata.version)) {
    issues.push(`Version must follow semantic versioning (e.g., 2.0.0)`);
  }
  
  return issues;
}

/**
 * Validate file path against expected rule type
 */
function validateFilePath(filePath, ruleType) {
  const relativePath = filePath.replace(process.cwd() + '/', '').replace(/^cursor-rules-agent\/src\//, '');
  
  if (relativePath.startsWith('core/') && ruleType !== 'ORCHESTRATION_RULES') {
    return `Core files should have ORCHESTRATION_RULES type, got ${ruleType}`;
  }
  
  if (relativePath.startsWith('modes/') && !ruleType.startsWith('MODE_')) {
    return `Mode files should have MODE_ type, got ${ruleType}`;
  }
  
  if (relativePath.startsWith('utilities/') && !ruleType.startsWith('UTILITY_')) {
    return `Utility files should have UTILITY_ type, got ${ruleType}`;
  }
  
  return null;
}

/**
 * Scan directory for rule files
 */
function scanRuleFiles(dir, fileList = []) {
  if (!fs.existsSync(dir)) {
    return fileList;
  }
  
  const files = fs.readdirSync(dir);
  
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      scanRuleFiles(filePath, fileList);
    } else if (file.endsWith('.mdc') || file.endsWith('.md') || file === '.cursor-rules') {
      fileList.push(filePath);
    }
  }
  
  return fileList;
}

/**
 * Main validation function
 */
function validateRules() {
  const srcDir = path.join(__dirname, '..', 'src');
  const ruleFiles = scanRuleFiles(srcDir);
  
  console.log(`📁 Found ${ruleFiles.length} rule files to validate\n`);
  
  for (const filePath of ruleFiles) {
    totalFiles++;
    
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const metadata = extractMetadata(content, filePath);
      
      // Debug: Check if metadata block exists in content
      if (!metadata && content.includes('Rule Metadata')) {
        console.log(`🔍 DEBUG: File ${filePath} contains "Rule Metadata" but extraction failed`);
        const debugMatch = content.match(/```yaml[\s\S]*?Rule Metadata[\s\S]*?```/);
        if (debugMatch) {
          console.log(`🔍 DEBUG: Found metadata block: ${debugMatch[0].substring(0, 200)}...`);
        }
      }
      
      if (!metadata) {
        invalidFiles++;
        errors.push({
          file: filePath,
          issues: ['Missing rule metadata block']
        });
        console.log(`❌ ${path.relative(process.cwd(), filePath)} - Missing metadata`);
        continue;
      }
      
      // Validate metadata structure
      const metadataIssues = validateMetadata(metadata, filePath);
      
      // Validate file path consistency
      const pathIssue = validateFilePath(filePath, metadata.rule_type);
      if (pathIssue) {
        metadataIssues.push(pathIssue);
      }
      
      if (metadataIssues.length > 0) {
        invalidFiles++;
        errors.push({
          file: filePath,
          issues: metadataIssues
        });
        console.log(`❌ ${path.relative(process.cwd(), filePath)} - ${metadataIssues.length} issues`);
      } else {
        validFiles++;
        console.log(`✅ ${path.relative(process.cwd(), filePath)} - Valid`);
      }
      
    } catch (error) {
      invalidFiles++;
      errors.push({
        file: filePath,
        issues: [`Validation error: ${error.message}`]
      });
      console.log(`❌ ${path.relative(process.cwd(), filePath)} - Error: ${error.message}`);
    }
  }
  
  // Generate summary
  console.log('\n📊 Validation Summary');
  console.log('===================');
  console.log(`Total files: ${totalFiles}`);
  console.log(`Valid files: ${validFiles}`);
  console.log(`Invalid files: ${invalidFiles}`);
  console.log(`Success rate: ${((validFiles / totalFiles) * 100).toFixed(1)}%`);
  
  if (errors.length > 0) {
    console.log('\n❌ Issues Found:');
    console.log('================');
    
    for (const error of errors) {
      console.log(`\n📁 ${path.relative(process.cwd(), error.file)}:`);
      for (const issue of error.issues) {
        console.log(`  • ${issue}`);
      }
    }
    
    process.exit(1);
  } else {
    console.log('\n🎉 All rule files are valid!');
  }
}

// Run validation
if (require.main === module) {
  validateRules();
}

module.exports = { validateRules }; 