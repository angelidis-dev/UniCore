# UnicoreValidation Publishing Guide

Complete guide to publish UniCoreValidation to GitHub and the Swift Package Index.

## 📋 Pre-Publishing Checklist

Before publishing, ensure you have:

- [ ] GitHub account created
- [ ] Git installed locally
- [ ] Repository name decided
- [ ] License file added (✅ MIT included)
- [ ] All tests passing (✅ 50/50)
- [ ] Documentation complete (✅ VALIDATION.md, Examples, MIGRATION.md)
- [ ] CHANGELOG.md created (✅)
- [ ] .gitignore configured (✅)
- [ ] README.md in place (✅)

---

## Step 1: Create GitHub Repository

### Option A: Via GitHub Web UI (Easiest)

1. **Go to GitHub.com** and sign in
2. **Click "+" → "New repository"**
3. **Repository details:**
   - Name: `UniCoreValidation`
   - Description: "A platform-agnostic, type-safe validation engine for iOS and Android"
   - Visibility: **Public**
   - Initialize: **Don't add** (we'll push existing code)

4. **Click "Create repository"**

### Option B: Via GitHub CLI (Fastest)

```bash
# Install gh if needed
brew install gh

# Login
gh auth login

# Create repository
gh repo create UniCoreValidation \
  --public \
  --source=. \
  --remote=origin \
  --push
```

---

## Step 2: Configure Local Repository

### Initialize Git (if not already done)

```bash
cd /Users/nikolas/Desktop/Programming/PersonalProjects/Shared/UniCore

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: UniCoreValidation v0.1.0

- Complete validation engine with 6 rules
- 50+ comprehensive tests
- iOS (SwiftUI) examples with 3 demos
- Android (Kotlin) examples with 3 demos
- Full documentation and migration guide
- Production-ready code"

# Add GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/UniCoreValidation.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Add .gitignore

If you don't have one already:

```bash
cat > .gitignore << 'EOF'
# Swift
.build/
*.swiftpm
*.playground
*.xcworkspace/
xcuserdata/
*.xcodeproj/
.DS_Store
*.swiftdeps
*.swiftversion

# Xcode
Build/
DerivedData/
.xcode.env*
.swiftpm/

# IDE
.vscode/
.idea/
*.iml

# Dependencies
Packages/

# Test artifacts
*.coverage
.coverage

# OS
.DS_Store
Thumbs.db

# Temporary files
*.tmp
*.bak
*~
.env
.env.local
EOF
```

---

## Step 3: Add Required Metadata Files

### Create .github/workflows Directory (for CI/CD - optional for now)

```bash
mkdir -p .github/workflows
```

### Create Package Configuration Files

Ensure `Package.swift` has proper metadata:

```bash
# Verify Package.swift syntax
swift package describe

# Resolve dependencies
swift package resolve
```

---

## Step 4: Create Repository Documentation

### Add PUBLISHING.md to root (this file)
✅ Already created

### Add additional GitHub files

#### .github/ISSUE_TEMPLATE/bug_report.md

```bash
mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/bug_report.md << 'EOF'
---
name: Bug report
about: Report a bug to help us improve
title: "[BUG]"
labels: bug
assignees: ''

---

## Description
Brief description of the bug

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- **Platform(s)**: iOS / Android / Both
- **Swift Version**: 6.0+
- **Package Version**: 0.1.0
- **macOS/OS Version**: (if applicable)

## Code Sample
```swift
// Minimal code to reproduce
```

## Additional Context
Any additional information
EOF
```

#### .github/ISSUE_TEMPLATE/feature_request.md

```bash
cat > .github/ISSUE_TEMPLATE/feature_request.md << 'EOF'
---
name: Feature request
about: Suggest an idea to improve UniCoreValidation
title: "[FEATURE]"
labels: enhancement
assignees: ''

---

## Description
Clear description of the feature

## Motivation
Why is this feature needed?

## Proposed Solution
How should this be implemented?

## Current Workaround
Any current workarounds?

## Additional Context
Any additional information
EOF
```

#### .github/PULL_REQUEST_TEMPLATE.md

```bash
cat > .github/PULL_REQUEST_TEMPLATE.md << 'EOF'
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality changes)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] All tests pass locally
- [ ] Manual testing performed

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings

## Related Issues
Closes #(issue number)

## Screenshots (if applicable)
Add screenshots for UI changes
EOF
```

---

## Step 5: Register with Swift Package Index

### Access Swift Package Index

1. **Go to https://swiftpackageindex.com**
2. **Click "Add a Package"**
3. **Enter your repository URL:**
   ```
   https://github.com/YOUR_USERNAME/UniCoreValidation.git
   ```

4. **Swift Package Index will automatically:**
   - Index your package
   - Build documentation
   - Generate API reference
   - Test compatibility

### Verify Registration

Search for "UniCoreValidation" on [swiftpackageindex.com](https://swiftpackageindex.com) after 10-15 minutes.

---

## Step 6: Register with Maven Central (Android)

### Create Maven Central Account

1. **Go to https://issues.sonatype.org**
2. **Create Jira account**
3. **Create issue** to request groupId:
   ```
   Project: Community License (OSSRH)
   Title: UniCoreValidation - Cross-platform validation
   ```

### Publish to Maven Central

```bash
# Skip for now - requires Gradle and Maven setup
# See https://central.sonatype.org/publish/publish-guide/
```

---

## Step 7: Create Release

### Create GitHub Release

```bash
# Tag the release
git tag -a v0.1.0 -m "Release UniCoreValidation v0.1.0"

