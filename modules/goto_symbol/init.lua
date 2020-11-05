-- Author: mitchell

local CTAGS
if WIN32 then
  CTAGS = '"c:\\bin\\ctags.exe" --sort=yes --fields=+K-f'
else
  CTAGS = 'ctags --sort=yes --fields=+K-f'
end

---
-- Goes to the selected symbol in a filtered list dialog.
-- Requires 'ctags' to be installed.
function goto_symbol()
  local buffer = buffer
  if not buffer.filename then return end
  local symbols = {}
  local p = io.popen(CTAGS..' --excmd=number -f - "'..buffer.filename..'"')
  for line in p:read('*all'):gmatch('[^\r\n]+') do
    local name, line, ext = line:match('^(%S+)\t[^\t]+\t([^;]+);"\t(.+)$')
    if name and line and ext then
      symbols[#symbols + 1] = name
      symbols[#symbols + 1] = ext
      symbols[#symbols + 1] = line
    end
  end
  if #symbols > 0 then
    local button, i = ui.dialogs.filteredlist{
      title = 'Goto Symbol', columns = {'Name', 'Type', 'Line'}, items = symbols
    }
    if button == 1 then buffer:goto_line(tonumber(symbols[i * 3]) - 1) end
  end
  p:close()
end
