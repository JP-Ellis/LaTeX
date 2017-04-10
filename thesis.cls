%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Thesis Class
%% Copyright (C) 2017  Joshua Ellis
%%
%%
%% This code is free software: you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation, either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
%% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
%% details.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{thesis}
\NeedsTeXFormat{LaTeX2e}

% Options for draft or final
\DeclareOption{draft}{
  %% Mark error with a black box
  \setlength\overfullrule{5pt}
}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
% Inherit options of KOMA's memoir class
\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{scrreprt}
}
\ProcessOptions\relax
\LoadClass{scrreprt}

\RequirePackage{etex}
\RequirePackage{etoolbox}
\RequirePackage{ifluatex}

%% Page layout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{geometry}

\RequirePackage{ifdraft}

\ifdraft{
  \RequirePackage{lineno}
  \AtEndPreamble{
    %% Add line numbers to the draft
    \pagewiselinenumbers
    \modulolinenumbers[5]
    \linenumbers
  }
}{}

%% Font
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{microtype}

\ifluatex
  \RequirePackage{fontspec}
  \RequirePackage{realscripts}

  \setmainfont{EB Garamond}[
    Contextuals={Alternate},
    % Ligatures={Historic},
    Ligatures={Rare},
    Numbers=OldStyle,
    % CharacterVariant={1},    % historical s
    % CharacterVariant={3},    % historical j
    % CharacterVariant={6},    % guillemets
    % CharacterVariant={11},   % distinguish i and 1
    % CharacterVariant={21},   % a
    % CharacterVariant={27},   % g
    ItalicFeatures={
      CharacterVariant={4},  % &
      CharacterVariant={5:3},  % v
    },
  ]

  \setmonofont{Inconsolata-g}[
    Scale=MatchLowercase,
  ]

  %% Nice math with Garamond
  \usepackage[cmintegrals,varg]{newtxmath}
\fi

%% Colours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{xcolor}

%% We define a primary colour and a base gray value; all other colours are
%% derived from these later on.  Since the base `gray` and `primary` colours can
%% be redefined, the derived colours are only defined at the end of the
%% preamble.
\definecolor{gray}{RGB}{85, 89, 92}
\definecolor{primary}{RGB}{212, 52, 0}

\AtEndPreamble{
  \colorlet{gray-darkest}{black!60!gray}
  \colorlet{gray-darker}{black!30!gray}
  \colorlet{gray-dark}{black!20!gray}
  \colorlet{gray-light}{white!30!gray}
  \colorlet{gray-lighter}{white!60!gray}
  \colorlet{gray-lightest}{white!90!gray}

  \colorlet{primary-darkest}{black!60!primary}
  \colorlet{primary-darker}{black!40!primary}
  \colorlet{primary-dark}{black!20!primary}
  \colorlet{primary-light}{white!30!primary}
  \colorlet{primary-lighter}{white!60!primary}
  \colorlet{primary-lightest}{white!90!primary}
}

%% Utility Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Use pgfkeys to handle all the customization for this class
\RequirePackage{pgfkeys}

