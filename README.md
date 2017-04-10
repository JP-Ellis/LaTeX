# LaTeX

This repository contains an assortment of LaTeX code which I use or have used.
Although I try and keep everything documented, some of it is only documented
within the code while some other parts have a more fully fledged documentation.

A brief summary of each file contained here is listed below.

## `.latexmkrc`

LaTeX usually requires multiple compilation runs before the final output is
ready.  This is further exacerbated if the main document has an index, a
bibliography, a glossary, ... as they require additional programs to be run.

Fortunately, there are several tools out there which automate the compilation of
a LaTeX file, on of them is [`latexmk`](http://ctan.org/pkg/latexmk).  The
`.latexmkrc` file included is configured to use LuaLaTeX and has support for
PGF/Ti*k*Z' `external` library.

In order to the `.latexmkrc` file, simply copy it into the root directory of
your LaTeX file and call

```
latexmk filename
```

## `thesis.cls`

The file `thesis.cls` is a class dedicated for theses.  It was created while I
was writing my masters.  The corresponding file `thesis.tex` documents all the
options provided by the class file in the same format as a thesis.

## `report.tex`

Provides a template for reports and demonstrates a few important
features of LaTeX.

## `jpellis.sty`

This style file contains an assortment of commands which I find useful.  It can
be used by called `\usepackage{jpellis}` provided that `jpellis.sty` is in the
same directory as the (master) `.tex` file.

The package is not (yet) documented, though the source code should have enough
information.

## `pgfplots.default.tex`

Although most of the default settings
for [PGFPlots](http://ctan.org/pkg/pgfplots) are quite good, there are some
further customization which I like.
