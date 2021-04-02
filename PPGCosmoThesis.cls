%%% PPGCosmoThesis document class v 1.0
% Implemented by Davi C. Rodrigues (davi.rodrigues@cosmo-ufes.org)
%
% Some features of this class use codes that were adapted from examples
% that can be freely found in tex.stackexchange.com. Some inspiration from
% University of Oslo latex template can also be found here.
% (https://www.overleaf.com/latex/templates/phduio-monograph/wvstjttnywvr)

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{PPGCosmoThesis}[2020/09/13 Class for PhD theses at PPGCosmo/UFES]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CLASS OPTIONS & LOADCLASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifapproved 
\newif\ifnoxparse

\DeclareOption{approved}{\approvedtrue} % generates a second page for the approved thesis.
\DeclareOption{noxparse}{\noxparsetrue} % does not load the xparse package.

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}
% If an option is given when calling PPGCosmoThesis, it will be passed
% to the class scrbook, from which PPGCosmoThesis is based.


\ProcessOptions
\relax

\LoadClass[
	fontsize=11pt,
	DIV=13,              % compact option for the margins.
	oneside,
	headings=big,
	chapterprefix=true. % writes "Chapter" in front of the chapter number.
	]
	{scrbook}
% scrbook is part of the KOMA script and it is an improved book format.
% A4paper is the standard paper size, no need to specify it.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PACKAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{amsmath,amssymb}
\usepackage[
	breaklinks,
	backref=page,         % Option to see where a ref. was cited.
	colorlinks=true,
	linkcolor=lightblue,
	citecolor=lightblue,
	urlcolor=YellowOrange!90!black
	]
	{hyperref}
\usepackage{graphicx}
\usepackage[dvipsnames]{xcolor}
\usepackage[automark,headsepline]{scrlayer-scrpage} % Sets the headings in each page within the Koma script.

