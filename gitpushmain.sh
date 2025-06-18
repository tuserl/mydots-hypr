#!/bin/bash

# Show current effective Git editor
actual_editor=$(git var GIT_EDITOR 2>/dev/null || echo "<none>")
configured_editor=$(git config --get core.editor)

echo "🛠️  Current effective Git editor: $actual_editor"

if [[ "$configured_editor" != "nvim" ]]; then
  echo "⚠️  Git core.editor is not set to 'nvim' (currently: '${configured_editor:-<not set>}')"
  read -p "Do you want to set Git editor to 'nvim'? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git config --global core.editor "nvim"
    echo "✅ Git core.editor set to 'nvim'"
  else
    echo "❌ Skipping change. Using current editor: $actual_editor"
  fi
else
  echo "✅ Git core.editor is already set to 'nvim'"
fi

# Run your pre-commit copy script
./cp.sh

# Stage all changes
git add .

# Open configured editor for commit message
git commit

# Push to current branch
git push