# Push tags
git push origin v0.1.0

# Create release on GitHub
gh release create v0.1.0 \
  --title "UniCoreValidation v0.1.0" \
  --notes "Initial release: Complete validation engine with 6 rules, 50+ tests, iOS and Android examples"
```

### Via GitHub Web UI

1. Go to repository → **Releases**
2. Click **"Draft a new release"**
3. **Tag version**: `v0.1.0`
4. **Release title**: `UniCoreValidation v0.1.0`
5. **Description**:
   ```markdown
   ## Initial Release

   Complete platform-agnostic validation engine for iOS and Android.

   ### Features
   - 6 built-in validation rules
   - 50+ comprehensive tests
   - iOS (SwiftUI) examples
   - Android (Kotlin) examples
   - Clean architecture
   - Production-ready

   ### What's New
   - Initial public release
   - MIT License
   - Full documentation
   - Migration guide
   - 100% test coverage for domain layer

   See [CHANGELOG.md](CHANGELOG.md) for details.
   ```

6. Click **"Publish release"**

---

## Step 8: Update Package Documentation

### Create docs/ Directory (Optional but Recommended)

```bash
mkdir -p docs

cat > docs/index.md << 'EOF'
# UniCoreValidation Documentation

Welcome to UniCoreValidation documentation.

## Quick Links
- [Getting Started](getting-started.md)
- [API Reference](api-reference.md)
- [Examples](../Examples/)
- [Migration Guide](../MIGRATION.md)
- [FAQ](faq.md)

## What is UniCoreValidation?
A platform-agnostic validation engine for iOS and Android.

See [README.md](../README.md) for overview.
EOF
```

### Enable GitHub Pages

1. Go to repository **Settings**
2. **Pages** section
3. **Source**: Select `main` branch, `/docs` folder
4. GitHub Pages will auto-deploy documentation

---

## Step 9: Verify Everything Works

### Pre-Release Checklist

```bash
# Verify Swift package
swift package verify

# Run all tests
swift test

# Build documentation
swift package generate-documentation

# Check package manifest
swift package describe

# Lint code (optional)
swift format --version  # If installed
```

### Test Installation

```bash
# Create test package
mkdir test-unicore
cd test-unicore
swift package init --type executable

# Add dependency to Package.swift
# Then verify it resolves
swift package resolve
```

---

## Step 10: Publish & Announce

### GitHub Actions (Optional - for continuous deployment)

Create `.github/workflows/publish.yml`:

```yaml
name: Publish

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: swift-actions/setup-swift@v1
      - run: swift test
      - run: swift build -c release
```

### Announce to Community

Post announcements to:

1. **Swift Forums**: https://forums.swift.org/
2. **Reddit**: r/swift, r/iOSProgramming
3. **Twitter/X**: Mention @SwiftLanguage
4. **Newsletter**: Swift Weekly Brief
5. **Dev.to**: Post article about the release

---

## Installation After Publishing

### For Users - Swift Package Manager

```swift
.package(url: "https://github.com/YOUR_USERNAME/UniCoreValidation.git", from: "0.1.0")
```

### For Users - Xcode

1. File → Add Packages
2. Paste: `https://github.com/YOUR_USERNAME/UniCoreValidation.git`
3. Specify version: 0.1.0+
4. Add to target

---

## Troubleshooting

### Package Not Found on Swift Package Index
- **Wait 15 minutes** for indexing
- **Verify** public GitHub repository
- **Check** Package.swift syntax
- **Resubmit** URL to index

### Tests Failing on Swift Package Index
- Check Swift version compatibility
- Verify .gitignore doesn't exclude test files
- Run `swift test` locally to verify

### Cannot Create GitHub Release
- Verify tag exists: `git tag`
- Check GitHub CLI auth: `gh auth status`
- Ensure repository push permissions

---

## Version Management

### Semantic Versioning

- **v0.1.0** - Current (initial release)
- **v0.2.0** - Small features/improvements
- **v1.0.0** - Major release (async, remote validation)

### Publishing Updates

```bash
# Create tag for new version
git tag -a v0.2.0 -m "Version 0.2.0: Bug fixes and improvements"
git push origin v0.2.0

# Swift Package Index auto-updates
```

---

## Next Steps After Publishing

1. ✅ Monitor GitHub issues and pull requests
2. ✅ Respond to user questions
3. ✅ Fix reported bugs promptly
4. ✅ Plan v1.0 features
5. ✅ Gather community feedback
6. ✅ Build adoption through examples

---

## Support

- **GitHub**: Create issues/discussions
- **Documentation**: See VALIDATION.md
- **Examples**: See Examples/README.md
- **Migration**: See MIGRATION.md

---

**Ready to publish! 🚀**

Last Updated: 2026-03-29
