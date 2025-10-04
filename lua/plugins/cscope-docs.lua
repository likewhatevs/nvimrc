--[[
# Cscope Integration for AstroNvim v5

This configuration provides comprehensive cscope integration following AstroNvim conventions.

## Features:
- Manual cscope database management (no automatic generation)
- Telescope integration for better search results display
- Comprehensive keybindings for all cscope search capabilities
- Call stack visualization
- Smart project root detection

## Keybindings:

### Basic Searches (Leader + c):
- <Leader>cs  - Find symbol (Cs f s)
- <Leader>cg  - Find global definition (Cs f g)
- <Leader>cc  - Find calls to function (Cs f c)
- <Leader>ct  - Find text string (Cs f t)
- <Leader>ce  - Find egrep pattern (Cs f e)
- <Leader>cF  - Find file (Cs f f)
- <Leader>ci  - Find files including file (Cs f i)
- <Leader>cd  - Find functions called by function (Cs f d)
- <Leader>ca  - Find assignments to symbol (Cs f a)

### Database Management:
- <Leader>cb  - Build cscope database (Cs db build)
- <Leader>cB  - Rebuild cscope database with notification (Cs db build)
- <Leader>cS  - Show cscope database connections (Cs db show)

### Stack View:
- <Leader>cv  - View downward call stack (who calls this)
- <Leader>cu  - View upward call stack (what this calls)
- <Leader>cV  - Toggle last call stack view

### Advanced Searches (Leader + C):
These work with the symbol/file under cursor:
- <Leader>Cs  - Find symbol under cursor (Cs f s <word>)
- <Leader>Cg  - Find global definition under cursor (Cs f g <word>)
- <Leader>Cc  - Find calls to function under cursor (Cs f c <word>)
- <Leader>Cd  - Find functions called by function under cursor (Cs f d <word>)
- <Leader>Ca  - Find assignments to symbol under cursor (Cs f a <word>)
- <Leader>Cf  - Find file under cursor (Cs f f <file>)
- <Leader>Ci  - Find files including file under cursor (Cs f i <file>)

## Requirements:
- cscope must be installed on your system
- Works best with C/C++ projects

## Usage:
1. Open a C/C++ project in Neovim
2. Manually build the cscope database using <Leader>cb (Cs db build)
3. Use the keybindings above to navigate your codebase
4. Results are displayed in telescope for better browsing
5. Rebuild the database with <Leader>cb or <Leader>cB after adding new files
6. Check database status with <Leader>cS (Cs db show)

## Configuration:
- Plugin configured in: lua/plugins/user.lua
- Keybindings defined in: lua/plugins/user.lua (using lazy.nvim keys specification)
- Which-key menu labels in: lua/plugins/astrocore.lua
- Manual database generation only (no auto-generation)
- Telescope picker with horizontal layout for better code preview
- Follows AstroNvim v5 best practices for plugin organization

--]]

-- This is a documentation file - no actual configuration here
-- The real configuration is in user.lua and astrocore.lua
return {}