\ifnoxparse \else \usepackage{xparse} \fi
% xparse is only used for the extended \eqref definition.
% If you do not use \eqref with multiple arguments, use the option noxparse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BACKREF TEXT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{%
    \ifcase #1 Not cited.%
    \or        Cited on page~#2.%
    \else      Cited on pages~#2.%
    \fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HEADER AND FOOTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Relevant for printing the page numbers in the desired position.
\addtokomafont{pagenumber}{\oldstylenums}
\clearpairofpagestyles

% Defines variable \Chaptername that yields the current chapter name.
\let\Chaptermark\chaptermark
\def\chaptermark#1{\def\Chaptername{#1}\Chaptermark{#1}}

% Defines variable \Sectionname that yields the current section name (it is not currently used)
\let\Sectionmark\sectionmark
\def\sectionmark#1{\def\Sectionname{#1}\Sectionmark{#1}}

% The header and the footer
\ihead{\Chaptername}
\ohead{Section~\thesection}
\ofoot*{\pagemark} % the * forces the footer to be printed even in chapter pages, but not in titlepage .


% Defines tocHeader, a page style to be used in the table of contents
\newpairofpagestyles{tocHeader}{
	\ihead{Table of Contents}
	\ofoot*{\pagemark}
	}


% Defines biblioHeader, a page style to be used in the bibliography.
\newpairofpagestyles{biblioHeader}{
	\ihead{Bibliography}
	\ofoot*{\pagemark}
	}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OTHER DEFINITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\graphicspath{{figures/}}
\setcounter{secnumdepth}{3} % number subsubsections
\setcounter{tocdepth}{3} % list subsubsections
\definecolor{lightblue}{RGB}{17, 134, 192} % Matches the light blue part in UFES logo
\definecolor{darkblue}{RGB}{18, 52, 99} % Matches the dark blue part in UFES logo
\definecolor{journalcolor}{RGB}{110, 40, 110} % Color used in the bibliography for the journals names, it is used by PPGCosmoN.bst.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHAPTER LAYOUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\KOMAoption{chapterprefix}{true}
\renewcommand*\raggedchapter{\centering}
\RedeclareSectionCommand[beforeskip=0pt,afterskip=8\baselineskip]{chapter}
\setkomafont{chapterprefix}{\normalsize\mdseries}
\renewcommand*{\chapterformat}{%
\chapappifchapterprefix{\nobreakspace} \thechapter \autodot%
  \IfUsePrefixLine{%
    \par\nobreak\vspace{-\parskip}\vspace{-.6\baselineskip}%
    \rule{0.9\textwidth}{.5pt}%
  }{\enskip}%
}
\renewcommand\chapterlineswithprefixformat[3]{%
  \MakeUppercase{#2}#3
}


%%%%%%%%%%%%%%%%%%%%%%%%%% EXPANDED eqref DEFINITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Needs the xparse package.
% Allows the use of \eqref{label1, label2,..., labelLast}. Otherwise, \eqref only
% works with a single label.
% It is the equivalent of (\ref{label1}-\ref{labelLast}})
% This is a variation from a case that can be found in tex.stackexchange.

\ifnoxparse 
\else
	\ExplSyntaxOn
	\DeclareDocumentCommand{\eqref}{m}{\quinn_mref:n {#1}}
	\seq_new:N \l_quinn_mref_seq
	\cs_new:Npn \quinn_mref:n #1
	 {
	  \seq_set_split:Nnn \l_quinn_mref_seq { , } { #1 }
	  \seq_pop_right:NN \l_quinn_mref_seq \l_tmpa_tl
	  (
	  \seq_map_inline:Nn \l_quinn_mref_seq
	    { \ref{##1},\nobreakspace }
	  \exp_args:NV \ref \l_tmpa_tl
	  )
	 }
	\ExplSyntaxOff
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST PAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% New page elements

\newcommand{\@degree}{\large Thesis submitted as part of the requirements for the degree of \\ Doctor of Philosophy in Astronomy \& Physics}

\newcommand{\@supervisor}{}
\newcommand{\supervisor}[1]{\gdef\@supervisor{#1}}
\newkomafont{supervisor}{\normalfont\large}

\newcommand{\@supervisoraddress}{}
\newcommand{\supervisoraddress}[1]{\gdef\@supervisoraddress{#1}}

\newcommand{\@cosupervisor}{}
\newcommand{\cosupervisor}[1]{\gdef\@cosupervisor{#1}}

\newcommand{\@cosupervisoraddress}{}
\newcommand{\cosupervisoraddress}[1]{\gdef\@cosupervisoraddress{#1}}

\newcommand{\@thesisyear}{}
\newcommand{\thesisyear}[1]{\gdef\@thesisyear{#1}}

\newcommand{\@dedicatory}{}
\newcommand{\dedicatory}[1]{\gdef\@dedicatory{#1}}

\newcommand{\@banca}{}
\newcommand{\banca}[1]{\gdef\@banca{#1}}

%% Builds the first pages, which are called by the user through \maketitle
\renewcommand{\maketitle}
{
	% FIRST PAGE
	\begin{titlepage}
		\sffamily
		\frontmatter         % pages are numbered using i, ii, iii...
		\centering

		\begin{figure}[h]
			\centering
			\includegraphics[width=2.5cm]{logo-ufes.png}
		\end{figure}
		\noindent
		{\textbf{\huge Universidade Federal do Espírito Santo}}\\[0.25cm]
		{\textbf{\Large Programa de Pós-Graduação em Astrofísica, Cosmologia e Gravitação}}\\

		\vspace{1cm}
		\begin{center}
			\vspace{1cm}
			\textcolor{lightblue}{\textbf{\huge \@title}}\\
			\vspace{1cm}
			\textbf{\textcolor{black}{\Large \@author}}\\
			\vspace{4cm}
			\@degree
		\end{center}
		\vfill
		\begin{tabular}{ll}
			{\large Supervisor:} & \@supervisor\\
				& \textit{\@supervisoraddress} \\[.2cm]
			{\large Co-supervisor:} & \@cosupervisor\\
				& \textit{\@cosupervisoraddress}
		\end{tabular}
		\vspace{1cm}
		\begin{center}
			\includegraphics[width=3.0cm]{logo-ppgcosmo.png}\\[0.5cm]
			\textbf{\Large \@thesisyear}
		\end{center}

	\end{titlepage}

	\ifapproved
		% SECOND PAGE - Approved version 
		\begin{titlepage}
			\sffamily
			\vspace{2cm}
			\noindent
			{\textbf{\large Universidade Federal do Espírito Santo}}\\
			\textbf{\large Centro de Ciências Exatas}\\
			{{\large Programa de Pós-Graduação em Astrofísica, Cosmologia e Gravitação}}
	
			\vspace{2cm}
	
			\noindent
			\textbf{\large \@title}\\
	
			\noindent
			{\large \@author}
	
			\vspace{2cm}
	
			\noindent
			\begin{minipage}{0.75\textwidth}
				\noindent
				A presente tese ``\textit{\@title}'' foi submetida por  \mbox{\textit{\@author}}  ao PPGCosmo, tendo sido  apresentada e aprovada no ano de {\@thesisyear} como parte dos requisitos para a obtenção do título de Doutor em Astronomia e Física.
	
				\vspace{2cm}
				
				Comissão avaliadora:\\
				
				\@banca
				
				\noindent
			\end{minipage}
		\end{titlepage}

	\else
		% SECOND PAGE - Submitted version 
		\begin{titlepage}
			\sffamily
			\vspace{2cm}
			\noindent
			{\textbf{\large Universidade Federal do Espírito Santo}}\\
			\textbf{\large Centro de Ciências Exatas}\\
			{{\large Programa de Pós-Graduação em Astrofísica, Cosmologia e Gravitação}}
	
			\vspace{2cm}
	
			\noindent
			\textbf{\large \@title}\\
	
			\noindent
			{\large \@author}
	
			\vspace{2cm}
	
			\noindent
			\begin{minipage}{0.75\textwidth}
				\noindent
				A presente tese ``\textit{\@title}'' foi submetida no ano de {\@thesisyear} ao PPGCosmo por \textit{\@author} como parte dos requisitos para a obtenção do título de Doutor em Astronomia e Física.
	
				\bigskip
	
				\noindent
				Caso esta tese venha a ser aprovada, esta folha deverá ser substituída pela correspondente de aprovação.
			\end{minipage}
		\end{titlepage}
	\fi

	% DEDICATORY
	\if\@dedicatory0 %i.e., if \@dedicatory=0 do nothing, otherwise do the dedicatory page.
	\else
		{
		\begin{titlepage}
			\vspace*{\stretch{3}}
			\begin{flushright}
			   \emph{\@dedicatory}
			\end{flushright}
			\vspace*{\stretch{1}}
		\end{titlepage}
		}
	\fi
	% ABSTRACT
	\begin{minipage}{0.90\textwidth}
		\chapter*{Abstract}
		\input{sections/abstract.tex}

		\hrulefill
	\end{minipage}
	\pagebreak

	% RESUMO
	\begin{minipage}{0.90\textwidth}
		\chapter*{Resumo}
		\input{sections/resumo.tex}

		\hrulefill
	\end{minipage}
	\pagebreak

	% ACKNOWLEDGEMENTS
	\begin{minipage}{0.95\textwidth}
		\input{sections/acknowledgements}
	\end{minipage}
	\pagebreak

	% TABLE OF CONTENTS
	\pagestyle{tocHeader}    % page style becomes the previously defined tocHeader
	{
	\hypersetup{linkcolor=darkblue} 
	\tableofcontents
	}

	\mainmatter              % pages start to be numbered by 1, 2, 3...
	
	\pagestyle{scrheadings} % page style returns to the standard.
}