%% Add a new PGF keys handler for fonts and provide some sane default values.
\pgfkeysdef{/handlers/.is font}{
  \pgfkeys{
    \pgfkeyscurrentpath/.is family,
    \pgfkeyscurrentpath,
    size/.initial=1em,
    font/.initial=\normalfont,
    color/.initial=black,
    shape/.initial=\upshape,
    series/.initial=\mdseries,
  }
}
%% Function to load a font from a PGF key.
\def\thesisgetfont#1{%
  \pgfkeysvalueof{/thesis/#1/font}%
  \fontsize{\pgfkeysvalueof{/thesis/#1/size}}{1em}%
  \color{\pgfkeysvalueof{/thesis/#1/color}}%
  \pgfkeysvalueof{/thesis/#1/shape}%
  \pgfkeysvalueof{/thesis/#1/series}%
  \selectfont%
}
%% Function to load a font from a PGF key and apply it to some text
\def\thesisfont#1#2{{%
  \pgfkeysvalueof{/thesis/#1/font}%
  \fontsize{\pgfkeysvalueof{/thesis/#1/size}}{1em}%
  \color{\pgfkeysvalueof{/thesis/#1/color}}%
  \pgfkeysvalueof{/thesis/#1/shape}%
  \pgfkeysvalueof{/thesis/#1/series}%
  \selectfont%
  #2%
}}

%% Allows for thesis keys to be more easily obtained and set.
\def\thesisget#1{\pgfkeysvalueof{/thesis/#1}}
\def\thesisset{\pgfqkeys{/thesis}}

%% Use to execute conditional statements by checking empty string
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\newcommand{\thesis@ifempty}[3]{\ifthenelse{\isempty{#1}\OR\isundefined{#1}}{#2}{#3}}
\newcommand*{\thesis@unlessempty}[2]{\thesis@ifempty{#1}{}{#2}}

%% Different formatting for web and print.  Content for one of the other can be
%% specified with `\forprint` or `\forweb`
\providebool{print}
\providebool{web}
\ifbool{print}{
  \setbool{web}{false}
}{
  \setbool{web}{true}
}

\newcommand*{\forprint}[1]{\ifbool{print}{#1}{}}
\newcommand*{\forweb}[1]{\ifbool{print}{}{#1}}

%% Hyperlinks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{hyperref}

\AtEndPreamble{
  \ifbool{print}{
    \hypersetup{
      %% When `colorlinks` is true, all links will be coloured which looks nice in
      %% digital version of the document but not in print.  If the document is
      %% intended for printing, then `colorlinks` should set to false.
      colorlinks=false,
      linkbordercolor=primary-lighter,
      citebordercolor=primary-lighter,
      urlbordercolor=primary-lighter,
    }
  }{
    \hypersetup{
      %% When `colorlinks` is true, all links will be coloured which looks nice in
      %% digital version of the document but not in print.  If the document is
      %% intended for printing, then `colorlinks` should set to false.
      colorlinks=true,
      linkcolor=primary-darker,
      citecolor=primary-darker,
      filecolor=primary-darker,
      urlcolor=primary-darker,
    }
  }
}


%% Document Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set the author's first and last name.
%%
%% Unlike the usual `\author` command, this takes two arguments so that the
%% first and last names can be accessed separately.
\thesisset{
  author/.is family,
  author/first name/.store in=\@authorfirstname,
  author/last name/.store in=\@authorlastname,
}
\renewcommand*\author[2]{\thesisset{
    author/first name={#1},
    author/last name={#2},
  }}
\def\@author{\@authorfirstname~\@authorlastname}

%% Set the ORCID of the author.
\thesisset{author/orcid/.store in=\@orcid}
\newcommand*\orcid[1]{\thesisset{author/orcid={#1}}}

\thesisset{
  supervisors/.is family,
}
\newcounter{supervisorcount}
%% Just like the author, `\supervisor` takes two arguments so that the first and
%% last names can be accessed separately.
%%
%% The `\supervisor` command can be called multiple times if multiples
%% supervisors are to be specified.
\newcommand*\supervisor[2]{%
  \stepcounter{supervisorcount}
  \edef\@i{\arabic{supervisorcount}}
  \thesisset{
    supervisors/\@i/.is family,
    supervisors/\@i/first name/.initial={#1},
    supervisors/\@i/last name/.initial={#2},
  }
}

%% Set the logo
\def\@logo{}
\thesisset{logo/.store in=\@logo}
\newcommand*\logo[1]{\thesisset{logo={#1}}}

%% Set the degree title
\def\@degreetitle{}
\thesisset{degree title/.store in=\@degreetitle}
\newcommand*\degreetitle[1]{\thesisset{degree title={#1}}}

%% Set the University name
\def\@university{}
\thesisset{university/.store in=\@university}
\newcommand\university[1]{\thesisset{university={#1}}}

%% Set the University department
\def\@department{}
\thesisset{department/.store in=\@department}
\newcommand\department[1]{\thesisset{department={#1}}}

%% Set the subject in the PDF metadata
\def\@subject{}
\thesisset{subject/.store in=\@subject}
\renewcommand*\subject[1]{\thesisset{subject={#1}}}

%% Set the keywords in the PDF metadata
\def\@keywords{}
\thesisset{keywords/.store in=\@keywords}
\newcommand*\keywords[1]{\thesisset{keywords={#1}}}

%% Adjust the PDF metadata.
\AtBeginDocument{
  \hypersetup{
    pdftitle={\@title},
    pdfauthor={\@author},
    pdfsubject={\@subject},
    pdfkeywords={\@keywords},
  }
}

%% Thesis elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Body
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlength{\parindent}{1em}
\setlength{\parskip}{0.2\baselineskip}

%% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\thesisset{
  title/.is family,
  title/university/.is family,
  title/university/name/.is font,
  title/university/department/.is font,
  title/title/.is font,
  title/subtitle/.is font,
  title/author/.is family,
  title/author/description/.is font,
  title/author/first name/.is font,
  title/author/last name/.is font,
  title/author/orcid/.is font,
  title/supervisor/.is family,
  title/supervisor/description/.is font,
  title/supervisor/first name/.is font,
  title/supervisor/last name/.is font,
  title/degree/.is family,
  title/degree/description/.is font,
  title/degree/name/.is font,
  title/date/.is font,
}

\thesisset{
  title/university/name,
  size=22pt,
  color=primary,
}
\thesisset{
  title/university/department,
  size=18pt,
  color=primary,
}

\thesisset{
  title/title,
  size=28pt,
}
\thesisset{
  title/subtitle,
  size=22pt,
}

\thesisset{
  title/author/description,
  shape=\itshape,
}
\thesisset{
  title/author/first name,
  size=12pt,
}
\thesisset{
  title/author/last name,
  shape=\scshape,
  size=12pt,
}
\thesisset{
  title/author/orcid,
  size=8pt,
  % shape=\ttfamily,
}

\thesisset{
  title/supervisor/description,
  shape=\itshape,
}
\thesisset{
  title/supervisor/first name,
  size=12pt,
}
\thesisset{
  title/supervisor/last name,
  shape=\scshape,
  size=12pt,
}

\thesisset{
  title/degree/description,
  shape=\itshape,
}
\thesisset{
  title/degree/name,
  size=12pt,
}

\thesisset{
  title/date,
  size=12pt,
}

\thesisset{
  title,
  %% Skips provide a vertical spacing, usually after the element in question.
  %% Separator provides a vertical demarcation.
  logo/.initial={\includegraphics[width=4cm]{example-image-a}},
  logo/skip/.initial=2em,
  university/name/skip/.initial=1em,
  university/department/skip/.initial=5em,
  %% The title skip occurs after the title/subtitle combination
  title/skip/.initial=5em,
  %% The subtitle skip is the skip between the title and the subtitle (unlike
  %% most other skips)
  subtitle/skip/.initial=0.5em,
  author/description/text/.initial={By},
  author/description/skip/.initial=0.2em,
  author/separator/.initial=\space,
  author/orcid/skip/.initial=-0.2em,
  author/skip/.initial=3em,
  supervisor/description/text/.initial={Under the supervision of},
  supervisor/description/skip/.initial=0.2em,
  supervisor/separator/.initial=\space,
  supervisor/skip/.initial=3em,
  supervisor/inter skip/.initial=0pt,
  degree/description/text/.initial={Submitted in the fulfillment of},
  degree/description/skip/.initial=0.2em,
  degree/skip/.initial=0em plus 1 fill,
}

\RequirePackage[UKenglish]{isodate}

\newcommand*\thesis@maketitle{%
  \begin{titlepage}%
    \centering%
    % Logo
    \thesis@unlessempty{\@logo}{%
      \@logo%
      \vskip\thesisget{title/logo/skip}%
    }%
    % University name and/or department can be empty if logo includes them
    \thesis@unlessempty{\@university}{%
      {\thesisgetfont{title/university/name} \@university}%
      \vskip\thesisget{title/university/name/skip}%
    }%
    \thesis@unlessempty{\@department}{%
      {\thesisgetfont{title/university/department} \@department}%
      \vskip\thesisget{title/university/department/skip}%
    }%
    % Title and subtitle
    {\thesisgetfont{title/title} \@title}%
    \thesis@unlessempty{\@subtitle}{%
      \vskip\thesisget{title/subtitle/skip}%
      {\thesisgetfont{title/subtitle} \@subtitle}%
    }%
    \vskip\thesisget{title/title/skip}%
    % Author
    {\thesisgetfont{title/author/description} \thesisget{title/author/description/text}}%
    \vskip\thesisget{title/author/description/skip}%
    {\thesisgetfont{title/author/first name} \@authorfirstname}%
    \thesisget{title/author/separator}%
    {\thesisgetfont{title/author/last name} \@authorlastname}%
    \thesis@unlessempty{\@orcid}{%
      \vskip\thesisget{title/author/orcid/skip}%
      {\thesisgetfont{title/author/orcid} \@orcid}%
    }%
    \vskip\thesisget{title/author/skip}%
    % Supervisor
    {\thesisgetfont{title/supervisor/description} \thesisget{title/supervisor/description/text}}%
    \vskip\thesisget{title/supervisor/description/skip}%
    % \foreach \i in \@supervisorindices {%
    \foreach \i in {1, ..., \arabic{supervisorcount}} {%
      \makebox[0pt][r]{\thesisgetfont{title/supervisor/first name} \thesisget{supervisors/\i/first name}}%
      \thesisget{title/supervisor/separator}%
      \makebox[0pt][l]{\thesisgetfont{title/supervisor/last name} \thesisget{supervisors/\i/last name}}%
      \vskip\thesisget{title/supervisor/inter skip}%
    }%
    \vskip-\thesisget{title/supervisor/inter skip}%
    \vskip\thesisget{title/supervisor/skip}
    % Degree
    {\thesisgetfont{title/degree/description} \thesisget{title/degree/description/text}}%
    \vskip\thesisget{title/degree/description/skip}%
    {\thesisgetfont{title/degree/name} \@degreetitle}%
    \vskip\thesisget{title/degree/skip}
    % Date
    {\thesisgetfont{title/date} \today}%
  \end{titlepage}
}

\renewcommand*\maketitle{\thesis@maketitle}

%% Sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setkomafont{part}{\normalfont\scshape\Huge}
\setkomafont{partnumber}{\normalfont\scshape\huge}

\setkomafont{chapter}{\normalfont\scshape\Huge}
\setkomafont{section}{\normalfont\huge}
\setkomafont{subsection}{\normalfont\itshape\Large}
\setkomafont{subsubsection}{\normalfont\itshape\large}
\setkomafont{paragraph}{\normalfont\scshape}

\setkomafont{chapterentry}{\normalfont\scshape\large}

%% Although titlesec isn't ideal with KOMA-Script, it is useful here to adjust
%% the chapter headings.
\RequirePackage{titlesec}
%% \titleformat takes the following form:
% \titleformat{\chapter}[display] % Shape
%   {} % Format
%   {} % Label
%   {} % Sep
%   {} % Before
%   [] % After
\titleformat{\chapter}[display]
  { \normalsize \huge \color{black}}
  { %
    {\chaptertitlename} %
    {\fontsize{60}{60}\color{primary}\selectfont\thechapter} %
  }
  {0pt} %
  {\normalfont\scshape\Huge} %
  [] %

%% Table of Content
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Adjust the table of content to use a \section heading instead of a full
%% chapter.
\let\thesis@tableofcontents\tableofcontents
\renewcommand*\tableofcontents{%
  \let\thesis@chapter\chapter%
  \let\chapter\section%
  \thesis@tableofcontents%
  \let\chapter\thesis@chapter%
}

%% Lettrine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{lettrine}

\newif\ifthesis@useornament
\thesisset{
  lettrine/.is family,
  lettrine/ornament/.is if=thesis@useornament,
}

\newcommand\thesislettrine[2]{%
  \lettrine{%
    \ifthesis@useornament%
      % Background of the lettrine
      \textcolor{primary}{\lettrinebg #1}%
      % If the background and letter don't perfectly line up, adjust here.
      \kern0.2pt%
      % Letter itself
      \llap{\lettrinefg #1}%
    \else%
      \textcolor{primary}{\lettrinefg #1}%
    \fi%
  }{%
    % Remaining text in small caps
    #2%
  }
}

\ifluatex
  \thesisset{
    lettrine/ornament=true,
  }
  %% Add lettrine with EB Garamond
  \newfontface\lettrinebg{EB Garamond Initials Fill1}
  \newfontface\lettrinefg{EB Garamond Initials Fill2}

  \setcounter{DefaultLines}{3}
  \renewcommand{\DefaultLoversize}{-.15}
  \renewcommand{\DefaultLraise}{.23}
  \setlength{\DefaultNindent}{0.5ex}

\else
  \thesisset{
    lettrine/ornament=false,
  }

  %% Add lettrine with EB Garamond
  \let\lettrinefg=\relax
  \let\lettrinebg=\relax

  \setcounter{DefaultLines}{3}
  \newcommand\thesislettrine[2]{\lettrine{\textcolor{primary}{#1}}{#2}}
\fi

\endinput

% Local Variables:
% TeX-master: "thesis.tex"
% End: