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

## Custom tags

There is a major caveat here: the `tree-sitter-liquid` parser powering this language bundle knows a lot about built-in “paired” tags. That means stuff like `{% for %}`/`{% endfor %}`, `{% capture %}`/`{% endcapture %}`, and so on. That’s how we can do proper indentation hinting and folding for those blocks.

There are also plenty of “unpaired” tags built into Liquid — `render`, `elsif`, `when`, etc. For these tags, there is no corresponding ending tag. Some of these still have indentation hinting and code folding within their context and some don’t. We know which is which because they’re built into the language.

But various tools enable _custom_ tags of both paired and unpaired varieties within Liquid. In Eleventy, for instance, you can define [shortcodes](https://www.11ty.dev/docs/shortcodes/) that are either unpaired and function as macros… or paired and function as macros that can contain arbitrary content.

```liquid
{% wat 'foo', 1, 2, 3 %}

{% narf 1, 2, 3 %}
{% endnarf %}
```

When the parser sees `{% wat 1, 2, 3 %}`, it has _no clue_ whether there will be a corresponding `{% endwat %}` later in the document. A parser like `tree-sitter-html` can handle this situation because it knows ahead of time which tags are self-closing and which are not; we don’t enjoy that luxury.

Therefore: custom tags are supported, but they are all treated as unpaired directives. On the parser level, there is no formal relationship between `{% narf 1, 2, 3 %}` and `{% endnarf %}` the way there is between `{% capture foo %}` and `{% endcapture %}`. Hence you won’t get indentation hinting or code folding on custom paired tags. Sorry!

## Snippets and other conveniences

* Pressing <kbd>Space</kbd> when your cursor is in the middle of `{{}}` or `{%%}` will insert padding on either side of the cursor. You can disable this keybinding if this isn’t your cup of tea.
* To insert an output directive (`{{  }}`), you can use `=` as a snippet tab trigger; this matches the trigger for the equivalent construct in EJS and other templating languages. Likewise, you can use `-` as a tab trigger to insert an empty tag (`{%  %}`).

    In some cases, though, these triggers won’t work. (If `=` or `-` is adjacent to other punctuation, Pulsar wants to use the whole span of punctuation as the trigger.) So these snippet are also bound to commands: `language-liquid-redux:insert-output-directive` and `language-liquid-redux:insert-other-directive`.

    On macOS, these commands are bound to <kbd>Cmd-Ctrl-L</kbd> and <kbd>Cmd-Ctrl-;</kbd>, respectively. On Windows/Linux they’re bound to <kbd>Alt-Shift-L</kbd> and <kbd>Alt-Shift-;</kbd>.
