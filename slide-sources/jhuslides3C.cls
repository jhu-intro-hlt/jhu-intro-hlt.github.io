%%
%%    File : infslides.cls    (LaTeX2e class file)
%%  Author : Mary Ellen Foster (mef@cogsci.ed.ac.uk)
%%           based on csslides by Martin Reddy (mxr@dcs.ed.ac.uk) 
%% Version : 2.0
%% Updates : 1.0 [13/6/95] - initial release.
%%           1.1 [17/7/96] - more colour options, squeeze option
%%           1.2 [9/1/97]  - short=squeeze, centre page, fixed rotate bug,
%%                           sectioning commands, notes, \foiltitleskip
%%           1.2.1 [15/1/97] - if no title given, space was left at top
%%           2.0 [7/28/2000] Changed from csslides to infslides
%%                         - Fixed the "environment" version
%%           2.1 [11/28/2000] - Final fix-ups to put into dist
%%           2.1.1 [13/2/2001] - Removed bug to do with pdflatex and
%%                               landscape
%% 
%% This file contains a class definition, infslides, for the LaTeX2e
%% system which defines the layout of presentation slides used by 
%% Division of Informatics at the University of Edinburgh.
%%
%% For information on this class, please refer to "texdoc infslides"
%%
%% To Do List:
%%    sectioning commands don't display section nos. - sort this sometime
%%
%% Notes:
%%   A number of hacks had to be performed in order to get FoilTeX
%%   working in the desired fashion:
%%
%%    1) create \cal and \mit commands, otherwise FoilTeX complains
%%    2) explicity call \foil@rot@start when using \rotatefoilhead
%%

\NeedsTeXFormat{LaTeX2e}[1994/12/01]
\ProvidesClass{infslides}[2000/11/28 v2.1.1 Informatics Presentation Slides Class - MEF]

%%
%% --- Initial Code ---
%%

\RequirePackage{ifthen}

\newboolean{perpetuafont}
\setboolean{perpetuafont}{false}
\newboolean{landscapemode}
\setboolean{landscapemode}{false}
\newboolean{raggedrightmode}
\setboolean{raggedrightmode}{false}
\newboolean{colouroption}
\setboolean{colouroption}{true}
\newboolean{squeezeoption}
\setboolean{squeezeoption}{false}
\newboolean{centreoption}
\setboolean{centreoption}{false}
\newboolean{slidesonly}
\setboolean{slidesonly}{false}
\newboolean{notesonly}
\setboolean{notesonly}{false}

%%
%% --- Options ---
%%

\DeclareOption{landscape}{\setboolean{landscapemode}{true}%
                          \PassOptionsToClass{\CurrentOption}{foils}}
\DeclareOption{17pt}{\PassOptionsToClass{\CurrentOption}{foils}}
\DeclareOption{20pt}{\PassOptionsToClass{\CurrentOption}{foils}}
\DeclareOption{25pt}{\PassOptionsToClass{\CurrentOption}{foils}}
\DeclareOption{30pt}{\PassOptionsToClass{\CurrentOption}{foils}}

\DeclareOption{perpetua}{\setboolean{perpetuafont}{true}}

\DeclareOption{colour}{\setboolean{colouroption}{true}}

\DeclareOption{centre}{\setboolean{centreoption}{true}}
\DeclareOption{center}{\setboolean{centreoption}{true}}

\DeclareOption{leftjust}{\setboolean{raggedrightmode}{true}}

\DeclareOption{squeeze}{\setboolean{squeezeoption}{true}}
\DeclareOption{short}{\setboolean{squeezeoption}{true}}

\DeclareOption{slidesonly}{\setboolean{slidesonly}{true}}
\DeclareOption{notesonly}{\setboolean{notesonly}{true}}

\ExecuteOptions{20pt}
\ProcessOptions

%%
%% --- Class Loading (built ontop of foilTeX V2.0.1) ---
%%

\providecommand{\cal}{} % hack to make foilTeX (V2.0) work properly
\providecommand{\mit}{}

\LoadClass[a4paper,dvips]{foils}

