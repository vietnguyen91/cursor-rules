#!/usr/bin/env node

/**
 * 🔍 Cursor Rules Validator
 * Validates .cursor/rules/*.mdc files for correct frontmatter and format
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

class CursorRulesValidator {
    constructor(rulesDir = '.cursor/rules') {
        this.rulesDir = rulesDir;
        this.errors = [];
        this.warnings = [];
        this.validRules = [];
    }

    // Validate all .mdc files in .cursor/rules
    validateAll() {
        console.log('🔍 Validating Cursor Rules Format...\n');
        
        if (!fs.existsSync(this.rulesDir)) {
            this.errors.push(`Rules directory not found: ${this.rulesDir}`);
            return this.generateReport();
        }

        const mdcFiles = this.findMdcFiles(this.rulesDir);
        
        if (mdcFiles.length === 0) {
            this.warnings.push('No .mdc files found in rules directory');
            return this.generateReport();
        }

        mdcFiles.forEach(file => this.validateFile(file));
        
        return this.generateReport();
    }

    // Find all .mdc files recursively
    findMdcFiles(dir) {
        const files = [];
        
        const scan = (currentDir) => {
            const items = fs.readdirSync(currentDir);
            items.forEach(item => {
                const fullPath = path.join(currentDir, item);
                const stat = fs.statSync(fullPath);
                
                if (stat.isDirectory()) {
                    scan(fullPath);
                } else if (item.endsWith('.mdc')) {
                    files.push(fullPath);
                }
            });
        };
        
        scan(dir);
        return files;
    }

    // Validate individual .mdc file
    validateFile(filePath) {
        try {
            const content = fs.readFileSync(filePath, 'utf-8');
            const fileName = path.basename(filePath);
            
            // Check frontmatter exists
            if (!content.startsWith('---\n')) {
                this.errors.push(`${fileName}: Missing frontmatter start`);
                return;
            }

            // Extract frontmatter
            const frontmatterEnd = content.indexOf('\n---\n', 4);
            if (frontmatterEnd === -1) {
                this.errors.push(`${fileName}: Missing frontmatter end`);
                return;
            }

            const frontmatterText = content.slice(4, frontmatterEnd);
            
            // Parse YAML frontmatter
            let frontmatter;
            try {
                frontmatter = yaml.load(frontmatterText);
            } catch (yamlError) {
                this.errors.push(`${fileName}: Invalid YAML frontmatter - ${yamlError.message}`);
                return;
            }

            // Validate required fields
            this.validateFrontmatter(fileName, frontmatter);
            
            // Validate naming convention
            this.validateNaming(fileName, frontmatter);
            
            // Validate rule type consistency
            this.validateRuleType(fileName, frontmatter);
            
            this.validRules.push({
                file: fileName,
                path: filePath,
                frontmatter
            });
            
        } catch (error) {
            this.errors.push(`${path.basename(filePath)}: Error reading file - ${error.message}`);
        }
    }

    // Validate frontmatter fields
    validateFrontmatter(fileName, frontmatter) {
        // Required fields for Cursor
        const requiredFields = ['description', 'globs', 'alwaysApply'];
        
        requiredFields.forEach(field => {
            if (!(field in frontmatter)) {
                this.errors.push(`${fileName}: Missing required field '${field}'`);
            }
        });

        // Validate field types
        if (frontmatter.description !== undefined && typeof frontmatter.description !== 'string') {
            this.errors.push(`${fileName}: 'description' must be a string`);
        }

        if (frontmatter.globs !== undefined && typeof frontmatter.globs !== 'string') {
            this.errors.push(`${fileName}: 'globs' must be a string`);
        }

        if (frontmatter.alwaysApply !== undefined && typeof frontmatter.alwaysApply !== 'boolean') {
            this.errors.push(`${fileName}: 'alwaysApply' must be a boolean`);
        }
    }

    // Validate naming convention
    validateNaming(fileName, frontmatter) {
        const nameParts = fileName.replace('.mdc', '').split('-');
        const ruleType = nameParts[nameParts.length - 1];
        
        const validTypes = ['always', 'agent', 'auto', 'manual'];
        
        if (!validTypes.includes(ruleType)) {
            this.warnings.push(`${fileName}: Naming convention issue - expected format 'name-{always|agent|auto|manual}.mdc'`);
        }
    }

    // Validate rule type consistency
    validateRuleType(fileName, frontmatter) {
        const { description, globs, alwaysApply } = frontmatter;
        const fileType = fileName.includes('-always') ? 'always' :
                        fileName.includes('-agent') ? 'agent' :
                        fileName.includes('-auto') ? 'auto' :
                        fileName.includes('-manual') ? 'manual' : 'unknown';

        // Always rules validation
        if (fileType === 'always') {
            if (alwaysApply !== true) {
                this.errors.push(`${fileName}: Always rules must have alwaysApply: true`);
            }
            if (description && description.trim() !== '') {
                this.warnings.push(`${fileName}: Always rules typically have empty description`);
            }
            if (globs && globs.trim() !== '') {
                this.warnings.push(`${fileName}: Always rules typically have empty globs`);
            }
        }

        // Agent rules validation
        if (fileType === 'agent') {
            if (!description || description.trim() === '') {
                this.errors.push(`${fileName}: Agent rules require descriptive description`);
            }
            if (alwaysApply === true) {
                this.errors.push(`${fileName}: Agent rules should have alwaysApply: false`);
            }
            if (globs && globs.trim() !== '') {
                this.warnings.push(`${fileName}: Agent rules typically have empty globs`);
            }
        }

        // Auto rules validation
        if (fileType === 'auto') {
            if (!globs || globs.trim() === '') {
                this.errors.push(`${fileName}: Auto rules require glob patterns`);
            }
            if (alwaysApply === true) {
                this.errors.push(`${fileName}: Auto rules should have alwaysApply: false`);
            }
        }

        // Manual rules validation
        if (fileType === 'manual') {
            if (alwaysApply === true) {
                this.errors.push(`${fileName}: Manual rules should have alwaysApply: false`);
            }
            if (description && description.trim() !== '') {
                this.warnings.push(`${fileName}: Manual rules typically have empty description`);
            }
            if (globs && globs.trim() !== '') {
                this.warnings.push(`${fileName}: Manual rules typically have empty globs`);
            }
        }
    }

    // Generate validation report
    generateReport() {
        console.log('📊 VALIDATION RESULTS');
        console.log('====================\n');

        // Summary
        console.log(`📄 Files processed: ${this.validRules.length + this.errors.length}`);
        console.log(`✅ Valid rules: ${this.validRules.length}`);
        console.log(`❌ Errors: ${this.errors.length}`);
        console.log(`⚠️  Warnings: ${this.warnings.length}\n`);

        // Errors
        if (this.errors.length > 0) {
            console.log('❌ ERRORS:');
            this.errors.forEach(error => console.log(`  ${error}`));
            console.log();
        }

        // Warnings
        if (this.warnings.length > 0) {
            console.log('⚠️  WARNINGS:');
            this.warnings.forEach(warning => console.log(`  ${warning}`));
            console.log();
        }

        // Valid rules breakdown
        if (this.validRules.length > 0) {
            console.log('✅ VALID RULES BY TYPE:');
            const rulesByType = this.groupRulesByType();
            Object.entries(rulesByType).forEach(([type, rules]) => {
                console.log(`  ${type}: ${rules.length} rules`);
                rules.forEach(rule => console.log(`    - ${rule.file}`));
            });
            console.log();
        }

        // Recommendations
        this.generateRecommendations();

        const success = this.errors.length === 0;
        console.log(success ? '🎉 All rules are valid!' : '💥 Validation failed - please fix errors above');
        
        return success;
    }

    // Group rules by type for reporting
    groupRulesByType() {
        const groups = {
            'Always Apply': [],
            'Agent Requested': [],
            'Auto Attached': [],
            'Manual': [],
            'Unknown': []
        };

        this.validRules.forEach(rule => {
            const fileName = rule.file;
            if (fileName.includes('-always')) {
                groups['Always Apply'].push(rule);
            } else if (fileName.includes('-agent')) {
                groups['Agent Requested'].push(rule);
            } else if (fileName.includes('-auto')) {
                groups['Auto Attached'].push(rule);
            } else if (fileName.includes('-manual')) {
                groups['Manual'].push(rule);
            } else {
                groups['Unknown'].push(rule);
            }
        });

        return groups;
    }

    // Generate recommendations
    generateRecommendations() {
        console.log('💡 RECOMMENDATIONS:');
        
        const ruleTypes = this.groupRulesByType();
        
        if (ruleTypes['Always Apply'].length > 5) {
            console.log('  - Consider reducing "Always Apply" rules for better performance');
        }
        
        if (ruleTypes['Unknown'].length > 0) {
            console.log('  - Fix naming convention for unknown rule types');
        }
        
        if (this.warnings.length > 0) {
            console.log('  - Review warnings for potential improvements');
        }
        
        if (this.validRules.length === 0) {
            console.log('  - Create some rules to get started with Cursor automation');
        }
        
        console.log('  - Run conversion regularly to keep rules up-to-date');
        console.log();
    }
}

// Run validation if called directly
if (require.main === module) {
    const rulesDir = process.argv[2] || '.cursor/rules';
    const validator = new CursorRulesValidator(rulesDir);
    const success = validator.validateAll();
    process.exit(success ? 0 : 1);
}

module.exports = CursorRulesValidator; 