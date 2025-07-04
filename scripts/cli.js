#!/usr/bin/env node

/*
 * Cursor Rules Agent CLI
 * Lightweight wrapper so users can run `npx cursor-rules-agent <command>`
 * Commands:
 *   install   – convert workflow rules & deploy to current working directory
 *   convert   – run convert-to-cursor-rules.sh (same as install but stays local)
 *   validate  – run validate-cursor-rules.js against current project
 *   deploy    – alias for convert
 */

const { spawnSync } = require('child_process');
const path = require('path');

const [, , cmd, ...rest] = process.argv;

const SCRIPT_DIR = __dirname;

function run(command, args, options = {}) {
  const result = spawnSync(command, args, { stdio: 'inherit', ...options });
  if (result.error) {
    console.error('❌ Error executing', command, result.error.message);
    process.exit(result.status ?? 1);
  }
  process.exit(result.status ?? 0);
}

switch (cmd) {
  case 'install':
  case 'convert':
  case 'deploy': {
    // Path to conversion script inside this package
    const scriptPath = path.join(SCRIPT_DIR, 'convert-to-cursor-rules.sh');
    // Target directory: cwd for install, else argument or cwd
    const targetDir = cmd === 'install' ? process.cwd() : rest[0] || process.cwd();
    run('bash', [scriptPath, targetDir]);
    break;
  }
  case 'validate': {
    const validateScript = path.join(SCRIPT_DIR, 'validate-cursor-rules.js');
    run('node', [validateScript, ...rest]);
    break;
  }
  case 'help':
  default:
    console.log(`Cursor Rules Agent CLI  v${require('../package.json').version}
Usage:
  npx cursor-rules-agent install            # Convert & deploy rules into current project
  npx cursor-rules-agent convert [path]     # Convert rules into [path] (defaults cwd)
  npx cursor-rules-agent validate           # Validate rules in current project
  npx cursor-rules-agent help               # Show this help message
`);
    process.exit(0);
} 