%%
%% --- Main Code ---
%%

%% NOTE: For reasons entirely beyond my comprehension, you can't load the
%% graphics package until *after* loading the foils class. Lord knows why.
%% MEF 13/2/2001.
\RequirePackage{graphics}
\ifthenelse{\boolean{colouroption}}{\RequirePackage{color}}{}

%%
%% Set Perpetua font in the header/footer if requested
%%

\newcommand{\csslide@font}{}

\ifthenelse{\boolean{perpetuafont}}
  {\RequirePackage{perpetua}
   \renewcommand{\csslide@font}{\rmfamily}}
  {}

%%
%% Set up the paragraph spacing...
%%

\parindent=0in
\parskip=1ex
\ifthenelse{\boolean{raggedrightmode}}{\raggedright}{}
\setlength\foilheadskip{-2cm}

\ifthenelse{\boolean{squeezeoption}}%
  {\ifthenelse{\boolean{landscapemode}}
    {\addtolength{\hoffset}{0.5cm}\addtolength{\textwidth}{-3cm}}
    {\addtolength{\voffset}{1.5cm}\addtolength{\textheight}{-3cm}}}
  {}

\addtolength{\hoffset}{-1cm}
\addtolength{\voffset}{-1cm}
\addtolength{\textwidth}{2cm}
\addtolength{\textheight}{2.5cm}

%%
%% Extend the author, title and date commands to include an optional
%% parameter. This is used for the footer:
%%
%%    \title[short]{Full title}
%%    \author[short]{Full authors}
%%    \date[short]{date}
%%    \maketitle
%%

\renewcommand{\@author}{No Author}
\renewcommand{\@title}{No Title}
\renewcommand{\@date}{\today}
\newcommand{\short@author}{\@author}
\newcommand{\short@title}{\@title}
\newcommand{\short@date}{\@date}
\newcommand{\extra@info}{}

