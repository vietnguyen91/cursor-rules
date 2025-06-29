#!/usr/bin/env node

/**
 * Test script for existing project setup
 * Verifies that the setup-existing.sh script works correctly
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Test configuration
const TEST_DIR = path.join(__dirname, '..', '..', 'test-existing-setup');
const SCRIPT_PATH = path.join(__dirname, 'setup-existing.sh');

console.log('🧪 Testing Existing Project Setup Script');
console.log('=========================================\n');

// Clean up function
function cleanup() {
    if (fs.existsSync(TEST_DIR)) {
        console.log('🧹 Cleaning up test directory...');
        execSync(`rm -rf "${TEST_DIR}"`, { stdio: 'inherit' });
    }
}

// Create test project
function createTestProject() {
    console.log('📁 Creating test project...');
    
    // Create test directory
    fs.mkdirSync(TEST_DIR, { recursive: true });
    process.chdir(TEST_DIR);
    
    // Create fake package.json
    const packageJson = {
        name: "test-existing-project",
        version: "1.0.0",
        description: "Test project for existing setup",
        scripts: {
            start: "node index.js"
        },
        dependencies: {
            express: "^4.18.0",
            nuxt: "^3.0.0"
        }
    };
    
    fs.writeFileSync('package.json', JSON.stringify(packageJson, null, 2));
    
    // Create some source files
    fs.mkdirSync('src', { recursive: true });
    fs.writeFileSync('src/index.js', 'console.log("Hello World");');
    
    fs.mkdirSync('pages', { recursive: true });
    fs.writeFileSync('pages/index.vue', '<template><div>Hello</div></template>');
    
    console.log('✅ Test project created');
}

// Run setup script
function runSetupScript() {
    console.log('🔄 Running setup script...');
    
    try {
        // Run setup script with automatic yes responses
        execSync(`echo "y\\ny\\n" | bash "${SCRIPT_PATH}"`, { 
            stdio: 'inherit',
            cwd: TEST_DIR 
        });
        console.log('✅ Setup script completed');
    } catch (error) {
        console.error('❌ Setup script failed:', error.message);
        throw error;
    }
}

// Verify setup results
function verifySetup() {
    console.log('✅ Verifying setup results...');
    
    const checks = [
        {
            name: '.cursor-rules directory',
            path: '.cursor-rules',
            type: 'directory'
        },
        {
            name: '.cursor-rules/src directory',
            path: '.cursor-rules/src',
            type: 'directory'
        },
        {
            name: '.cursor-rules file',
            path: '.cursor-rules',
            type: 'file'
        },
        {
            name: 'docs/tasks directory',
            path: 'docs/tasks',
            type: 'directory'
        },
        {
            name: 'docs/tasks/task-index.json',
            path: 'docs/tasks/task-index.json',
            type: 'file'
        },
        {
            name: 'EXISTING_PROJECT_SETUP.md',
            path: 'EXISTING_PROJECT_SETUP.md',
            type: 'file'
        },
        {
            name: 'docs/features directory',
            path: 'docs/features',
            type: 'directory'
        },
        {
            name: 'current-state-analysis.md',
            path: 'docs/features/F01_ExistingSystem/requirements/current-state-analysis.md',
            type: 'file'
        }
    ];
    
    let passed = 0;
    let failed = 0;
    
    checks.forEach(check => {
        const exists = fs.existsSync(check.path);
        let isCorrectType = false;
        
        if (exists) {
            const stats = fs.statSync(check.path);
            isCorrectType = check.type === 'directory' ? stats.isDirectory() : stats.isFile();
        }
        
        if (exists && isCorrectType) {
            console.log(`  ✅ ${check.name}`);
            passed++;
        } else {
            console.log(`  ❌ ${check.name} - ${exists ? 'wrong type' : 'missing'}`);
            failed++;
        }
    });
    
    console.log(`\n📊 Results: ${passed} passed, ${failed} failed`);
    
    if (failed > 0) {
        throw new Error(`Setup verification failed: ${failed} checks failed`);
    }
}

// Verify task index content
function verifyTaskIndex() {
    console.log('📋 Verifying task index content...');
    
    const taskIndexPath = 'docs/tasks/task-index.json';
    const content = fs.readFileSync(taskIndexPath, 'utf8');
    const taskIndex = JSON.parse(content);
    
    const expectedFields = ['project_name', 'version', 'last_updated', 'features'];
    
    expectedFields.forEach(field => {
        if (taskIndex.hasOwnProperty(field)) {
            console.log(`  ✅ ${field}: ${taskIndex[field]}`);
        } else {
            throw new Error(`Missing field in task index: ${field}`);
        }
    });
    
    // Verify project name matches directory
    const expectedName = path.basename(TEST_DIR);
    if (taskIndex.project_name === expectedName) {
        console.log(`  ✅ Project name matches directory: ${expectedName}`);
    } else {
        throw new Error(`Project name mismatch: expected ${expectedName}, got ${taskIndex.project_name}`);
    }
}

// Verify .cursor-rules content
function verifyCursorRules() {
    console.log('⚙️ Verifying .cursor-rules content...');
    
    const cursorRulesPath = '.cursor-rules';
    const content = fs.readFileSync(cursorRulesPath, 'utf8');
    
    const expectedContent = [
        'Project-Specific Rules',
        'test-existing-project',
        'web-app',
        'has-code',
        'Workflow Configuration',
        'Project Structure Integration'
    ];
    
    expectedContent.forEach(expected => {
        if (content.includes(expected)) {
            console.log(`  ✅ Contains: ${expected}`);
        } else {
            throw new Error(`Missing content in .cursor-rules: ${expected}`);
        }
    });
}

// Main test function
async function runTest() {
    try {
        cleanup();
        createTestProject();
        runSetupScript();
        verifySetup();
        verifyTaskIndex();
        verifyCursorRules();
        
        console.log('\n🎉 All tests passed!');
        console.log('✅ Existing project setup script is working correctly');
        
    } catch (error) {
        console.error('\n❌ Test failed:', error.message);
        process.exit(1);
    } finally {
        cleanup();
    }
}

// Run the test
if (require.main === module) {
    runTest();
}

module.exports = { runTest }; 