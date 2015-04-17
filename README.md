# my-LaTeX

**my-LaTeX** contains a set of files and configuration with
(pdf)LaTeX that I very commonly use.  You are welcome to have a look
at them and use them.

The collection of code has grown quite organically along with my
needs, most of it is written by me though some parts were originally
sourced online.


## report.tex

Provides a template for reports and demonstrates a few important
features of LaTeX.  It also uses glossaries and a biblatex and thus
external programs are required to properly compile this document
(though this is all managed by [latexmk][latexmk]).


## presentation.tex

Just as with `report.tex`, this provides a simple template for my
Beamer presentations and demonstrates a (very) few of the core
features of Beamer.


## jpellis.sty

This is my own LaTeX package which is used in a document by calling
`\usepackage{jpellis}`.  It mostly contains a large number of
useful commands, especially useful in physics.  I have not yet created
any formal documentation as to what `customizations` has to offer,
though the source code should have enough documentation.


## pgfplots.tex

[PGFPlots][pgfplots] is a LaTeX package that builds on
[PGF/TikZ][pgf/tikz] and allows you to draw graphs in LaTeX.  It can
plot functions as well as data points from a file in both 2D and 3D in
a variety of formats.

The PGFPlots documentation is quite thorough and I recommend you have
a good read there first, however I have sometimes found myself wanting
to extend the capabilities a little bit further.  This file contains a
compilation of tricks I have discovered.

Depending on the size of the graph, PGFPlots can take a long time to
execute and may use more resources than is typically available to
(pdf)LaTeX.  For this reason, I use a feature from PGF that allows
PGF/TikZ graphics to be generated outside of the (pdf)LaTeX and the
subsequent PDF is then imported.  Doing this allows for other LaTeX
compilers to be used so that memory limitations are circumvented (such
as with XeLaTeX) and the graphic is only regenerated when the data has
changed.


## .latexmkrc

(pdf)LaTeX usually requires multiple runs get all the
cross-referencing correct.  Additionally, using the
[Glossaries][glossaries] package and the externalization feature from
[PGF/Tikz][pgf/tikz] requires additional programs to be called.
[LaTeXmk][latexmk] is a package that provides a wrapper for (pdf)LaTeX
which will automatically take care of doing to appropriate number of
reruns, and call the appropriate external packages in order to
completely compile (pdf)LaTeX.


[pgfplots]: http://www.ctan.org/pkg/pgfplots
[pgf/tikz]: http://www.ctan.org/pkg/pgf
[glossaries]: http://www.ctan.org/pkg/glossaries
[latexmk]: http://www.ctan.org/pkg/latexmk
