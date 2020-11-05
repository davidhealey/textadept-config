-- Copyright 2006-2020 Mitchell. See LICENSE.
-- JavaScript LPeg lexer.
-- Daves javascript lexer

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('javascript')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  abstract boolean break byte case catch char class const continue debugger
  default delete do double else enum export extends false final finally float
  for function get goto if implements import in instanceof int interface let
  long native new null of package private protected public return set short
  static super switch synchronized this throw throws transient true try typeof
  var void volatile while with yield
]]))

-- Classes.
lex:add_rule('class', token(lexer.CLASS, word_match[[
document event navigator performance screen window console localStorage
]]))

-- Functions.
lex:add_rule('function', token(lexer.FUNCTION, word_match[[
acceptNode add addEventListener addTextTrack adoptNode after animate append
appendChild appendData before blur canPlayType captureStream
caretPositionFromPoint caretRangeFromPoint checkValidity clear click
cloneContents cloneNode cloneRange close closest collapse
compareBoundaryPoints compareDocumentPosition comparePoint contains
convertPointFromNode convertQuadFromNode convertRectFromNode createAttribute
createAttributeNS createCaption createCDATASection createComment
createContextualFragment createDocument createDocumentFragment
createDocumentType createElement createElementNS createEntityReference
createEvent createExpression createHTMLDocument createNodeIterator
createNSResolver createProcessingInstruction createRange createShadowRoot
createTBody createTextNode createTFoot createTHead createTreeWalker delete
deleteCaption deleteCell deleteContents deleteData deleteRow deleteTFoot
deleteTHead detach disconnect dispatchEvent elementFromPoint elementsFromPoint
enableStyleSheetsForSet entries evaluate execCommand exitFullscreen
exitPointerLock expand extractContents fastSeek firstChild focus forEach get
getAll getAnimations getAttribute getAttributeNames getAttributeNode
getAttributeNodeNS getAttributeNS getBoundingClientRect getBoxQuads
getClientRects getContext getDestinationInsertionPoints getElementById
getElementsByClassName getElementsByName getElementsByTagName
getElementsByTagNameNS getItem getNamedItem getSelection getStartDate
getVideoPlaybackQuality has hasAttribute hasAttributeNS hasAttributes
hasChildNodes hasFeature hasFocus importNode initEvent insertAdjacentElement
insertAdjacentHTML insertAdjacentText insertBefore insertCell insertData
insertNode insertRow intersectsNode isDefaultNamespace isEqualNode
isPointInRange isSameNode item key keys lastChild load log lookupNamespaceURI
lookupPrefix matches move moveAttribute moveAttributeNode moveChild
moveNamedItem namedItem nextNode nextSibling normalize observe open
parentNode pause play postMessage prepend preventDefault previousNode
previousSibling probablySupportsContext queryCommandEnabled
queryCommandIndeterm queryCommandState queryCommandSupported queryCommandValue
querySelector querySelectorAll registerContentHandler registerElement
registerProtocolHandler releaseCapture releaseEvents remove removeAttribute
removeAttributeNode removeAttributeNS removeChild removeEventListener
removeItem replace replaceChild replaceData replaceWith reportValidity
requestFullscreen requestPointerLock reset scroll scrollBy scrollIntoView
scrollTo seekToNextFrame select selectNode selectNodeContents set setAttribute
setAttributeNode setAttributeNodeNS setAttributeNS setCapture
setCustomValidity setEnd setEndAfter setEndBefore setItem setNamedItem
setRangeText setSelectionRange setSinkId setStart setStartAfter setStartBefore
slice splitText stepDown stepUp stopImmediatePropagation stopPropagation
submit substringData supports surroundContents takeRecords terminate toBlob
toDataURL toggle toString values write writeln
]]))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Comments.
local line_comment = lexer.to_eol('//', true)
local block_comment = lexer.range('/*', '*/')
lex:add_rule('comment', token(lexer.COMMENT, line_comment + block_comment))

-- Strings.
local sq_str = lexer.range("'")
local dq_str = lexer.range('"')
local bq_str = lexer.range('`')
local string = token(lexer.STRING, sq_str + dq_str + bq_str)
local regex_str = #P('/') * lexer.last_char_includes('+-*%^!=&|?:;,([{<>') *
  lexer.range('/', true) * S('igm')^0
local regex = token(lexer.REGEX, regex_str)
lex:add_rule('string', string + regex)

-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('+-/*%^!=&|?:;,.()[]{}<>')))

-- Fold points.
lex:add_fold_point(lexer.OPERATOR, '{', '}')
lex:add_fold_point(lexer.COMMENT, '/*', '*/')
lex:add_fold_point(lexer.COMMENT, lexer.fold_consecutive_lines('//'))

return lex
