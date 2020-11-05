buffer.auto_c_choose_single = false
buffer.auto_c_auto_hide = true
buffer.auto_c_cancel_at_start = true

events.connect(events.CHAR_ADDED,
  function(code)    
    if code ~= 10 and code ~= 32 and code ~= 59 then --ignore enter, space bar, semi-colon
      textadept.editing.autocomplete(buffer.get_lexer(buffer))
    end
  end
)

events.connect(events.AUTO_C_CHAR_DELETED,
  function()
    textadept.editing.autocomplete(buffer.get_lexer(buffer))
  end
)

--Intercept `end` keypress
keys["end"] = function()
  buffer.auto_c_cancel(buffer)
  buffer.line_end(buffer)
end;