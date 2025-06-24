# language-liquid-redux

Tree-sitter–based language support for [Liquid templates](https://shopify.github.io/liquid/) in Pulsar.

## Features

* Snippets for nearly all Liquid tags.
* Indentation hinting.
* Folding of all block-based tags.

## Grammars

* HTML/Liquid (`text.html.liquid`)
* HTML/Liquid with front matter (`text.html.liquid.frontmatter`)
* Markdown/Liquid (`source.gfm.liquid`) (also supports optional front matter)

Other grammars can be made; use `tree-sitter-liquid` as the base parser, then set up in injection for whatever kind of content you want to use with Liquid. See `grammars/*.cson` and `lib/main.js` for guidance.

## Snippets and other conveniences

* Pressing <kbd>Space</kbd> when your cursor is in the middle of `{{}}` or `{%%}` will insert padding on either side of the cursor. You can disable this keybinding if this isn’t your cup of tea.
* To insert an output directive (`{{  }}`), you can use `=` as a snippet tab trigger; this matches the trigger for the equivalent construct in EJS and other templating languages. Likewise, you can use `-` as a tab trigger to insert an empty tag (`{%  %}`).

    In some cases, though, these triggers won’t work. (If `=` or `-` is adjacent to other punctuation, Pulsar wants to use the whole span of punctuation as the trigger.) So these snippet are also bound to commands: `language-liquid-redux:insert-output-directive` and `language-liquid-redux:insert-other-directive`.

    On macOS, these commands are bound to <kbd>Cmd-Ctrl-L</kbd> and <kbd>Cmd-Ctrl-;</kbd>, respectively. On Windows/Linux they’re bound to <kbd>Alt-Shift-L</kbd> and <kbd>Alt-Shift-;</kbd>.
