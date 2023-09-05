// Establish Phoenix Socket and LiveView configuration.
import Reveal from "../vendor/reveal.js/reveal.esm.js"
import Markdown from "../vendor/reveal.js/plugin/markdown/markdown.esm.js"
import Notes from "../vendor/reveal.js/plugin/notes/notes.esm.js"
import Highlight from "../vendor/reveal.js/plugin/highlight/highlight.esm.js"

import "../vendor/reveal.js/reveal.css"
import "../vendor/reveal.js/rbino.css"
import "../vendor/reveal.js/plugin/highlight/gruvbox-dark-medium.css"

let deck = new Reveal({
	hash: true,

	// Learn about plugins: https://revealjs.com/plugins/
	plugins: [ Markdown, Highlight, Notes ],

  // Disable the layout, let us do the styling
  disableLayout: true
});
deck.initialize();
