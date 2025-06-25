; EMBEDDED
; ========

((output_directive) @meta.embedded.line.output-directive.liquid
  (#is? test.endsOnSameRowAs startPosition))

([
  (assign_directive)
  (increment_directive)
  (decrement_directive)
  (echo_directive)
  (for_directive)
  (endfor_directive)
  (case_directive)
  (when_directive)
  (render_directive)
  (include_directive)
  (layout_directive)
  (endcase_directive)
  (custom_directive)
  (if_directive)
  (elsif_directive)
  (else_directive)
  (endif_directive)
  (unless_directive)
  (endunless_directive)
  (comment_directive)
  (endcomment_directive)
  (raw_directive)
  (endraw_directive)
  (capture_directive)
  (endcapture_directive)
  (tablerow_directive)
  (endtablerow_directive)
] @meta.embedded.line.directive.liquid
  (#is? test.endsOnSameRowAs startPosition)
)

([
  (assign_directive)
  (increment_directive)
  (decrement_directive)
  (echo_directive)
  (for_directive)
  (endfor_directive)
  (case_directive)
  (when_directive)
  (render_directive)
  (include_directive)
  (layout_directive)
  (endcase_directive)
  (if_directive)
  (elsif_directive)
  (else_directive)
  (endif_directive)
  (unless_directive)
  (endunless_directive)
  (comment_directive)
  (endcomment_directive)
  (raw_directive)
  (endraw_directive)
  (capture_directive)
  (endcapture_directive)
  (tablerow_directive)
  (endtablerow_directive)
] @meta.embedded.block.directive.liquid
  (#is-not? test.endsOnSameRowAs startPosition)
)

; `liquid` tags get their own scope name because they have special comment
; semantics. So we need to know when we're inside one so we can deliver the
; appropriate comment delimiter.
((liquid_directive) @meta.embedded.line.directive.liquid-directive.liquid
  (#is? test.endsOnSameRowAs startPosition)
)
((liquid_directive) @meta.embedded.block.directive.liquid-directive.liquid
  (#is-not? test.endsOnSameRowAs startPosition)
)

; An "empty" directive (`{%%}`) is detected by `tree-sitter-liquid` and given
; a special scope name so we can detect when we're within one and pad on either
; side of the cursor when we press `Space`.
((empty_directive) @meta.embedded.line.directive.empty.liquid
  (#is? test.endsOnSameRowAs startPosition)
)

; COMMENTS
; ========

((comment) @comment.line.number-sign.liquid
  (#is? test.endsOnSameRowAs startPosition))

; A line comment within an “empty” directive like `{% # foo bar %}`.
((comment) @comment.line.number-sign.liquid
  (#is? test.descendantOfType "comment_directive"))

; A line comment within an multi-line `liquid` tag like:
;
; {% liquid
;   # do something
;   echo 'foo'
; %}
((comment) @comment.line.number-sign.liquid
  (#is? test.descendantOfType "liquid_directive"))

; Content within a `{% comment %}`/`{% endcomment %}` block.
(comment_block
  (comment) @comment.block.liquid
)

; VARIABLES
; =========

(assign_directive
  left: (identifier) @variable.other.assignment.liquid
)
(liquid_assign_statement
  left: (identifier) @variable.other.assignment.liquid
)

; The first identifier in a `for` loop is an assignment…
(for_directive
  left: (identifier) @variable.other.assignment.loop.liquid)
(liquid_for_statement
  left: (identifier) @variable.other.assignment.loop.liquid)

; …and same for a `tablerow` loop.
(tablerow_directive
  left: (identifier) @variable.other.assignment.loop.liquid)
(liquid_tablerow_statement
  left: (identifier) @variable.other.assignment.loop.liquid)

; Increment and decrement statements/directives are assignments.
(increment_directive (identifier) @variable.other.assignment.liquid)
(liquid_increment_statement (identifier) @variable.other.assignment.liquid)
(decrement_directive (identifier) @variable.other.assignment.liquid)
(liquid_decrement_statement (identifier) @variable.other.assignment.liquid)
; A `capture` block acts as an assignment.
(capture_directive (identifier) @variable.other.assignment.liquid)

; OPERATORS
; =========

[
  "="
] @keyword.operator.assignment.liquid

[
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
] @keyword.operator.comparison.liquid

(selector_expression "." @keyword.operator.accessor.liquid)

[
  "for" "endfor" "in"
  "if" "endif" "elsif" "else"
  "unless" "endunless"
  "case" "endcase" "when"
  "capture" "endcapture"
  "comment" "endcomment"
  "raw" "endraw"
  "tablerow" "endtablerow"
  "layout"
] @keyword.control.block._TYPE_.liquid

(empty) @constant.language.empty.liquid

(custom_directive tag: (_) @entity.name.tag.liquid)

; With `for` blocks
(selector_expression
  operand: (identifier) @support.forloop.liquid
  (#match? @support.forloop.liquid "^forloop$")
  (#is? test.descendantOfType "for_block liquid_for_block"))

; With `for` blocks
(selector_expression
  operand: (identifier) @support.tablerowloop.liquid
  (#match? @support.tablerowloop.liquid "^tablerowloop$")
  (#is? test.descendantOfType "tablerow_block liquid_tablerow_block"))


[
  "assign"
  "render"
  "liquid"
  "increment"
  "decrement"
  "echo"
] @keyword.control.directive._TYPE_.liquid
"|" @keyword.operator.filter.liquid

; STRINGS
; =======

((string) @string.quoted.double.liquid
  (#match? @string.quoted.double.liquid "^\""))

((string) @string.quoted.single.liquid
  (#match? @string.quoted.single.liquid "^'"))

((string) @punctuation.definition.string.begin.liquid
  (#set! adjust.endAfterFirstMatchOf "^."))

((string) @punctuation.definition.string.end.liquid
  (#set! adjust.startBeforeFirstMatchOf ".$"))

(string (escape_sequence) @constant.character.escape.liquid)


; CONSTANTS
; =========

(number) @constant.numeric.liquid
(boolean) @constant.boolean.__TEXT__.liquid


; FILTERS
; =======

(filter_expression
  name: (identifier) @entity.other.attribute-name.liquid)

(filter_expression ":" @punctuation.separator.colon.liquid)


(render_parameter
  key: (_) @entity.other.attribute-name.parameter)


; PUNCTUATION
; ===========

["{%" "{%-"] @punctuation.delimiter.directive.start.liquid
["%}" "-%}"] @punctuation.delimiter.directive.end.liquid
