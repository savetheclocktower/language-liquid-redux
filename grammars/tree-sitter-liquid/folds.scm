([
  (for_block)
  (tablerow_block)
  (capture_block)
  (block_block)
  (raw_block)
  (liquid_for_block)
  (liquid_tablerow_block)
] @fold
  ; Directives are wide, so let's keep them on separate lines even when they're
  ; folded.
  (#set! fold.adjustToEndOfPreviousRow))

[
  (liquid_unless_statement)
  (liquid_if_statement)
  (liquid_case_statement)
  (if_directive)
  (unless_directive)
  (case_directive)
] @fold.start

[
  (elsif_directive)
  (else_directive)
  (when_directive)
  (liquid_elsif_statement)
  (liquid_else_statement)
  (liquid_when_statement)
] @fold.end @fold.start

[
  (liquid_endif_statement)
  (liquid_endunless_statement)
  (liquid_endcase_statement)
  (endif_directive)
  (endunless_directive)
  (endcase_directive)
] @fold.end
