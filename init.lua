view:set_theme(not CURSES and 'base16-onedark-daves' or 'term',{size = 14})

-- Highlight all occurrences of the selected word.
textadept.editing.highlight_words = textadept.editing.HIGHLIGHT_SELECTED

_M.file_browser = require 'file_browser'

require('spellcheck')
require('goto_symbol')
require('common') -- multi edit, enclose, 
require('autocomplete_autopopup')

--Multiedit settings
buffer.multiple_selection = true
buffer.additional_selection_typing = true
buffer.additional_carets_visible = true

--keys
keys['ctrl+r'] = function() goto_symbol() end
keys['ctrl+d'] = textadept.editing.select_word
keys['alt+d'] = function() buffer.line_duplicate() end