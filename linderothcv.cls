% vim: ft=tex
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{linderothcv}[2020/09/24 Linderoth CV]

\RequirePackage{xkeyval}
\RequirePackage{etoolbox}
\LoadClass[10pt]{article}


\RequirePackage[nostruts]{titlesec}
\RequirePackage{fontawesome}
\RequirePackage[a4paper, top=10mm, bottom=10mm, left=10mm, right=10mm, includehead]{geometry}
\RequirePackage{calc}
\RequirePackage{hyperref}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\RequirePackage{fancyhdr}
\RequirePackage[english]{isodate}
\isodate


%
% Variable declarations & defaults
%

% Width of left minipage column, override to your preference,
% e.g. ``0.33\textwidth''
\newlength{\LCVleftcolwidth}
\setlength{\LCVleftcolwidth}{0.33\textwidth}
\define@key{linderothcv}{leftcolwidth}[0.33\textwidth]{\setlength{\LCVleftcolwidth}{#1}}

% Width of spacing between minipage columns, override to your preference,
% e.g. ``5mm''
\newlength{\LCVcolspacing}
\setlength{\LCVcolspacing}{5mm}
\define@key{linderothcv}{colspacing}[5mm]{\setlength{\LCVcolspacing}{#1}}

% Width of right minipage column, defaults to fill rest of page width
\newlength{\LCVrightcolwidth}
\setlength{\LCVrightcolwidth}{\textwidth - \LCVcolspacing - \LCVleftcolwidth}

% This is the arbitrary (negative) size of a vspace at the top of the column
% minipages. Its purpose is to remove vertical margin added by the minipage
% environments that I haven't found another way to remove.
\newlength{\LCVminipagevspace}
\setlength{\LCVminipagevspace}{-5mm}
\define@key{linderothcv}{minipagevspace}[-5mm]{\setlength{\LCVminipagevspace}{#1}}

% Section header spacing, before and after
\newlength{\LCVsectionprespace}
\setlength{\LCVsectionprespace}{1ex}
\define@key{linderothcv}{sectionprespace}[1ex]{\setlength{\LCVsectionprespace}{#1}}

\newlength{\LCVsectionpostspace}
\setlength{\LCVsectionpostspace}{0.2ex}
\define@key{linderothcv}{sectionpostspace}[0.2ex]{\setlength{\LCVsectionpostspace}{#1}}

% Paragraph indentation / skip
\newlength{\LCVparskip}
\setlength{\LCVparskip}{1ex}
\define@key{linderothcv}{skip}[1ex]{\setlength{\LCVparskip}{#1}}
\setlength{\parskip}{\LCVparskip}

\newlength{\LCVparindent}
\setlength{\LCVparindent}{0em}
\define@key{linderothcv}{indent}[0em]{\setlength{\LCVparindent}{#1}}
\setlength{\parindent}{\LCVparindent}

\ProcessOptionsX<linderothcv>

% Temp variables
\newlength{\LCVtmp}


%
% Fonts & Colour
%

\definecolor{heading}{rgb}{0.23, 0.27, 0.29} % ``Arsenic''
\definecolor{skillbar}{rgb}{0.23, 0.27, 0.29} % ``Arsenic''
\definecolor{links}{rgb}{0, 0, 0}
\definecolor{watermark}{rgb}{0.75, 0.75, 0.75}

\setsansfont[Numbers=Lining]{Raleway-Light}
\setmainfont[Numbers=OldStyle]{TeX Gyre Pagella}

\hypersetup{colorlinks=true, urlcolor=links}


%
% Header & Footer
%

\define@cmdkey[lcv]{header}{name}{}

\newenvironment{lcvheader}[1][]{
    \setkeys[lcv]{header}{#1}%
    \hypersetup{pdfauthor = {\cmdlcv@header@name}, pdftitle = {\cmdlcv@header@name - CV}}%
    \centerline{%
        \sffamily%
        \color{heading}%
        \fontsize{40pt}{40pt}\selectfont%
        {\cmdlcv@header@name}%
    }
    \vspace{1ex}%
}{%
    \setlength{\LCVtmp}{1.5ex-\LCVparskip}%
    \vspace{\LCVtmp}%
}%


\newcommand{\lcvlastupdated}{%
    \fontspec{Raleway-ExtraLight}\fontsize{8pt}{10pt}\selectfont\color{watermark}Updated \today%
}

% Clear header spacing to make spacing around \lcvheader more intuitive
\setlength{\headheight}{0mm}
\setlength{\headsep}{0mm}
\setlength{\voffset}{0mm}

% Clear header/footer and write last updated
\pagestyle{fancy}
\fancyhf{}
\rfoot{\lcvlastupdated}
\renewcommand{\headrulewidth}{0pt}


%
% Sections & Content macros
%

\titleformat{\section}
  {\sffamily\Large\scshape\raggedright}
  {}{0mm}
  {}
  []

\titlespacing*{\section}{0mm}{\LCVsectionprespace}{\LCVsectionpostspace}

\titleformat{\subsection}
  {\sffamily\large\scshape\raggedright}
  {}{0mm}
  {}

\titlespacing*{\subsection}{0mm}{\LCVsectionprespace}{\LCVsectionpostspace}


%% Main job item macro \lcvjob

\define@key{cvitem}{company}{\def\LCVIcompany{#1}}
\define@key{cvitem}{from}{\def\LCVIfrom{#1}}
\define@key{cvitem}{to}{\def\LCVIto{#1}}
\define@key{cvitem}{position}{\def\LCVIposition{#1}}
\define@key{cvitem}{location}{\def\LCVIlocation{#1}}
\newcommand{\lcvjob}[1]{
    \setkeys{cvitem}{#1}
    \subsection[\LCVIposition]{%
        \LCVIposition\\[0ex]%
        \LCVIcompany%
        \hspace{2em}\ifdefvoid\LCVIlocation{}{\normalsize\faMapMarker~\LCVIlocation}%
        \hfill%
        {\normalsize\LCVIfrom\ifdefvoid\LCVIto{}{--\LCVIto}}%
    }%
    \def\LCVIcompany{}
    \def\LCVIfrom{}
    \def\LCVIto{}
    \def\LCVIposition{}
    \def\LCVIlocation{}
}


%% Buzzword list \lcvitemize

\define@cmdkey[lcv]{itemize}{columns}{}

\newlength{\LCVtmpparskipp}
\newenvironment{lcvitemize}[1][columns=3]{
    \setkeys[lcv]{itemize}{#1}%
    \setlength{\multicolsep}{1ex}
    \noindent
    \sffamily\small%
    \begin{multicols}{\cmdlcv@itemize@columns}
        \begin{itemize}[noitemsep, leftmargin=0mm, rightmargin=0mm, topsep=0mm, partopsep=0mm]
}{%
    \end{itemize}%
    \end{multicols}%
}%


%% Misc item \lcvmisc

\newcommand{\lcvmisc}[2]{%
    \subsection[#1]{%
        %{#1\hfill{\upshape\normalsize#2}}%
        {#1\hfill{\scshape\small#2}}%
    }%
}%


%% Horizontal Pair \lcvpair

\newcommand{\lcvpair}[2]{%
    \noindent%
    {\sffamily\scshape{\large #1} \hfill {\normalsize #2}}%
}%


%% Skill bar \lcvskillbar

\newcommand{\lcvskillbar}[2]{%
    \noindent
    {\sffamily\small#1} \\
    \begin{tikzpicture}%
        \draw[fill=white,skillbar](0,0) rectangle ({#2},0.3);
    \end{tikzpicture}
}


%
% Columns / minipages
%



\newenvironment{lcvleftcolumn}{%
    \noindent%
    \begin{minipage}[t]{\LCVleftcolwidth}%
    \setlength{\parskip}{\LCVparskip}%
    \setlength{\parindent}{\LCVparindent}%
    ~\vspace{\LCVminipagevspace}%
}{%
    \end{minipage}%
    \hfill%
}

\newenvironment{lcvrightcolumn}{%
    \noindent%
    \begin{minipage}[t]{\LCVrightcolwidth}%
    \setlength{\parskip}{\LCVparskip}%
    \setlength{\parindent}{\LCVparindent}%
    ~\vspace{\LCVminipagevspace}%
}{%
    \end{minipage}%
    \hfill%
}