\renewcommand{\author}[2][]{
   \renewcommand{\@author}{#2}
   \ifthenelse{\equal{#1}{}}
     {\renewcommand{\short@author}{#2}}
     {\renewcommand{\short@author}{#1}}
}

\renewcommand{\title}[2][]{
   \renewcommand{\@title}{#2}
   \ifthenelse{\equal{#1}{}}
     {\renewcommand{\short@title}{#2}}
     {\renewcommand{\short@title}{#1}}
}

\renewcommand{\date}[2][]{
   \renewcommand{\@date}{#2}
   \ifthenelse{\equal{#1}{}}
     {\renewcommand{\short@date}{#2}}
     {\renewcommand{\short@date}{#1}}
}

%%
%% Setup default colours and the colour interface
%%

\newcommand{\bar@colour}{darkgrey}
\newcommand{\title@colour}{darkblue}
\newcommand{\info@colour}{darkgrey}
\newcommand{\text@colour}{black}

\newcommand{\setbarcolour}[1]{\renewcommand{\bar@colour}{#1}}
\newcommand{\settitlecolour}[1]{\renewcommand{\title@colour}{#1}}
\newcommand{\setinfocolour}[1]{\renewcommand{\info@colour}{#1}}
\newcommand{\settextcolour}[1]{\renewcommand{\text@colour}{#1}}

\newcommand{\setcolour}[1]{\ifthenelse{\boolean{colouroption}}{\color{#1}}{}}
\newcommand{\newcolour}[2]{\ifthenelse{\boolean{colouroption}}%
  {\definecolor{#1}{rgb}{#2}}{}}

%%
%% Let the user modify the footer easily
%% (N.B. \rightfooter is a \renew... because foilTeX declares it)
%%

\newcommand{\leftfooter}[1]{\renewcommand{\short@author}{#1}}
\newcommand{\middlefooter}[1]{\renewcommand{\short@title}{#1}}
\renewcommand{\rightfooter}[1]{\renewcommand{\short@date}{#1}}

%%
%% Use the foilTeX macros for setting up the spacing on the title page
%%

\ifthenelse{\boolean{landscapemode}}
  {\abovetitleskip=-1.2in}
  {\abovetitleskip=1.2in}

\newcommand{\shrinklist}{\zerolistvertdimens}

%%
%% Add section commands as these aren't available by default
%%

\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]

\renewcommand\thesection{\@arabic\c@section}
\renewcommand\thesubsection{\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection .\@arabic\c@subsubsection}
\renewcommand\theparagraph{\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph{\theparagraph.\@arabic\c@subparagraph}

\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\Large\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\large\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}

%%
%% Setup the colour of the EU crest...
%%
%% The macro \shieldtype{num} selects the crest version: (from eushield.sty):
%%   0  -  normal monochrome
%%   1  -  no lines
%%   2  -  reversed
%%   3  -  2 colour
%%   4  -  full colour
%%
%% Note that we aren't actually using the crest any more because we've moved
%% to the Informatics "i" instead. But I'll leave this in here for posterity.
%
% 13 Feb 2001 -- I've now commented out these lines and the loading of the
% eushield package. No need. It did reveal a bug, though.

% \ifthenelse{\boolean{colouroption}}
%   {\shieldtype{4}}
%   {\shieldtype{0}}

%%
%% Set up the headers and footers for the document. This is based
%% heavily upon AJCD's original LaTeX209 csslides.sty style.
%% We create 2 custom header/footer arrangements:
%%
%%   headings     : non-rotated main slide header/footer
%%   foilheadings : title slide header/footer (overrides FoilTeX def)
%%

\def\ps@headings{\let\@mkboth\markboth
 \def\@oddfoot{\vbox{\setcolour{\bar@colour}\hrule \@depth1pt \vskip1.5pt
                     \setcolour{\info@colour}\hbox 
                     to\textwidth{\footnotesize\csslide@font
                       \rlap{\short@author}%
                       \hfill\short@title \hfill\llap{\short@date}}}}%
 \def\@oddhead{\@tempdima=\textwidth \advance\@tempdima-20mm
               \vbox{\vskip1.5pt \setcolour{\info@colour}
                     \hbox to\@tempdima{\footnotesize\csslide@font
                                        \extra@info\hfill\thepage}}%
               \vbox to\z@{\vss\hbox to5mm{
                  \resizebox{15mm}{!}{\includegraphics[scale=8]{jhu}}\hss}\vss
                  \vskip\headheight}}%
 \def\@evenfoot{\@oddfoot}%
 \def\@evenhead{\@oddhead}}

% ps@foilheadings: only used on the \maketitle slide
\def\ps@foilheadings{\let\@mkboth\markboth
 \def\@oddfoot{\vbox{\setcolour{\bar@colour}\hrule \@depth1pt \vskip1.5pt
     \setcolour{\info@colour}\hbox to\textwidth{\footnotesize\csslide@font
                        \rlap{\short@author}%
                        \hfill\short@title \hfill\llap{\short@date}}}}%
 \def\@oddhead{\vbox{\setcolour{\bar@colour}\hrule \@depth3pt
                \@width\textwidth}}
 \def\@evenfoot{\@oddfoot}
 \def\@evenhead{\@oddhead}}

\pagestyle{headings}

%%
%% The commands which are used to invoke a new slide:
%%
%%   \slide[extrainfo]{heading}
%%   \sliderotated[extrainfo]{heading}
%%

\newcommand{\@slidename}{} % current slide name, filled by \@slideheader
\newlength{\foiltitleskip}
\setlength{\foiltitleskip}{0pt}

\newcommand{\@slideheader}[1]{%
  \global\long\def\@slidename{#1}%
  \ifthenelse{\boolean{centreoption}}{\vfil}{}%
  \ifthenelse{\equal{#1}{}}{}{%
    \begin{center}%
      \setcolour{\title@colour}{\Large\bfseries #1}
    \end{center}%
    \vskip \foiltitleskip%
  }%
  \setcolour{\text@colour}%
}

\newcommand{\slide}[2][]{
  \newpage%
  \global\long\def\extra@info{#1}%
  \thispagestyle{headings}%
  \foilhead{}
  \@slideheader{#2}
}

\newcommand{\sliderotated}[2][]{
  \newpage%
  \global\long\def\extra@info{#1}%
  \thispagestyle{headings}%
  \rotatefoilhead{}
  \@slideheader{#2}
}

%% Definitions so that the environment form of the commands will also work
%% correctly... thanks to Robin Fairbairns <rf@pallas.cl.cam.ac.uk> for
%% explaining the issue to me and suggesting this fix! (Before this, it was
%% the next \[rotate]foilhead that was causing the page to be shipped out,
%% with inappropriate dimensions.)
\def\endslide{\vfill\eject}
\def\endsliderotated{\vfill\eject}

%%
%% Implement notes for each slide
%%

\newcommand{\notes}[1][]{%
  \newpage
  \thispagestyle{empty}
  \addtocounter{page}{-1}
  \ifthenelse{\boolean{notesonly}}{\addtocounter{page}{+1}}{}
  \vspace*{-1in}\begin{center}
    \ifthenelse{\value{page} = 0}{%
      \underbar{\large\bfseries Title Slide}%
    }{%
      \underbar{\large\bfseries Slide \thepage%
        \ifthenelse{\equal{#1}{}}
          {\ifthenelse{\equal{\@slidename}{}}{}{: \@slidename}}%
          {: #1}%
      }%
    }
  \end{center}
}

%%
%% The follow section provides the routines for the selective ignoring
%% of various segments of TeX code. This code segment is copied from
%% Victor Eijkhout's "comment.sty" LaTeX209 style (v2.0, 19 Jun 1992).
%%

\def\makeinnocent#1{\catcode`#1=12 }
\def\csarg#1#2{\expandafter#1\csname#2\endcsname}

\def\ThrowAwayComment#1{\begingroup
    \def\CurrentComment{#1}%
    \let\do\makeinnocent \dospecials
    \makeinnocent\^^L% and whatever other special cases
    \endlinechar`\^^M \catcode`\^^M=12 \xComment}
{\catcode`\^^M=12 \endlinechar=-1 %
 \gdef\xComment#1^^M{\def\test{#1}
      \csarg\ifx{PlainEnd\CurrentComment Test}\test
          \let\next\endgroup
      \else \csarg\ifx{LaLaEnd\CurrentComment Test}\test
            \edef\next{\endgroup\noexpand\end{\CurrentComment}}
      \else \let\next\xComment
      \fi \fi \next}
}

\def\includecomment
 #1{\expandafter\def\csname#1\endcsname{}%
    \expandafter\def\csname end#1\endcsname{}}
\def\excludecomment
 #1{\expandafter\def\csname#1\endcsname{\ThrowAwayComment{#1}}%
    {\escapechar=-1\relax
     \csarg\xdef{PlainEnd#1Test}{\string\\end#1}%
     \csarg\xdef{LaLaEnd#1Test}{\string\\end\string\{#1\string\}}%
    }}

%%
%% End of section from "comment.sty"
%%

%%
%% Implement selective printing of notes and/or slides
%%

\ifthenelse{\boolean{slidesonly}}%
  {\excludecomment{notes}}%
  {}

\ifthenelse{\boolean{notesonly}}%
  {\excludecomment{slide}%
   \excludecomment{sliderotated}%
   \renewcommand{\maketitle}{}}%
  {}


%%
%% Redefine \@maketitle to include Informatics logo
%%

\def\@maketitle{\newpage
  \zerolistvertdimens
  \if@compatibility\else
    \advance\abovetitleskip -\baselineskip % \null adds this space
  \fi
  \null\vskip\abovetitleskip
  \begin{center}
     {\Large\bfseries \@title \par}
     \vskip\titleauthorskip
     {\lineskip \authorauthorskip
       \begin{tabular}[t]{c}\@author\end{tabular}
       \par}
     \vskip\authordateskip {\@date} \\
     \vfill\resizebox{7cm}{!}{\includegraphics[scale=8]{jhu}}\\\bigskip
  \end{center}
  \par\vfil
}


%%
%% EOF: csslides.cls
%%
