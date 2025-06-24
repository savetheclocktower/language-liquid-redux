const { Point, Range } = require('atom');

exports.activate = () => {

  // Inject HTML into the "HTML (Liquid)" grammar.
  atom.grammars.addInjectionPoint('text.html.liquid', {
    type: 'template',
    language() {
      return 'html';
    },
    content(node) {
      return node.descendantsOfType('content');
    },
    subtractAdjacentWhitespace: true
  });

  // Inject YAML into the front matter for "HTML (Liquid with Front Matter)"
  // grammar.
  atom.grammars.addInjectionPoint('text.html.liquid.frontmatter', {
    type: 'front_matter',
    language: () => 'yaml',
    content(node) {
      return node.descendantsOfType('text');
    }
  });

  // The non-front-matter stuff in "HTML (Liquid with Front Matter)" is handed
  // to the "HTML (Liquid)" grammar (which, in turn, will inject HTML.)
  atom.grammars.addInjectionPoint('text.html.liquid.frontmatter', {
    type: 'remainder',
    language: () => 'liquid-html',
    content: (node) => node,
    languageScope: null
  });

  // Inject Markdown into the "Markdown (Liquid)" grammar. This
  // grammar supports optional front matter on its own.
  atom.grammars.addInjectionPoint('source.gfm.liquid', {
    type: 'template',
    language() {
      return 'markdown';
    },
    content(node) {
      return node.descendantsOfType('content');
    },
    subtractAdjacentWhitespace: true
  });


  function getCharactersOnEitherSideOfCursor (cursor) {
    let point = cursor.getBufferPosition();
    let editor = cursor.editor;

    let lRange = new Range(
      new Point(point.row, point.column - 1),
      point
    );

    let rRange = new Range(
      point,
      new Point(point.row, point.column + 1)
    );

    return [
      editor.getTextInBufferRange(lRange),
      editor.getTextInBufferRange(rRange)
    ];
  }


  function isWithinEmptyDirective (cursor) {
    let descriptor = cursor.getScopeDescriptor();
    if (!descriptor.getScopesArray().some((scope) => {
      // `tree-sitter-liquid` will detect both `{{}}` and `{%%}` and give them
      // enough scope decoration for us to be able to detect that we're within
      // those blocks.
      return scope.endsWith('liquid') && scope.startsWith('meta.embedded.line')
    })) {
      return false;
    }
    // But let's make sure we're in the dead center of either one!
    let [l, r] = getCharactersOnEitherSideOfCursor(cursor);
    if (l === '%' & r === '%') return true;
    if (l === '{' & r === '}') return true;
    return false;
  }

  atom.commands.add('atom-text-editor', {
    // Pad on both sides if you press `Space` while your cursor's in an empty
    // directive.
    ['language-liquid-redux:pad-between-directives']: (event) => {
      let editor = event.target.closest('atom-text-editor')?.getModel() ??
        atom.workspace.getActiveTextEditor();
      if (!editor) {
        event.abortKeyBinding();
        return;
      }
      let applicableCursors = editor.getCursors()
        .filter(cursor => isWithinEmptyDirective(cursor));

      // If _no_ cursors need padding, we can pretend this never ran.
      if (applicableCursors.length === 0) {
        event.abortKeyBinding();
        return;
      }

      // Otherwise, we'll pad the characters that need it and insert an
      // ordinary space character for the rest.
      for (let cursor of editor.getCursors()) {
        if (!applicableCursors.includes(cursor)) {
          cursor.selection.insertText(' ');
          continue;
        }
        cursor.selection.insertText('  ');
        cursor.moveLeft();
      }
    }
  });

};
