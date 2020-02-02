# The beauty of git
Short presentation about the concepts and internals of git, e.g. object types, trees, content-addressable etc.

To run the presentation, it has to be served from a web server, since the shell transcripts are loaded
from seperate files via the reveal-sampler plugin (using ajax calls).

## Setup of demo

The subdir `demo` contains a setup script `setup-demo.sh` that can be used to create the demo git
repositories `demo/repo` and `demo/repo2`, the shell fragments `demo/transcript*/*.shell` and
the the presentation images `demo/img*/*.png`.

## Dependencies

* revealjs (https://github.com/hakimel/reveal.js) with included highlight.js and notes plugins
* revealjs-plugin reveal-sampler (https://github.com/ldionne/reveal-sampler)
* revealjs-plugin revealjs-explicit-link (https://gitlab.com/xuhdev/revealjs-explicit-link)
* revealjs-plugin plugin-revealjs-mouse-pointer (https://github.com/caiofcm/plugin-revealjs-mouse-pointer)
* git-draw (https://github.com/sensorflo/git-draw/wiki)
