%%%% dvs.cls -- LaTeX document class
%%%% Copyright 2016 Christian Scheen
%%
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%
%%     http://www.latex-project.org/lppl.txt
%%
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%%
%% This work has the LPPL maintenance status `author-maintained'.
%%
%% The Current Maintainer of this work is Christian Scheen.
%%
%% This work consists of the files cls/dvs.cls, xdy/dvs_a.xdy,
%% xdy/dvs_d.xdy, xdy/dvs_n.xdy, xdy/dvs_p.xdy, xdy/dvs_u.xdy and
%% xdy/dvs_w.xdy.
%%
%%
%% Class identification
%% --------------------
%%
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{dvs}
    [2021-07-08 v1.0j Discographie de Vladimir Sofronickij (CS)]
%%
%%
%% Parent class
%% ------------
%%
\PassOptionsToClass{a4paper}{memoir}
\PassOptionsToClass{10pt}{memoir}
\PassOptionsToClass{extrafontsizes}{memoir}
\PassOptionsToClass{twoside}{memoir}
\PassOptionsToClass{onecolumn}{memoir}
\PassOptionsToClass{openright}{memoir}
\PassOptionsToClass{final}{memoir}
\LoadClass{memoir}[2020/10/04]
%%
%%
%% Class options
%% -------------
%%
\RequirePackage{ifthen}[2014/09/29]
\newboolean{dvs@ptframe}
\newboolean{dvs@pthang}
\DeclareOption{frame}{%
    \ClassInfo{dvs}{Page layout diagram required}%
    \setboolean{dvs@ptframe}{true}}
\DeclareOption{noframe}{%
    \ClassInfo{dvs}{No page layout diagram required}%
    \setboolean{dvs@ptframe}{false}}
\DeclareOption{hang}{%
    \ClassInfo{dvs}{Hanging sectional numbers required}%
    \setboolean{dvs@pthang}{true}}
\DeclareOption{nohang}{%
    \ClassInfo{dvs}{Default sectional numbers required}%
    \setboolean{dvs@pthang}{false}}
\ProcessOptions
\ifthenelse{\boolean{dvs@ptframe}}{%
    \RequirePackage{showframe}[2020/10/14]}{}
%%
%%
%% Metadata
%% --------
%%
\def\RCS$#1: #2 ${\expandafter\def\csname RCS#1\endcsname{#2\xspace}}
\input dvs.ver
%%
%%
%% Multiple indexes support
%% ------------------------
%%
\DisemulatePackage{index}
\def\disableindex#1{%
    \@for\@tempa:=#1\do{%
        \@namedef{disable@\@tempa}{}%
        \@ifundefined{tf@\@tempa}{}{%
            \PackageWarningNoLine{index}{It's too late to disable
                the `\@tempa' index;\MessageBreak
                \jobname.\@tempa\space has already
                been opened for output. You \MessageBreak
                should put the \string\disableindex\space command
                before\MessageBreak
                the declaration of the `\@tempa' index}%
        }%
    }%
}
\newif\if@newindex
\def\newindex{%
    \@tempswafalse
    \@ifnextchar[{\@tempswatrue\x@newindex}{\x@newindex[thepage]}%
}
\def\x@newindex[#1]{%
    \@ifstar {\@tempswafalse\y@newindex{#1}}
             {\y@newindex{#1}}%
}
\def\y@newindex#1#2{%
    \@ifundefined{idx@#2}%
        {\@newindextrue\def@index{#1}{#2}}%
        {%
            \@latexerr{Index type `\string#2' already defined}\@ehc
            \expandafter\@gobble\@gobbletwo
        }%
}
\def\renewindex{%
    \@tempswafalse
    \@ifnextchar[{\@tempswatrue\x@renewindex}{\x@renewindex[thepage]}%
}
\def\x@renewindex[#1]{%
    \@ifstar {\@tempswafalse\y@renewindex{#1}}
             {\y@renewindex{#1}}%
}
\def\y@renewindex#1#2{%
    \@ifundefined{idx@#2}%
        {%
            \@newindextrue
            \@latexerr{Index type `\string#2' not defined}\@ehc
        }%
        {\@newindexfalse}%
    \def@index{#1}{#2}%
}
\@onlypreamble\newindex
\@onlypreamble\renewindex
\@onlypreamble\disableindex
\def\def@index#1#2#3#4{%
    \@namedef{idx@#2}{#3:#4:#1}%
    \expandafter\let\csname if@immediate@#2\endcsname\if@tempswa
    \if@filesw
        \if@newindex
            \expandafter\newtoks\csname idxtitle@#2\endcsname
        \fi
        \@ifundefined{disable@#2}{%
            \if@newindex
                \expandafter\newwrite\csname tf@#2\endcsname
            \else
                \immediate\closeout\@nameuse{tf@#2}%
            \fi
            \immediate\openout\@nameuse{tf@#2}\jobname.#3 %
            \PackageInfo{index}{Writing index file \jobname.#3}%
        }
        {\PackageInfo{index}{Index `#2' disabled -- not opening
                      \jobname.#3}}%
    \fi
    \expandafter\csname idxtitle@#2\endcsname
}
\def\@second#1:#2:#3\@nil{#2}
\def\@third#1:#2:#3\@nil{#3}
\def\@nearverbatim{\expandafter\strip@prefix\meaning}
\edef\makeindex{%
    \noexpand\newindex{default}{idx}{ind}{\indexname}%
}
\newif\if@silentindex\@silentindextrue
\newif\if@addtoindex\@addtoindextrue
\newif\ifproofmode\proofmodefalse
\def\index{\protect\p@index}
\def\p@index{%
    \if@silentindex\@bsphack\fi
    \@ifstar{\@silentindexfalse\@xindex}{\@silentindextrue\@xindex}%
}
\def\@xindex{\@ifnextchar[{\@index}{\@index[default]}}
\def\@index[#1]{%
    \ifx\index\@gobble
        \@addtoindexfalse
    \fi
    \def\@tempf{%
        \begingroup
            \@sanitize
            \@@index{#1}%
    }%
    \if@addtoindex
        \@ifundefined{idx@#1}%
            {%
              \def\@tempf{%
                  \@latexerr{Index type `\string#1' undefined}%
                  \@ehc
                  \@silentindextrue
                  \@gobble
              }%
            }%
            {}%
    \fi
    \@tempf
}
\def\@@index#1#2{%
    \endgroup
    \if@addtoindex
        \if@filesw\@wrindex{#1}{#2}\fi
        \ifproofmode\@showidx{#2}\fi
    \fi
    \if@silentindex
        \expandafter\@esphack
    \else
        \@silentindextrue#2%
    \fi
}
\def\@wrindex#1#2{%
    \begingroup
        \def\@tempa{#2}%
        \edef\@tempb{\@nameuse{idx@#1}}%
        \edef\@tempb{\expandafter\@third\@tempb\@nil}%
        \csname if@immediate@#1\endcsname \else
            \expandafter\let\csname\@tempb\endcsname\relax
        \fi
        \edef\@tempa{%
           \write\@auxout{%
              \string\@writefile{#1}{%
                  \string\indexentry{\@nearverbatim\@tempa}%
                                    {\@nameuse{\@tempb}}%
              }%
           }%
        }%
    \expandafter\endgroup\@tempa
    \if@nobreak\ifvmode\nobreak\fi\fi
}
\providecommand{\seename}{see}
\providecommand*{\see}[2]{\emph{\seename} #1}
\@ifclassloaded{article}{%
    \renewenvironment{theindex}{%
        \edef\indexname{\the\@nameuse{idxtitle@\@indextype}}%
        \if@twocolumn
            \@restonecolfalse
        \else
            \@restonecoltrue
        \fi
        \columnseprule \z@
        \columnsep 35\p@
        \twocolumn[%
            \section*{\indexname}%
            \ifx\index@prologue\@empty\else
                \index@prologue
                \bigskip
            \fi
        ]%
        \@mkboth{\MakeUppercase\indexname}%
                {\MakeUppercase\indexname}%
        \thispagestyle{plain}%
        \parindent\z@
        \parskip\z@ \@plus .3\p@\relax
        \let\item\@idxitem
    }{%
        \if@restonecol
            \onecolumn
        \else
            \clearpage
        \fi
    }
}{%
    \renewenvironment{theindex}{%
        \edef\indexname{\the\@nameuse{idxtitle@\@indextype}}%
        \if@twocolumn
            \@restonecolfalse
        \else
            \@restonecoltrue
        \fi
        \columnseprule \z@
        \columnsep 35\p@
        \twocolumn[%
            \@makeschapterhead{\indexname}%
            \ifx\index@prologue\@empty\else
                \index@prologue
                \bigskip
            \fi
        ]%
        \@mkboth{\MakeUppercase\indexname}%
                {\MakeUppercase\indexname}%
        \thispagestyle{plain}%
        \parindent\z@
        \parskip\z@ \@plus .3\p@\relax
        \let\item\@idxitem
    }{%
        \if@restonecol
            \onecolumn
        \else
            \clearpage
        \fi
    }
}
\def\printindex{\@ifnextchar[{\@printindex}{\@printindex[default]}}
\def\@printindex[#1]{%
    \@ifnextchar[{\@print@index[#1]}{\@print@index[#1][]}%
}
\long\def\@print@index[#1][#2]{%
    \def\@indextype{#1}%
    \long\def\index@prologue{#2}%
    \@ifundefined{idx@#1}%
        {\@latexerr{Index type `\string#1' undefined}\@ehc}%
        {%
            \edef\@tempa{\@nameuse{idx@#1}}%
            \edef\@tempa{%
                \noexpand\@input@{\jobname.\expandafter\@second\@tempa\@nil}%
            }%
            \@tempa
        }%
}
\def\@indexstar@{\index*}
\def\idx@activehat{%
    \relax
    \ifmmode\expandafter\sp\else\expandafter\@indexstar@\fi
}
\def\idx@activebar{%
    \relax
    \ifmmode\expandafter\sb\else\expandafter\index\fi
}
\newif\if@shortindexing
\begingroup
    \catcode`\^\active
    \catcode`\_\active
    \gdef\shortindexingon{%
        \@shortindexingtrue
        \chardef\old@idxhatcode\catcode`\^\relax
        \chardef\old@idxbarcode\catcode`\_\relax
        \catcode`\^\active
        \catcode`\_\active
        \let\old@idxhat ^%
        \let\old@idxbar _%
        \let^\idx@activehat
        \let_\idx@activebar
    }
    \gdef\shortindexingoff{%
        \if@shortindexing
            \@shortindexingfalse
            \let^\old@idxhat
            \let_\old@idxbar
            \catcode`\^\old@idxhatcode
            \catcode`\_\old@idxbarcode
        \fi
    }
\endgroup
\newinsert\@indexbox
\dimen\@indexbox\maxdimen
\begingroup
    \catcode`\@\active
    \expandafter\gdef\csname\string @sanitizeat\endcsname
        {\def @{\char`\@}}
\endgroup
\newtoks\indexproofstyle
\indexproofstyle{\footnotesize\reset@font\ttfamily}
\def\@showidx#1{%
    \insert\@indexbox{%
        \@sanitizeat
        \the\indexproofstyle
        \hsize\marginparwidth
        \hangindent\marginparsep \parindent\z@
        \everypar{}\let\par\@@par \parfillskip\@flushglue
        \lineskip\normallineskip
        \baselineskip .8\normalbaselineskip\sloppy
        \raggedright \leavevmode
        \vrule \@height .7\normalbaselineskip \@width \z@\relax#1\relax
        \vrule \@height\z@ \@depth.3\normalbaselineskip \@width\z@\relax
    }%
    \ifhmode\penalty\@M \hskip\z@skip\fi
}
\def\@leftidx{\hskip-\marginparsep \hskip-\marginparwidth}
\def\@rightidx{\hskip\columnwidth \hskip\marginparsep}
\def\@mkidx{%
    \vbox to \z@{%
        \rlap{%
            \if@twocolumn
                \if@firstcolumn \@leftidx \else \@rightidx \fi
            \else
                \if@twoside
                    \ifodd\c@page \@rightidx \else \@leftidx \fi
                \else
                    \@rightidx
                \fi
            \fi
            \box\@indexbox
        }%
        \vss
    }%
}
\def\raggedbottom{%
    \def\@textbottom{\vskip\z@ plus.0001fil}%
    \let\@texttop\@mkidx
}
\def\flushbottom{\let\@textbottom\relax \let\@texttop\@mkidx}
\let\@texttop\@mkidx
\CheckCommand\addtocontents[2]{%
  \protected@write\@auxout
      {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble}%
      {\string\@writefile{#1}{#2}}%
}
\renewcommand{\addtocontents}[2]{%
    \protected@write\@auxout
      {\let\label\@gobble \let\glossary\@gobble}%
      {\string\@writefile{#1}{#2}}%
}
\let\old@starttoc\@starttoc
\renewcommand{\@starttoc}[1]{%
    \begingroup
        \@addtoindexfalse
        \old@starttoc{#1}%
    \endgroup
}
\DeclareRobustCommand\markboth[2]{%
    \begingroup
        \let\label\relax \let\glossary\relax
        \unrestored@protected@xdef\@themark {{#1}{#2}}%
        \@temptokena \expandafter{\@themark}%
        \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}
\DeclareRobustCommand\markright[1]{%
    \begingroup
        \let\label\relax \let\glossary\relax
        \expandafter\@markright\@themark {#1}%
        \@temptokena \expandafter{\@themark}%
        \mark{\the\@temptokena}%
    \endgroup
    \if@nobreak\ifvmode\nobreak\fi\fi
}
\newcounter{performance}[section]
\renewcommand{\theperformance}{\thesection\Alph{performance}}
\newindex[thepage]{ndxnames}{idxn}{indn}{\nindexname}
\newindex[thepage]{ndxauths}{idxa}{inda}{\aindexname}
\newindex[theperformance]{ndxdiscs}{idxd}{indd}{\dindexname}
\newindex[theperformance]{ndxperfs}{idxp}{indp}{\pindexname}
\newindex[theperformance]{ndxunpub}{idxu}{indu}{\uindexname}
\newindex[theperformance]{ndxworks}{idxw}{indw}{\windexname}
\newcommand{\nindexname}{Index onomastique}
\newcommand{\aindexname}{Liste des citations}
\newcommand{\dindexname}{%
    Contenu des disques vinyles et des disques compacts}
\newcommand{\pindexname}{%
    Chronologie des enregistrements en studio et en direct}
\newcommand{\uindexname}{%
    Liste des enregistrements indisponibles ou non publiés}
\newcommand{\windexname}{%
    Compositeurs et œuvres par ordre de numéros d'opus}
\newcommand{\nindexprologue}{%
    \hspace*{13\p@}\ignorespaces
    L'index onomastique contient les noms propres mentionnés dans le
    document~; il complète, sans répétitions, la liste des citations, et les
    références croisées concernent les numéros de pages.
    La transcription française des noms propres russes est renvoyée vers la
    translittération scientifique correspondante~; voir aussi le tableau en
    page~\pageref{tab:Correspondance}.}
\newcommand{\aindexprologue}{%
    \hspace*{13\p@}\ignorespaces
    La liste des citations contient les noms d'auteurs cités dans le
    document~; elle complète, sans répétitions, l'index onomastique, et les
    références croisées concernent les numéros de pages.}
\newcommand{\dindexprologue}{%
    \hspace*{13\p@}\ignorespaces
    La liste recense le contenu des disques vinyles de la série des
    enregistrements complets, publiée par Melodija entre~1979 et~1984, et
    celui des disques compacts consacrés à \VSofronitsky{}.
    Les publications sur disques 78~tours, échelonnées de~1937 à~1959, sont
    aussi répertoriées, de même que les éditions sur support informatique
    dématérialisé (fichiers~FLAC ou~MP3, par exemple), pour autant que ces
    dernières proposent des interprétations jusqu'alors inédites.}
\newcommand{\pindexprologue}{%
    \hspace*{13\p@}\ignorespaces
    La liste recense de manière chronologique toutes les dates de présence
    de \VSofronitsky{} dans les studios d'enregistrement (symbole~\symbSR{})
    ou en récital enregistré (symbole~\symbLR{}).
    Elle est organisée comme un index où les entrées sont les numéros des
    interprétations, avec une remise à zéro du compteur des interprétations
    pour chaque œuvre et chaque compositeur.
    Ce chapitre se rapporte aussi bien à la première partie, la chronologie,
    qu'à la deuxième, la discographie.
    Les lieux d'enregistrement sont abrégés comme suit~: M~désigne Moskva,
    GS~la grande salle (Bol'šoj) du conservatoire de Moskva, PS~la petite
    salle (Malyj) du conservatoire de Moskva, ST~la salle de concert
    \PTchaikovski{} à Moskva, MS~le musée \Scriabine{} dans le quartier
    d'\hbox{Arbat} à Moskva, AS~l'appartement de \VSofronitsky{} à Moskva,
    L~Leningrad, PL~la grande salle de la société philharmonique de
    Leningrad et I~un lieu d'enregistrement inconnu.}
\newcommand{\uindexprologue}{}
\newcommand{\windexprologue}{%
    \hspace*{13\p@}\ignorespaces
    La table des matières ou liste des compositeurs et des œuvres, qui
    figure à la fin de ce document, adopte un classement alphabétique sur
    les noms des compositeurs et sur les titres des œuvres.
    La liste ci-dessous recense ce même répertoire enregistré de
    \VSofronitsky{} en adoptant en revanche un classement alphabétique sur
    les noms des compositeurs et ensuite un classement par ordre croissant
    des numéros d'opus des œuvres.
    Les références croisées de cette liste sont données sous la forme
    générique~: \Quote{p.~\pholder{numéro de page}/\S{}~\pholder{numéro de
    section associée à l'œuvre}}.}
\renewenvironment{theindex}{%
    \edef\indexname{\the\@nameuse{idxtitle@\@indextype}}%
    \columnseprule0.4\p@
    \columnsep2\parindent
    \chapter{\indexname}
    \parindent\z@
    \parskip\z@\@plus0.3\p@\relax
    \let\item=\@idxitem
    \multicoltolerance=9999%
    \begin{multicols}{\numofcols}[\index@prologue]
        \fontsize{8}{11pt}\selectfont
        \raggedright
        \clubpenalty=10000%
        \widowpenalty=10000%
        \displaywidowpenalty=10000%
        \predisplaypenalty=10000%
        \postdisplaypenalty=50}{%
        \par
    \end{multicols}}
\renewcommand{\@idxitem}{\par\hangindent10\p@}
\renewcommand{\subitem}{\par\hangindent10\p@\hspace*{10\p@}}
\renewcommand{\subsubitem}{\par\hangindent10\p@\hspace*{20\p@}}
\renewcommand{\indexspace}{\par\vskip8.0\p@\@plus2.0\p@\@minus1.0\p@\relax}
%%
%%
%% Color settings
%% --------------
%%
\PassOptionsToPackage{cmyk}{xcolor}
\RequirePackage{xcolor}[2016/05/11]
\definecolor{dvsred}{cmyk}{0.00,0.83,0.91,0.28}
\definecolor{dvsgreen}{cmyk}{0.63,0.00,0.78,0.38}
\definecolor{dvsblue}{cmyk}{0.99,0.73,0.00,0.29}
\definecolor{dvswhite}{cmyk}{0.00,0.00,0.00,0.00}
\definecolor{dvstitle}{cmyk}{0.73,0.47,0.00,0.51}
%%
%%
%% Font settings
%% -------------
%%
\PassOptionsToPackage{no-math}{fontspec}
\RequirePackage{fontspec}[2020/02/21]
\setmainfont{Libertinus Serif}[%
    Renderer           = {Full},%
    Ligatures          = {TeX,Common,Historic},%
    BoldFont           = {Libertinus Serif Bold},%
    BoldFeatures       = {Ligatures=HistoricOff},%
    ItalicFont         = {Libertinus Serif Italic},%
    BoldItalicFont     = {Libertinus Serif Bold Italic},%
    BoldItalicFeatures = {Ligatures=HistoricOff},%
    SmallCapsFeatures  = {LetterSpace=6,Contextuals=AlternateOff},%
    RawFeature         = {+cpsp,+ss05,+ss06},%
    Numbers            = {OldStyle,Monospaced},%
    WordSpace          = {1,1.2,1},%
    Scale              = {1},%
]
\setsansfont{Source Sans Pro}[%
    Renderer           = {Full},%
    Ligatures          = {TeX},%
    BoldFont           = {Source Sans Pro Semibold},%
    ItalicFont         = {Source Sans Pro Italic},%
    BoldItalicFont     = {Source Sans Pro Semibold Italic},%
    SmallCapsFeatures  = {LetterSpace=6},%
    Numbers            = {OldStyle},%
    WordSpace          = {1,1.2,1},%
    Scale              = {MatchUppercase},%
]
\setmonofont{Source Code Pro}[%
    Renderer           = {Full},%
    Ligatures          = {TeX},%
    BoldFont           = {Source Code Pro Semibold},%
    ItalicFont         = {Source Code Pro Italic},%
    BoldItalicFont     = {Source Code Pro Semibold Italic},%
    SmallCapsFeatures  = {LetterSpace=6},%
    Numbers            = {OldStyle},%
    WordSpace          = {1,1.2,1},%
    Scale              = {MatchLowercase},%
]
\newfontfamily\dvssymbolfont{Asana Math}[%
    Renderer           = {Full},%
    Ligatures          = {TeX},%
    BoldFont           = {Asana Math},%
    ItalicFont         = {Asana Math},%
    BoldItalicFont     = {Asana Math},%
    SmallCapsFeatures  = {LetterSpace=6},%
    Scale              = {1},%
]
\newfontfamily\dvslicensefont{CCIcons}[%
    Renderer           = {Full},%
    Ligatures          = {TeX},%
    BoldFont           = {CCIcons},%
    ItalicFont         = {CCIcons},%
    BoldItalicFont     = {CCIcons},%
    SmallCapsFeatures  = {LetterSpace=6},%
    Scale              = {1},%
]
\newfontfamily\liningnumbersseriffont{Libertinus Serif}[%
    Renderer           = {Full},%
    Ligatures          = {TeX,Common,Historic},%
    BoldFont           = {Libertinus Serif Bold},%
    BoldFeatures       = {Ligatures=HistoricOff},%
    ItalicFont         = {Libertinus Serif Italic},%
    BoldItalicFont     = {Libertinus Serif Bold Italic},%
    BoldItalicFeatures = {Ligatures=HistoricOff},%
    SmallCapsFeatures  = {LetterSpace=6,Contextuals=AlternateOff},%
    RawFeature         = {+cpsp,+ss05,+ss06},%
    Numbers            = {Lining,Monospaced},%
    WordSpace          = {1,1.2,1},%
    Scale              = {1},%
]
\DeclareFontSeriesDefault[rm]{bf}{b}
\DeclareFontSeriesDefault[sf]{bf}{b}
\DeclareFontSeriesDefault[tt]{bf}{b}
\newcommand{\dvssymbol}[1]{{\dvssymbolfont\symbol{#1}}}
\newcommand{\pholder}[1]{\dvssymbol{"27E8}\textit{#1}\dvssymbol{"27E9}}
\newcommand{\dvsborn}{\fup{\dvssymbol{"2218}}\xspace}
\newcommand{\dvsdied}{\fup{\dvssymbol{"2020}}\xspace}
\newcommand{\symbSE}{\dvssymbol{"29BE}\xspace}
\newcommand{\symbLP}{\dvssymbol{"29BF}\xspace}
\newcommand{\symbCD}{\dvssymbol{"29B6}\xspace}
\newcommand{\symbDO}{\dvssymbol{"29BB}\xspace}
\newcommand{\symbSR}{\symbol{"2020}\xspace}
\newcommand{\symbLR}{\symbol{"2021}\xspace}
\newcommand{\OneHalf}{\symbol{"00BD}\xspace}
\newcommand{\dvslicensesymbol}[1]{{\dvslicensefont\symbol{#1}}}
\newcommand{\dvsCC}{\dvslicensesymbol{"0063}\xspace}
\newcommand{\dvsBY}{\dvslicensesymbol{"0062}\xspace}
\newcommand{\dvsSA}{\dvslicensesymbol{"0061}\xspace}
\newcommand{\dvsND}{\dvslicensesymbol{"0064}\xspace}
\newcommand{\dvsNC}{\dvslicensesymbol{"0065}\xspace}
\newcommand{\dvslicense}{\dvsCC{}\dvsBY{}\xspace}
\newcommand{\AllaBreve}{\symbol{"00A2}\xspace}
\newcommand{\PerfArrow}{\symbol{"25B6}\xspace}
\newcommand{\fileurl}[1]{\texttt{#1}}
%%
%%
%% Multilingual typesetting
%% ------------------------
%%
\PassOptionsToPackage{dutch}{babel}
\PassOptionsToPackage{german}{babel}
\PassOptionsToPackage{italian}{babel}
\PassOptionsToPackage{spanish}{babel}
\PassOptionsToPackage{portuguese}{babel}
\PassOptionsToPackage{russian}{babel}
\PassOptionsToPackage{english}{babel}
\PassOptionsToPackage{french}{babel}
\RequirePackage{babel}[2021/01/26]
\frenchsetup{%
    StandardItemizeEnv=true,
    StandardEnumerateEnv=true,
    ListItemsAsPar=true,
    ItemLabeli=\textbullet,
    ItemLabelii=\textopenbullet,
    ItemLabeliii=\textemdash,
    ItemLabeliv=\textendash,
    AutoSpacePunctuation=false,
    SuppressWarning=true,
    INGuillSpace=true,
    FrenchFootnotes=false,
    AutoSpaceFootnotes=true}
\addto\captionsfrench{\def\figurename{Figure}}
\addto\captionsfrench{\def\tablename{Tableau}}
\renewcommand*{\CaptionSeparator}{.\space}
\renewcommand\dutchhyphenmins{33}
\renewcommand\germanhyphenmins{33}
\renewcommand\italianhyphenmins{33}
\renewcommand\spanishhyphenmins{33}
\renewcommand\portuguesehyphenmins{33}
\renewcommand\russianhyphenmins{33}
\renewcommand\englishhyphenmins{33}
\renewcommand\frenchhyphenmins{33}
%%
%%
%% Context sensitive quotes
%% ------------------------
%%
\RequirePackage{csquotes}[2021-01-04]
%%
%%
%% Bibliography and citations
%% --------------------------
%%
\PassOptionsToPackage{hyphens}{url}
\PassOptionsToPackage{backend=biber}{biblatex}
\PassOptionsToPackage{style=authoryear-comp}{biblatex}
\PassOptionsToPackage{natbib=true}{biblatex}
\PassOptionsToPackage{sorting=nyvt}{biblatex}
\PassOptionsToPackage{sortcites=true}{biblatex}
\PassOptionsToPackage{maxnames=9999}{biblatex}
\PassOptionsToPackage{minnames=1}{biblatex}
\PassOptionsToPackage{hyperref=true}{biblatex}
\PassOptionsToPackage{backref=true}{biblatex}
\PassOptionsToPackage{backrefstyle=none}{biblatex}
\PassOptionsToPackage{indexing=true}{biblatex}
\PassOptionsToPackage{abbreviate=false}{biblatex}
\PassOptionsToPackage{dateabbrev=false}{biblatex}
\PassOptionsToPackage{mergedate=false}{biblatex}
\PassOptionsToPackage{date=comp}{biblatex}
\PassOptionsToPackage{dashed=false}{biblatex}
\RequirePackage{biblatex}[2020/12/31]
\renewcommand{\bibsetup}{\flushbottom}
\defbibenvironment{bibliography}{%
    \list{}{%
        \setlength{\bibhang}{13\p@}%
        \setlength{\leftmargin}{\bibhang}%
        \setlength{\itemindent}{-\leftmargin}%
        \setlength{\bibitemsep}{5\p@\@plus5\p@\@minus0.5\p@}%
        \setlength{\itemsep}{\bibitemsep}%
        \setlength{\bibparsep}{0\p@}%
        \setlength{\parsep}{\bibparsep}%
        \clubpenalty=10000%
        \@clubpenalty\clubpenalty
        \widowpenalty=10000%
        \lefthyphenmin=3%
        \righthyphenmin=3%
        \uchyph=-1}}{%
    \endlist}{%
    \item}
\defbibheading{subbibliography}[\refname]{%
    \ifmemoirbibintoc{%
        \phantomsection
        \addcontentsline{toc}{section}{#1}%
        \section*{#1}}{%
        \section*{#1}}%
    \if@twoside\markright{\abx@MakeMarkcase{#1}}\fi}
\defbibheading{subbibintoc}[\refname]{%
    \phantomsection
    \addcontentsline{toc}{section}{#1}%
    \section*{#1}%
    \if@twoside\markright{\abx@MakeMarkcase{#1}}\fi}
\defbibheading{subbibnumbered}[\refname]{%
    \phantomsection
    \section{#1}}
\DeclareIndexNameFormat{default}{%
    \nameparts{#1}%
    \usebibmacro{index:name}{\index[ndxauths]}%
        {\namepartfamily}%
        {\namepartgiven}%
        {\namepartprefix}%
        {\namepartsuffix}}
\renewbibmacro*{citeindex}{%
    \ifboolexpr{ test {\ifciteindex} and not test {\iffootnote} }{%
        \indexnames{author}%
        \indexnames{editor}%
        \indexnames{translator}}{}}
\renewbibmacro*{bibindex}{%
    \ifboolexpr{ test {\ifbibindex} and not test {\iffootnote} }{%
        \indexnames{author}%
        \indexnames{editor}%
        \indexnames{translator}}{}}
\addbibresource{bib/dvs.bib}
\DefineBibliographyExtras{french}{%
    \renewcommand{\bibdatedash}{-\penalty\hyphenpenalty}%
    \renewcommand{\bibrangedash}{-\penalty\hyphenpenalty}}
\renewbibmacro*{volume+number+eid}{%
    \setunit{\addcomma\space}%
    \printfield{volume}%
    \setunit{\addcomma\space}%
    \printfield{number}%
    \setunit{\addcomma\space}%
    \printfield{eid}}
\renewbibmacro*{name:andothers}{%
    \ifboolexpr{
        test {\ifnumequal{\value{listcount}}{\value{liststop}}}
        and
        test \ifmorenames
    }
        {\ifnumgreater{\value{liststop}}{1}
            {\finalandcomma}
            {}%
        \andothersdelim\bibstring[\mkandothers]{andothers}}
        {}}
\newcommand*{\mkandothers}{\mkbibemph}
\DeclareFieldFormat[article]{volume}{vol.~#1}
\DeclareFieldFormat[article]{number}{\Number{#1}}
\DefineBibliographyExtras{french}{\restorecommand\mkbibnamefamily}
\renewcommand*{\mkbibnamefamily}[1]{\textnohyphenation{#1}}
\AtBeginBibliography{%
    \renewcommand*{\mkbibnamefamily}[1]{\textsc{\textnohyphenation{#1}}}}
\renewcommand*{\nameyeardelim}{\space}
\DefineBibliographyStrings{french}{%
    urlseen = {site Internet visité le},%
    backrefpage = {référence citée en page~\ignorespaces},%
    backrefpages = {référence citée en pages~\ignorespaces}}
%%
%%
%% Multicolumn output
%% ------------------
%%
\RequirePackage{multicol}[2019/12/09]
%%
%%
%% Infix notation arithmetic
%% -------------------------
%%
\RequirePackage{calc}[2017/05/25]
%%
%%
%% Date with week day
%% ------------------
%%
\RequirePackage{tikz}[2020/12/27]
\RequirePackage{pgfcalendar} %%%%[2020/12/27]
\newcount\dvsJulianDay
\newcount\dvsWeekDay
\newcommand{\DateWithWeekDay}[1]{#1
    \pgfcalendardatetojulian{#1}{\dvsJulianDay}%
    \pgfcalendarjuliantoweekday{\dvsJulianDay}{\dvsWeekDay}%
    \advance\dvsWeekDay by1\relax
    \ifcase\dvsWeekDay
        \or (lundi)%
        \or (mardi)%
        \or (mercredi)%
        \or (jeudi)%
        \or (vendredi)%
        \or (samedi)%
        \or (dimanche)%
    \fi}
%%
%%
%% Hyphenatable letter-spacing
%% ---------------------------
%%
\RequirePackage{soul}[2003/11/17]
%%
%%
%% Manipulating token chains
%% -------------------------
%%
\RequirePackage{xstring}[2019/02/06]
%%
%%
%% Typesetting engine
%% ------------------
%%
\newcounter{LuaTeXVer}
\setcounter{LuaTeXVer}{\the\luatexversion}
\newcounter{LuaTeXMaj}
\newcounter{LuaTeXMin}
\ifnum\theLuaTeXVer>99
    \setcounter{LuaTeXMaj}{\theLuaTeXVer/100}
    \setcounter{LuaTeXMin}{\theLuaTeXVer-100}
\else
    \setcounter{LuaTeXMaj}{0}
    \setcounter{LuaTeXMin}{\theLuaTeXVer}
\fi
\newcommand{\engname}{\hologo{LuaTeX}\xspace}
\newcommand{\engversion}{%
    \theLuaTeXMaj.%
    \ifnum\theLuaTeXMin>9
        \theLuaTeXMin.%
    \else
        0\theLuaTeXMin.%
    \fi
    \luatexrevision\xspace}
%%
%%
%% Hypertext marks
%% ---------------
%%
\PassOptionsToPackage{colorlinks=true}{hyperref}
\PassOptionsToPackage{hyperindex=false}{hyperref}
\PassOptionsToPackage{pdfpagemode=UseOutlines}{hyperref}
\PassOptionsToPackage{pdfstartpage=1}{hyperref}
\PassOptionsToPackage{pdfstartview=FitH}{hyperref}
\PassOptionsToPackage{pdfview=FitH}{hyperref}
\PassOptionsToPackage{pdfremotestartview=FitH}{hyperref}
\PassOptionsToPackage{linkcolor=dvsred}{hyperref}
\PassOptionsToPackage{filecolor=dvsblue}{hyperref}
\PassOptionsToPackage{citecolor=dvsgreen}{hyperref}
\PassOptionsToPackage{menucolor=dvsred}{hyperref}
\PassOptionsToPackage{urlcolor=dvsblue}{hyperref}
\PassOptionsToPackage{unicode=true}{hyperref}
\RequirePackage{hyperref}[2020-05-15]
\PassOptionsToPackage{open}{bookmark}
\PassOptionsToPackage{openlevel=0}{bookmark}
\RequirePackage{bookmark}[2020-11-06]
\hypersetup{%
    pdftitle={Vladimir Sofronickij : discographie},%
    pdfauthor={Christian Scheen},%
    pdfsubject={Discographie de Vladimir Sofronickij},%
    pdfkeywords={Sofronickij, chronologie, discographie, bibliographie},%
    pdfcreator={%
        LaTeX \fmtversion\
        avec
        dvs.cls \RCSDocClass\ v\RCSRevision\ (\RCSAuthor)},%
    pdfproducer={LuaTeX \engversion\ (distribution TeX Live)}}
\hyperlinkfileprefix{file:}
\urlstyle{same}
%%
%%
%% Clever spacing after macros
%% ---------------------------
%%
\RequirePackage{xspace}[2014/10/28]
%%
%%
%% Logos
%% -----
%%
\RequirePackage{hologo}[2019/12/05]
\newcommand{\Biber}{\Hologo{biber}\xspace}
\newcommand{\Biblatex}{Bib\hologo{LaTeX}\xspace}
\newcommand{\Bibtex}{\hologo{BibTeX}\xspace}
\newcommand{\Latex}{\hologo{LaTeX}\xspace}
\newcommand{\Latexe}{\hologo{LaTeX2e}\xspace}
\newcommand{\Lualatex}{\hologo{LuaLaTeX}\xspace}
\newcommand{\Luatex}{\hologo{LuaTeX}\xspace}
\newcommand{\Pdflatex}{\Hologo{pdfLaTeX}\xspace}
\newcommand{\Pdftex}{\Hologo{pdfTeX}\xspace}
\newcommand{\Tex}{\hologo{TeX}\xspace}
\newcommand{\Texfourht}{\hologo{TeX}4ht\xspace}
\newcommand{\Xelatex}{\hologo{XeLaTeX}\xspace}
\newcommand{\Xetex}{\hologo{XeTeX}\xspace}
\newcommand{\Xindy}{X\r{\i}ndy\xspace}
%%
%%
%% Floats
%% ------
%%
\RequirePackage{longtable}[2020/01/07]
\captionnamefont{\normalsize\rmfamily\bfseries\upshape}
\captiontitlefont{\normalsize\rmfamily\mdseries\itshape}
\cmidrulewidth=0.25pt
\heavyrulewidth=1.00pt
\lightrulewidth=0.25pt
\newcommand{\SHS}{\hspace{1.0em}}
\newcommand{\BHS}{\hspace{2.8em}}
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{1}
\setcounter{totalnumber}{3}
\setcounter{dbltopnumber}{2}
\renewcommand{\topfraction}{.9}
\renewcommand{\bottomfraction}{.9}
\renewcommand{\textfraction}{.1}
\renewcommand{\floatpagefraction}{.9}
\renewcommand{\dbltopfraction}{.9}
\renewcommand{\dblfloatpagefraction}{.9}
%%
%%
%% PDF settings
%% ------------
%%
\outputmode=1
\protrudechars=0
\adjustspacing=0
\pdfvariable minorversion=5
\pdfvariable compresslevel=9
\pdfvariable objcompresslevel=3
\pdfvariable decimaldigits=4
\pdfvariable pkresolution=600
\pdfvariable imageresolution=300
\pdfvariable uniqueresname=1
\pdfvariable inclusionerrorlevel=0
%%
%%
%% Microtypographic refinements
%% ----------------------------
%%
\PassOptionsToPackage{protrusion=false}{microtype}
\PassOptionsToPackage{expansion=true}{microtype}
\PassOptionsToPackage{auto=true}{microtype}
\PassOptionsToPackage{stretch=20}{microtype}
\PassOptionsToPackage{shrink=10}{microtype}
\PassOptionsToPackage{step=1}{microtype}
\PassOptionsToPackage{selected=false}{microtype}
\PassOptionsToPackage{tracking=false}{microtype}
\PassOptionsToPackage{kerning=false}{microtype}
\PassOptionsToPackage{spacing=false}{microtype}
\PassOptionsToPackage{DVIoutput=false}{microtype}
\PassOptionsToPackage{final=true}{microtype}
\PassOptionsToPackage{verbose=errors}{microtype}
\PassOptionsToPackage{babel=false}{microtype}
\PassOptionsToPackage{config=microtype}{microtype}
\RequirePackage{microtype}[2020/12/07]
%%
%%
%% Page layout
%% -----------
%%
\settypeblocksize{550pt}{140mm}{*}
\setlrmargins{*}{*}{1}
\setulmargins{56.8485540335mm}{*}{*}
\setheadfoot{12pt}{10mm}
\setheaderspaces{*}{10mm-12pt}{*}
\setmarginnotes{2.5pt}{25mm}{12pt}
\marginparmargin{left}
\sideparmargin{left}
\checkandfixthelayout
\setlength{\parskip}{\z@\@plus4\p@\@minus\z@}
\setlength{\parindent}{13\p@}
%%
%%
%% Header and footer
%% -----------------
%%
\makepagestyle{dvsheadings}
\nouppercaseheads
\makepsmarks{dvsheadings}{%
    \def\chaptermark##1{\markboth{\MakeLowercase{##1}}{}}
    \def\sectionmark##1{%
        \markright{%
            \ifnum\c@secnumdepth > \z@%
                \S{}~\arabic{section}\symbol{"005D}%
            \fi}}
    \def\tocmark{\markboth{\MakeLowercase{\contentsname}}{}}
    \def\lofmark{\markboth{\MakeLowercase{\listfigurename}}{}}
    \def\lotmark{\markboth{\MakeLowercase{\listtablename}}{}}
    \def\bibmark{\markboth{\MakeLowercase{\bibname}}{}}
    \def\indexmark{\markboth{\MakeLowercase{\indexname}}{}}
    \def\glossarymark{\markboth{\MakeLowercase{\glossaryname}}{}}}
\makeevenhead{dvsheadings}%
    {{\normalsize\arabic{page}}}%
    {{\normalsize\textsc{vladimir sofronickij~: discographie}}}%
    {{\normalsize\if@mainmatter\symbol{"005B}\thechapter\fi}}
\makeoddhead{dvsheadings}%
    {{\normalsize\if@mainmatter\rightmark\fi}}%
    {{\normalsize\textsc{\leftmark}}}%
    {{\normalsize\arabic{page}}}
\makeevenfoot{dvsheadings}%
    {}%
    {}%
    {}
\makeoddfoot{dvsheadings}%
    {}%
    {}%
    {}
\aliaspagestyle{part}{empty}
\aliaspagestyle{chapter}{empty}
\pagestyle{dvsheadings}
%%
%%
%% Title pages
%% -----------
%%
\newcounter{cntrmo}
\newcounter{cntrda}
\newcommand{\RCSTypesetting}{%
    \setcounter{cntrmo}{\month}%
    \setcounter{cntrda}{\day}%
    \number\year%
    \ifthenelse{\value{cntrmo}<10}{-0}{-}\number\month%
    \ifthenelse{\value{cntrda}<10}{-0}{-}\number\day\xspace}
\DeclareGraphicsExtensions{.pdf,.png,.jpg}
\newcommand*{\titleDVS}{\begingroup
    \thispagestyle{empty}%
    \centering
    {\normalsize\mdseries\scshape vladimir sofronickij~: discographie}%
    \newpage
    \thispagestyle{empty}%
    \tikz[remember picture,overlay]%
    \node[opacity=1,inner sep=0pt] at (current page.center){%
        \includegraphics[width=\paperwidth,height=\paperheight]{img/vvs}};
    \newpage
    \thispagestyle{empty}%
    \centering
    {\HUGE\mdseries\scshape vladimir sofronickij}\\[1.6\baselineskip]
    {\LARGE\mdseries\scshape chronologie}\\[0.8\baselineskip]
    {\LARGE\mdseries\scshape discographie}\\[0.8\baselineskip]
    {\LARGE\mdseries\scshape bibliographie}\\[3.2\baselineskip]
    {\normalsize\mdseries\upshape Document préparé par Christian Scheen}\par
    \vspace*{\fill}%
    {\normalsize\mdseries\upshape Composition en~\Latex}\\[0.8\baselineskip]
    {\normalsize\mdseries\upshape Mise à jour~\RCSDate}\par
    \vspace*{28pt}%
    \newpage
    \thispagestyle{empty}%
    \raggedright
    \vspace*{\fill}%
    \noindent
    {\normalsize\bfseries\upshape\VSofronitsky}\\
    {\normalsize\bfseries\itshape\hspace*{13\p@}%
        Chronologie}\\
    {\normalsize\bfseries\itshape\hspace*{13\p@}%
        Discographie}\\
    {\normalsize\bfseries\itshape\hspace*{13\p@}%
        Bibliographie}\\[0.8\baselineskip]
    {\normalsize\mdseries\upshape
        Licence~\dvslicense
        \href{https://creativecommons.org/licenses/by/4.0/}{CC~BY~4.0}}\\
    {\normalsize\mdseries\itshape
        Creative Commons Attribution~4.0 International}\\[0.8\baselineskip]
    {\normalsize\mdseries\upshape
        \href{https://github.com/cscheen/sofronitsky}%
            {https://github.com/cscheen/sofronitsky}}\\[0.8\baselineskip]
    \begin{tabular}[t]{@{}l@{\hspace*{13\p@}}l@{}}
        {\normalsize\mdseries\upshape Mise à jour}
        & {\normalsize\mdseries\upshape \RCSDate} \\
        {\normalsize\mdseries\upshape Composition}
        & {\normalsize\mdseries\upshape \RCSTypesetting} \\
    \end{tabular}
    \endgroup}
%%
%%
%% Main matter
%% -----------
%%
\renewcommand*{\@smemmain}{%
    \@mainmattertrue
    \setcounter{secnumdepth}{\value{maxsecnumdepth}}%
    \ifartopt
        \if@twoside
            \clearpage
        \else
            \clearpage
        \fi
    \else
        \clearpage
        \@memmain@floats
    \fi}
%%
%%
%% Part titles
%% -----------
%%
\long\def\@part[#1]#2{%
    \M@gettitle{#1}%
    \def\f@rtoc{#1}%
    \@nameuse{part@f@rtoc@before@write@hook}%
    \phantomsection
    \mempreaddparttotochook
    \ifnum \c@secnumdepth >-2\relax
        \refstepcounter{part}%
        \def\dvspartnum{\csname ordinal\romannumeral\value{part}\endcsname}%
        \addcontentsline{toc}{part}%
            {\protect\partnumberline{\dvspartnum}\f@rtoc}%
        \mempartinfo{\thepart}{\f@rtoc}{#2}%
    \else
        \addcontentsline{toc}{part}{\f@rtoc}%
        \mempartinfo{}{\f@rtoc}{#2}%
    \fi
    \mempostaddparttotochook
    \partmark{#1}%
    {\centering
        \interlinepenalty \@M
        \parskip\z@
        \normalfont
        \ifnum \c@secnumdepth >-2\relax
            \printpartname \partnamenum \printpartnum
            \midpartskip
        \fi
        \printparttitle{#2}\par}%
    \@endpart}
\renewcommand{\partnamefont}{%
    \normalfont\Large\rmfamily\mdseries\scshape\raggedleft}
\renewcommand{\partnumfont}{%
    \normalfont\Large\rmfamily\mdseries\scshape}
\renewcommand{\parttitlefont}{%
    \normalfont\huge\rmfamily\bfseries\upshape}
%%
%%
%% Chapter titles
%% --------------
%%
\newlength\dvs@normtxtw
\setlength\dvs@normtxtw{\textwidth}
\newsavebox{\dvs@chap}
\newcommand\dvs@chap@mark[1][36mm]{%
    \sbox\dvs@chap{%
        \resizebox{!}{#1}{\fboxsep=1pt%
            \colorbox{dvstitle}{\color{dvswhite}%
                \textbf{{\liningnumbersseriffont\thechapter}}}}}%
    \rotatebox{90}{%
        \resizebox{%
            \heightof{\usebox{\dvs@chap}}+\depthof{\usebox{\dvs@chap}}}%
        {!}{\rmfamily\bfseries\scshape\color{dvstitle}\so\@chapapp}}\quad
    \raisebox{\depthof{\usebox{\dvs@chap}}}{\usebox{\dvs@chap}}}
\newcommand\dvs@chm[1][36mm]{%
    \sbox\dvs@chap{\dvs@chap@mark[#1]}%
    \makebox[0pt][l]{%
        \makebox[9mm][r]{\usebox\dvs@chap}}}
\makechapterstyle{dvs}{%
    \renewcommand\chapnamefont{\normalfont\LARGE\scshape\raggedleft\so}
    \renewcommand\chaptitlefont{\normalfont\LARGE\bfseries\color{dvstitle}}
    \renewcommand\chapternamenum{}
    \renewcommand\printchaptername{}
    \renewcommand\printchapternum{\null\hfill\dvs@chm[22.5mm]\par}
    \renewcommand\afterchapternum{\par\vskip\midchapskip}
    \renewcommand\printchaptertitle[1]{\chaptitlefont\raggedleft ##1\par}}
\chapterstyle{dvs}
\setlength{\afterchapskip}{36\p@\@plus3.6\p@\@minus1.8\p@}
%%
%%
%% Table of contents settings
%% --------------------------
%%
\maxtocdepth{section}
\setpnumwidth{2.32em}
\setrmarg{5.23em}
\cftsetindents{part}{0.00em}{0.00em}
\cftsetindents{chapter}{0.00em}{0.00em}
\cftsetindents{section}{1.18em}{0.00em}
\cftsetindents{subsection}{2.36em}{0.00em}
\cftsetindents{subsubsection}{3.54em}{0.00em}
\cftsetindents{paragraph}{4.72em}{0.00em}
\cftsetindents{subparagraph}{5.90em}{0.00em}
\renewcommand{\cftpartfont}{%
    \normalfont\normalsize\rmfamily\bfseries\scshape}
\renewcommand{\cftpartpagefont}{%
    \normalfont\normalsize\rmfamily\mdseries\upshape}
\renewcommand{\cftchapterfont}{%
    \normalfont\normalsize\rmfamily\bfseries\upshape}
\renewcommand{\cftchapterpagefont}{%
    \normalfont\normalsize\rmfamily\mdseries\upshape}
\renewcommand{\partnumberlinebox}[2]{#2}
\renewcommand{\cftpartname}{}
\renewcommand{\cftpartpresnum}{}
\renewcommand{\cftpartaftersnum}{\space partie}
\renewcommand{\cftpartaftersnumb}{.\space}
\renewcommand{\chapternumberlinebox}[2]{#2}
\renewcommand{\cftchaptername}{Chapitre}
\renewcommand{\cftappendixname}{Annexe}
\renewcommand{\cftchapterpresnum}{\nobreakspace}
\renewcommand{\cftchapteraftersnum}{}
\renewcommand{\cftchapteraftersnumb}{.\space}
\renewcommand{\numberlinebox}[2]{#2}
\renewcommand{\cftsectionname}{}
\renewcommand{\cftsectionpresnum}{}
\renewcommand{\cftsectionaftersnum}{}
\renewcommand{\cftsectionaftersnumb}{.\space}
\setlength{\cftbeforepartskip}{12\p@\@plus2.4\p@\@minus1.2\p@}
\setlength{\cftbeforechapterskip}{8\p@\@plus1.6\p@\@minus0.8\p@}
\setlength{\cftbeforesectionskip}{0\p@\@plus1.0\p@\@minus0.0\p@}
\newlength{\dvschapterlength}
\settowidth{\dvschapterlength}{%
    \normalfont\normalsize\rmfamily\bfseries\upshape Chapitre}
\setlength{\cftchapternumwidth}{-\dvschapterlength}
\let\originaltableofcontents\tableofcontents
\renewcommand\tableofcontents{%
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{\contentsname}%
    \originaltableofcontents}
\AtBeginDocument{%
    \addtocontents{toc}{\protect\phantomsection}%
    \addtocontents{toc}{\protect\label{chap:Tabledesmatieres}}}
%%
%%
%% New if's
%% --------
%%
\newif\ifAvail\Availfalse
\newif\ifChrono\Chronofalse
\newif\ifHand\Handfalse
\newif\ifLive\Livefalse
\newif\ifPubl\Publtrue
\newif\ifPunct\Puncttrue
%%
%%
%% Lower level headings
%% --------------------
%%
\setsecheadstyle{\normalsize\sffamily\bfseries\upshape\color{dvstitle}}
\setsubsecheadstyle{\normalsize\sffamily\bfseries\itshape\color{dvstitle}}
\setsubsubsecheadstyle{\normalsize\sffamily\mdseries\itshape\color{dvstitle}}
\setparaheadstyle{\normalsize\sffamily\mdseries\upshape\color{dvstitle}}
\setsubparaheadstyle{\normalsize\sffamily\mdseries\upshape\color{dvstitle}}
\setbeforesecskip{3.18ex plus0.95ex minus0.32ex}
\setaftersecskip{2.09ex plus0.63ex minus0.21ex}
\setbeforesubsecskip{2.95ex plus0.89ex minus0.30ex}
\setaftersubsecskip{1.36ex plus0.41ex minus0.14ex}
\setbeforesubsubsecskip{2.95ex plus0.89ex minus0.30ex}
\setaftersubsubsecskip{1.36ex plus0.41ex minus0.14ex}
\setbeforeparaskip{2.95ex plus0.89ex minus0.30ex}
\setafterparaskip{1.36ex plus0.41ex minus0.14ex}
\setbeforesubparaskip{2.95ex plus0.89ex minus0.30ex}
\setaftersubparaskip{1.36ex plus0.41ex minus0.14ex}
\ifthenelse{\boolean{dvs@pthang}}{%
    \hangsecnum
    \setsecnumformat{\llap{\@nameuse{the#1}.\space}}}{%
    \defaultsecnum
    \setsecnumformat{\csname the#1\endcsname.\space}}
%%
%%
%% Lists
%% -----
%%
\PassOptionsToPackage{shortlabels}{enumitem}
\RequirePackage{enumitem}[2019/06/20]
\setlist[itemize,enumerate]{%
    topsep=0\p@\@plus1\p@\@minus0\p@,%
    partopsep=0\p@\@plus1\p@\@minus0\p@,%
    parsep=0\p@\@plus1\p@\@minus0\p@,%
    itemsep=0\p@\@plus1\p@\@minus0\p@,%
    align=left,%
    leftmargin=0\p@,%
    rightmargin=0\p@,%
    labelindent=1.00\parindent,%
    listparindent=1.00\parindent,%
    labelwidth=0\p@,%
    labelsep=0.5em,%
    itemindent=!,%
}
\setlist[itemize,enumerate,2]{%
    labelindent=1.65\parindent,%
    listparindent=1.65\parindent,%
}
\setlist[enumerate,1]{%
    label=\textup{\arabic*}\textup{\symbol{"0029}},%
}
\setlist[enumerate,2]{%
    label=\textup{\alph*}\textup{\symbol{"0029}},%
}
\setlist[description]{%
    style=unboxed,%
    topsep=0\p@\@plus1\p@\@minus0\p@,%
    partopsep=0\p@\@plus1\p@\@minus0\p@,%
    parsep=1.5\p@\@plus2\p@\@minus0.2\p@,%
    itemsep=1.5\p@\@plus2\p@\@minus0.2\p@,%
    align=left,%
    leftmargin=\parindent,%
    rightmargin=0\p@,%
}
\newenvironment{perfitemize}{%
    \begin{itemize}
    \samepage}{%
    \ifAvail
    \else
        \ifPubl
            \index[ndxunpub]{\relax|attrUnavail}%
        \else
            \index[ndxunpub]{\relax|attrUnpubld}%
        \fi
        \Publtrue
    \fi
    \ifHand
        \addtocounter{availtime}{\value{perftime}}%
    \fi
    \Handfalse
    \end{itemize}}
\newenvironment{workitemize}{%
    \begin{itemize}}{%
    \end{itemize}}
%%
%%
%% Widows and orphans
%% ------------------
%%
\PassOptionsToPackage{all}{nowidow}
\PassOptionsToPackage{defaultlines=2}{nowidow}
\RequirePackage{nowidow} %%%%[2011/09/20]
%%
%%
%% Available and unavailable performances
%% --------------------------------------
%%
\newcounter{availtime}
\setcounter{availtime}{0}
\newcounter{totaltime}
\setcounter{totaltime}{0}
\newcounter{unavailtime}
\newcounter{perftime}
\newcounter{perfbyauthor}[chapter]
\newcounter{totperfs}
\newcounter{totworks}
\newcounter{tth}
\newcounter{ttm}
\newcounter{tts}
\newcommand{\availabletotaltime}{%
    \setcounter{tth}{\value{availtime}/3600}%
    \setcounter{ttm}{(\value{availtime}-\value{tth}*3600)/60}%
    \setcounter{tts}{\value{availtime}-\value{tth}*3600-\value{ttm}*60}%
    \thetth\up{h}%
    \ifthenelse{\value{ttm}<10}{~0}{~}\thettm\up{m}%
    \ifthenelse{\value{tts}<10}{~0}{~}\thetts\up{s}\xspace}
\newcommand{\unavailabletotaltime}{%
    \setcounter{unavailtime}{\value{totaltime}-\value{availtime}}%
    \setcounter{tth}{\value{unavailtime}/3600}%
    \setcounter{ttm}{(\value{unavailtime}-\value{tth}*3600)/60}%
    \setcounter{tts}{\value{unavailtime}-\value{tth}*3600-\value{ttm}*60}%
    \thetth\up{h}%
    \ifthenelse{\value{ttm}<10}{~0}{~}\thettm\up{m}%
    \ifthenelse{\value{tts}<10}{~0}{~}\thetts\up{s}\xspace}
%%
%%
%% Footnotes
%% ---------
%%
\setfootins{20\p@\@plus4\p@\@minus2\p@}{20\p@\@plus4\p@\@minus2\p@}
\renewcommand*{\footnoterule}{%
    \kern-6\p@%
    \hrule\@height.25\p@\@width99.5846456692\p@%
    \kern5.75\p@}
\footmarkstyle{#1.\@~}
\setlength{\footmarkwidth}{-1sp}
\setlength{\footmarksep}{0em}
\renewcommand{\foottextfont}{\small}
%%
%%
%% Music
%% -----
%%
\newcommand{\Opus}[1]{opus~#1}
\newcommand{\Number}[1]{n°~#1}
\newcommand{\Numbers}[1]{n\up{os}~#1}
\newcommand{\kA}{\textit{la}\xspace}
\newcommand{\kB}{\textit{si}\xspace}
\newcommand{\kC}{\textit{ut}\xspace}
\newcommand{\kD}{\textit{ré}\xspace}
\newcommand{\kE}{\textit{mi}\xspace}
\newcommand{\kF}{\textit{fa}\xspace}
\newcommand{\kG}{\textit{sol}\xspace}
\newcommand{\Flat}{bémol\xspace}
\newcommand{\Sharp}{dièse\xspace}
%%
%%
%% Miscellaneous commands
%% ----------------------
%%
\newcommand{\InclNumber}[1]{[\ref{#1}\StrRight{#1}{1}]~(p.~\pageref{#1})}
\newcommand{\PerfNumber}[1]{%
    [\ref{#1}\StrRight{#1}{1}] \nameref{#1} (p.~\pageref{#1})}
\newcommand{\CompleteRef}[1]{p.~\pageref{#1}/\S{}~\ref{#1}}
\newcommand{\HyperpageNumber}[1]{\hyperlink{page.#1}{#1}}
\newcommand{\indxbf}[1]{\textbf{#1}\nopagebreak}
\newcommand{\Dates}[2]{%
    #1\texorpdfstring{\dvsborn{}}{°}
    \texorpdfstring{--}{--}
    #2\texorpdfstring{\dvsdied{}}{+}}
\newcommand{\Point}[2]{#1\up{m}~#2\up{s}}
\newcommand{\Comment}[1]{\par\noindent\hbox{\textsc{Remarque}.--} #1}
\newcommand{\Quote}[1]{\enquote{#1}}
\newcommand{\Volume}[1]{vol.~#1}
\newcommand{\Page}[1]{p.~#1}
\newcommand{\Pages}[2]{p.~#1-#2}
\newcommand{\PublishDate}[1]{Disque publié en~#1.}
\newcommand{\cad}{c'est-\hbox{à-dire}\xspace}
\newcommand{\via}{\emph{via}\xspace}
\newcommand{\ClosePunct}{\ifPunct,\Punctfalse\else\relax\fi\xspace}
\newcommand{\ibid}{\emph{ibid.}\xspace}
\newcommand{\Ibid}{\emph{Ibid.}\xspace}
%%
%%
%% Performance typesetting
%% -----------------------
%%
\newcommand{\onfile}[1]{\Availtrue\Handtrue#1}
\newcommand{\onhand}[1]{\Availtrue\Handtrue\index[ndxdiscs]{\indxbf{#1}}#1}
\newcommand{\nohand}[1]{\index[ndxdiscs]{\indxbf{#1}}#1}
\newcommand{\Date}[1]{\emph{Date}~: #1}
\newcommand{\Time}[2]{\emph{Durée}~: #1\up{m}~#2\up{s}}
\newcommand{\Venue}[1]{\emph{Lieu}~: #1}
\newcounter{SmallVenue}
\newcommand{\Moscow}{\setcounter{SmallVenue}{1}%
    Moskva\xspace}
\newcommand{\MCGH}{\setcounter{SmallVenue}{2}%
    Moskva (conservatoire, grande salle)\xspace}
\newcommand{\MCSH}{\setcounter{SmallVenue}{3}%
    Moskva (conservatoire, petite salle)\xspace}
\newcommand{\MPTH}{\setcounter{SmallVenue}{4}%
    Moskva (salle de concert \PTchaikovski{})\xspace}
\newcommand{\MSHM}{\setcounter{SmallVenue}{5}%
    Moskva (Arbat, musée \Scriabine{})\xspace}
\newcommand{\MVSA}{\setcounter{SmallVenue}{6}%
    Moskva (Novopesčanaja, appartement de \VSofronitsky{})\xspace}
\newcommand{\Leningrad}{\setcounter{SmallVenue}{7}%
    Leningrad\xspace}
\newcommand{\LPGH}{\setcounter{SmallVenue}{8}%
    Leningrad (société philharmonique, grande salle)\xspace}
\newcommand{\Unknown}{\setcounter{SmallVenue}{9}%
    inconnu\xspace}
\newcommand{\Recording}[1]{\emph{Enregistrement}~: #1}
\newcommand{\Studio}{en studio\Livefalse\xspace}
\newcommand{\Live}{en direct\Livetrue\xspace}
\newcommand{\TestDate}[1]{%
    \noexpandarg
    \StrLen{#1}[\DateLength]%
    \fullexpandarg
    \IfStrEq{\DateLength}{10}{\DateWithWeekDay{#1}}{#1}}
\newcommand{\Performance}[5]{%
    \stepcounter{performance}%
    \stepcounter{perfbyauthor}%
    \noexpandarg
    \StrLen{#1}[\DateLength]%
    \fullexpandarg
    \textbf{[\theperformance]}\phantomsection\label{\theperformance}%
    \strictpagecheck%
    \sidepar{\hfill{\footnotesize\arabic{performance}\,}\PerfArrow{}}
    \IfStrEq{\DateLength}{10}{\Date{\DateWithWeekDay{#1}}}{\Date{#1}}.
    \Time{#2}{#3}.
    \Venue{#4}.
    \Recording{#5}.%
    \setcounter{perftime}{#2*60+#3}%
    \addtocounter{totaltime}{\value{perftime}}%
    \ifLive
        \ifcase\value{SmallVenue}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,M)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,GS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,PS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,ST)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,MS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,AS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,L)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,PL)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbLR{}\,I)}}%
        \fi
    \else
        \ifcase\value{SmallVenue}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,M)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,GS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,PS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,ST)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,MS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,AS)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,L)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,PL)}}\or
            \index[ndxperfs]{\indxbf{\TestDate{#1} (\symbSR{}\,I)}}%
        \fi
    \fi
    \Availfalse
    \Livefalse}
\newcommand{\OnSE}{\emph{Sur disque 78~tours}~\symbSE{}\xspace}
\newcommand{\OnLP}{\emph{Sur disque vinyle}~\symbLP{}\xspace}
\newcommand{\OnCD}{\emph{Sur disque compact}~\symbCD{}\xspace}
\newcommand{\OnDO}{\emph{En édition dématérialisée}~\symbDO{}\xspace}
\newcommand{\Other}{\emph{Autres formats}\xspace}
\newcommand{\EditionOnSE}[1]{\OnSE~: #1.}
\newcommand{\EditionOnLP}[1]{\OnLP~: #1.}
\newcommand{\EditionOnCD}[1]{\OnCD~: #1.}
\newcommand{\EditionOnDO}[1]{\OnDO~: #1.}
\newcommand{\EditionOther}[1]{\Other~: #1.}
\newcommand{\NoEdition}{\emph{Enregistrement non publié}.\Publfalse\xspace}
\newcommand{\EC}[1]{\Quote{Enregistrements complets}, \Volume{#1}}
\newcommand{\CR}[1]{\Quote{Enregistrements complets}, \Volume{#1}%
    \index[ndxdiscs]{\indxbf{Melodija -- Enregistrements complets, vol.~#1}}}
\newcommand{\TrackTiming}[2]{[#1\up{m}~#2\up{s}]}
%%
%%
%% Names
%% -----
%%
\newcommand{\Aleksandrov}{Aleksandrov%
    \protect\index[ndxnames]{Aleksandrov, Anatolij Nikolaevič}}
\newcommand{\AAleksandrov}{Anatolij \Aleksandrov}
%%
\newcommand{\Alyavdina}{Aljavdina%
    \protect\index[ndxnames]{Aljavdina, Anna A.}}
\newcommand{\AAlyavdina}{Anna \Alyavdina}
%%
\newcommand{\Bach}{Bach}
%%
\newcommand{\CBach}{Carl Philipp Emanuel \Bach%
    \protect\index[ndxnames]{Bach, Carl Philipp Emanuel}}
%%
\newcommand{\JBach}{Johann Sebastian \Bach%
    \protect\index[ndxnames]{Bach, Johann Sebastian}}
%%
\newcommand{\Badeyan}{Badejan%
    \protect\index[ndxnames]{Badejan, Tamara Georgievna}}
\newcommand{\TBadeyan}{Tamara \Badeyan}
%%
\newcommand{\Balakirev}{Balakirev%
    \protect\index[ndxnames]{Balakirev, Milij Alekseevič}}
\newcommand{\MBalakirev}{Milij \Balakirev}
%%
\newcommand{\Barinova}{Barinova%
    \protect\index[ndxnames]{Barinova, Galina Vsevolodovna}}
\newcommand{\GBarinova}{Galina \Barinova}
%%
\newcommand{\Baron}{Baron%
    \protect\index[ndxnames]{Baron, Nicolas}}
\newcommand{\NBaron}{Nicolas \Baron}
%%
\newcommand{\Bashkirov}{Baškirov%
    \protect\index[ndxnames]{Baškirov, Dmitrij Aleksandrovič}}
\newcommand{\DBashkirov}{Dmitrij \Bashkirov}
%%
\newcommand{\Beethoven}{Beethoven%
    \protect\index[ndxnames]{Beethoven, Ludwig van}}
\newcommand{\LBeethoven}{Ludwig van \Beethoven}
%%
\newcommand{\Benditsky}{Bendickij%
    \protect\index[ndxnames]{Bendickij, Semen Solomonovič}}
\newcommand{\SBenditsky}{Semen \Benditsky}
%%
\newcommand{\Berdiaiev}{Berdjaev%
    \protect\index[ndxnames]{Berdjaev, Valerian Valerianovič}}
\newcommand{\VBerdiaiev}{Valerian \Berdiaiev}
%%
\newcommand{\Berman}{Berman%
    \protect\index[ndxnames]{Berman, Lazar' Naumovič}}
\newcommand{\LBerman}{Lazar' \Berman}
%%
\newcommand{\Bernblium}{Bernbljum%
    \protect\index[ndxnames]{Bernbljum, Tina Michajlovna}}
\newcommand{\TBernblium}{Tina \Bernblium}
%%
\newcommand{\Blok}{Blok%
    \protect\index[ndxnames]{Blok, Aleksandr Aleksandrovič}}
\newcommand{\ABlok}{Aleksandr \Blok}
%%
\newcommand{\Blumenfeld}{Blumenfel'd%
    \protect\index[ndxnames]{Blumenfel'd, Feliks Michajlovič}}
\newcommand{\FBlumenfeld}{Feliks \Blumenfeld}
%%
\newcommand{\BogdanovBerezovsky}{Bogdanov-Berezovskij%
    \protect\index[ndxnames]{Bogdanov-Berezovskij, Valerian Michajlovič}}
\newcommand{\VBogdanovBerezovsky}{Valerian \BogdanovBerezovsky}
%%
\newcommand{\Borisov}{Borisov%
    \protect\index[ndxnames]{Borisov, Jurij Al'bertovič}}
\newcommand{\YBorisov}{Jurij \Borisov}
%%
\newcommand{\Borodine}{Borodin%
    \protect\index[ndxnames]{Borodin, Aleksandr Porfir'evič}}
\newcommand{\ABorodine}{Aleksandr \Borodine}
%%
\newcommand{\Bortnianski}{Bortnjanskij%
    \protect\index[ndxnames]{Bortnjanskij, Dmitrij Stepanovič}}
\newcommand{\DBortnianski}{Dmitrij \Bortnianski}
%%
\newcommand{\Boshniakovich}{Bošnjakovič%
    \protect\index[ndxnames]{Bošnjakovič, Oleg Dragomirovič}}
\newcommand{\OBoshniakovich}{Oleg \Boshniakovich}
%%
\newcommand{\Brahms}{Brahms%
    \protect\index[ndxnames]{Brahms, Johannes}}
\newcommand{\JBrahms}{Johannes \Brahms}
%%
\newcommand{\Brassin}{Brassin%
    \protect\index[ndxnames]{Brassin, Louis}}
\newcommand{\LBrassin}{Louis \Brassin}
%%
\newcommand{\Braudo}{Braudo%
    \protect\index[ndxnames]{Braudo, Isajja Aleksandrovič}}
\newcommand{\IBraudo}{Isajja \Braudo}
%%
\newcommand{\Busoni}{Busoni%
    \protect\index[ndxnames]{Busoni, Ferruccio}}
\newcommand{\FBusoni}{Ferruccio \Busoni}
%%
\newcommand{\Buxtehude}{Buxtehude%
    \protect\index[ndxnames]{Buxtehude, Dietrich}}
\newcommand{\DBuxtehude}{Dietrich \Buxtehude}
%%
\newcommand{\Chinaiev}{Činaev%
    \protect\index[ndxnames]{Činaev, Vladimir Petrovič}}
\newcommand{\VChinaiev}{Vladimir \Chinaiev}
%%
\newcommand{\Chopin}{Chopin%
    \protect\index[ndxnames]{Chopin, Fryderyk}}
\newcommand{\FChopin}{Fryderyk \Chopin}
%%
\newcommand{\Chostakovitch}{Šostakovič%
    \protect\index[ndxnames]{Šostakovič, Dmitrij Dmitrievič}}
\newcommand{\DChostakovitch}{Dmitrij \Chostakovitch}
%%
\newcommand{\Chtcherbatchiov}{Ščerbačëv%
    \protect\index[ndxnames]{Ščerbačëv, Vladimir Vladimirovič}}
\newcommand{\VChtcherbatchiov}{Vladimir \Chtcherbatchiov}
%%
\newcommand{\Clementi}{Clementi%
    \protect\index[ndxnames]{Clementi, Muzio}}
\newcommand{\MClementi}{Muzio \Clementi}
%%
\newcommand{\Cliburn}{Cliburn%
    \protect\index[ndxnames]{Van~Cliburn (Harvey Lavan Jr.)}}
\newcommand{\VanCliburn}{Van \Cliburn}
%%
\newcommand{\Coates}{Coates%
    \protect\index[ndxnames]{Coates, Albert}}
\newcommand{\ACoates}{Albert \Coates}
%%
\newcommand{\Cooper}{Kuper%
    \protect\index[ndxnames]{Kuper, Èmilij Al'bertovič}}
\newcommand{\ECooper}{Èmilij \Cooper}
%%
\newcommand{\Cordova}{Cordova%
    \protect\index[ndxnames]{Cordova, Daniel}}
\newcommand{\DCordova}{Daniel \Cordova}
%%
\newcommand{\Cortot}{Cortot%
    \protect\index[ndxnames]{Cortot, Alfred}}
\newcommand{\ACortot}{Alfred \Cortot}
%%
\newcommand{\Daugovet}{Daugovet%
    \protect\index[ndxnames]{Daugovet, Ekaterina Francevna}}
\newcommand{\EDaugovet}{Ekaterina \Daugovet}
%%
\newcommand{\Debussy}{Debussy%
    \protect\index[ndxnames]{Debussy, Claude}}
\newcommand{\CDebussy}{Claude \Debussy}
%%
\newcommand{\Dedioukhine}{Dedjuchin%
    \protect\index[ndxnames]{Dedjuchin, Aleksandr Aleksandrovič}}
\newcommand{\ADedioukhine}{Aleksandr \Dedioukhine}
%%
\newcommand{\Dedioukina}{Dedjukina%
    \protect\index[ndxnames]{Dedjukina, Ljudmila Alekseevna}}
\newcommand{\LDedioukina}{Ljudmila \Dedioukina}
%%
\newcommand{\Dukelsky}{Dukel'skij%
    \protect\index[ndxnames]{Dukel'skij, Vladimir Aleksandrovič}}
\newcommand{\VDukelsky}{Vladimir \Dukelsky}
%%
\newcommand{\Dupuy}{Dupuy%
    \protect\index[ndxnames]{Dupuy, Michel}}
\newcommand{\MDupuy}{Michel \Dupuy}
%%
\newcommand{\Dushinova}{Dušinova%
    \protect\index[ndxnames]{Dušinova, Valentina Nikolaevna}}
\newcommand{\VDushinova}{Valentina \Dushinova}
%%
\newcommand{\Emerson}{Emerson%
    \protect\index[ndxnames]{Emerson, Stephen}}
\newcommand{\SEmerson}{Stephen \Emerson}
%%
\newcommand{\Feigina}{Fejgina%
    \protect\index[ndxnames]{Fejgina, Nina Maksimovna}}
\newcommand{\NFeigina}{Nina \Feigina}
%%
\newcommand{\Feinberg}{Fejnberg%
    \protect\index[ndxnames]{Fejnberg, Samuil Evgen'evič}}
\newcommand{\SFeinberg}{Samuil \Feinberg}
%%
\newcommand{\Fetis}{Fétis%
    \protect\index[ndxnames]{Fétis, François-Joseph}}
\newcommand{\FFetis}{François-Joseph \Fetis}
%%
\newcommand{\Fichtengoltz}{Fichtengol'c%
    \protect\index[ndxnames]{Fichtengol'c, Lidija Izrailevna}}
\newcommand{\LFichtengoltz}{Lidija \Fichtengoltz}
%%
\newcommand{\Fogel}{Fogel%
    \protect\index[ndxnames]{Fogel, Henry}}
\newcommand{\HFogel}{Henry \Fogel}
%%
\newcommand{\Gakkel}{Gakkel'%
    \protect\index[ndxnames]{Gakkel', Leonid Evgen'evič}}
\newcommand{\LGakkel}{Leonid \Gakkel}
%%
\newcommand{\Gauk}{Gauk%
    \protect\index[ndxnames]{Gauk, Aleksandr Vasil'evič}}
\newcommand{\AGauk}{Aleksandr \Gauk}
%%
\newcommand{\Gercog}{Gercog%
    \protect\index[ndxnames]{Gercog, Ekaterina Sergeevna}}
\newcommand{\EGercog}{Ekaterina \Gercog}
%%
\newcommand{\Guilels}{Gilel's%
    \protect\index[ndxnames]{Gilel's, Èmil' Grigor'evič}}
\newcommand{\EGuilels}{Èmil' \Guilels}
%%
\newcommand{\Ginzburg}{Ginzburg%
    \protect\index[ndxnames]{Ginzburg, Grigorij Romanovič}}
\newcommand{\GGinzburg}{Grigorij \Ginzburg}
%%
\newcommand{\Giuntoli}{Giuntoli%
    \protect\index[ndxnames]{Giuntoli, Federico}}
\newcommand{\FGiuntoli}{Federico \Giuntoli}
%%
\newcommand{\Glazounov}{Glazunov%
    \protect\index[ndxnames]{Glazunov, Aleksandr Konstantinovič}}
\newcommand{\AGlazounov}{Aleksandr \Glazounov}
%%
\newcommand{\Glebov}{Glebov%
    \protect\index[ndxnames]{Glebov, Margarita}}
\newcommand{\MGlebov}{Margarita \Glebov}
%%
\newcommand{\Glinka}{Glinka%
    \protect\index[ndxnames]{Glinka, Michail Ivanovič}}
\newcommand{\MGlinka}{Michail \Glinka}
%%
\newcommand{\Goltz}{Gol'c%
    \protect\index[ndxnames]{Gol'c, Boris Grigor'evič}}
\newcommand{\BGoltz}{Boris \Goltz}
%%
\newcommand{\Golubovskaya}{Golubovskaja%
    \protect\index[ndxnames]{Golubovskaja, Nadežda Iosifovna}}
\newcommand{\NGolubovskaya}{Nadežda \Golubovskaya}
%%
\newcommand{\Gornostaieva}{Gornostaeva%
    \protect\index[ndxnames]{Gornostaeva, Vera Vasil'evna}}
\newcommand{\VGornostaieva}{Vera \Gornostaieva}
%%
\newcommand{\Gould}{Gould%
    \protect\index[ndxnames]{Gould, Glenn}}
\newcommand{\GGould}{Glenn \Gould}
%%
\newcommand{\Graham}{Graham%
    \protect\index[ndxnames]{Graham, Scott}}
\newcommand{\SGraham}{Scott \Graham}
%%
\newcommand{\Grieg}{Grieg%
    \protect\index[ndxnames]{Grieg, Edvard}}
\newcommand{\EGrieg}{Edvard \Grieg}
%%
\newcommand{\Grigorian}{Grigorjan%
    \protect\index[ndxnames]{Grigorjan, Džul'etta Armenovna}}
\newcommand{\JGrigorian}{Džul'etta \Grigorian}
%%
\newcommand{\Grinberg}{Grinberg%
    \protect\index[ndxnames]{Grinberg, Marija Izrailevna}}
\newcommand{\MGrinberg}{Marija \Grinberg}
%%
\newcommand{\Haendel}{Haendel%
    \protect\index[ndxnames]{Haendel, Georg Friedrich}}
\newcommand{\GHaendel}{Georg Friedrich \Haendel}
%%
\newcommand{\Haydn}{Haydn%
    \protect\index[ndxnames]{Haydn, Joseph}}
\newcommand{\JHaydn}{Joseph \Haydn}
%%
\newcommand{\Igumnov}{Igumnov%
    \protect\index[ndxnames]{Igumnov, Konstantin Nikolaevič}}
\newcommand{\KIgumnov}{Konstantin \Igumnov}
%%
\newcommand{\Johansson}{Johansson%
    \protect\index[ndxnames]{Johansson, Christian}}
\newcommand{\CJohansson}{Christian \Johansson}
%%
\newcommand{\Kabalevski}{Kabalevskij%
    \protect\index[ndxnames]{Kabalevskij, Dmitrij Borisovič}}
\newcommand{\DKabalevski}{Dmitrij \Kabalevski}
%%
\newcommand{\Kalinenko}{Kalinenko%
    \protect\index[ndxnames]{Kalinenko, Nina Maksimovna}}
\newcommand{\NKalinenko}{Nina \Kalinenko}
%%
\newcommand{\Kamensky}{Kamenskij%
    \protect\index[ndxnames]{Kamenskij, Aleksandr Danilovič}}
\newcommand{\AKamensky}{Aleksandr \Kamensky}
%%
\newcommand{\Karatigine}{Karatygin%
    \protect\index[ndxnames]{Karatygin, Vjačeslav Gavrilovič}}
\newcommand{\VKaratigine}{Vjačeslav \Karatigine}
%%
\newcommand{\Kochkina}{Kočkina%
    \protect\index[ndxnames]{Kočkina, Valentina Ivanovna}}
\newcommand{\VKochkina}{Valentina \Kochkina}
%%
\newcommand{\KoganSofronitskaya}{Kogan-Sofronickaja%
    \protect\index[ndxnames]{Kogan-Sofronickaja, Roksana Vladimirovna}}
\newcommand{\RKoganSofronitskaya}{Roksana \KoganSofronitskaya}
%%
\newcommand{\Konchalovsky}{Končalovskij%
    \protect\index[ndxnames]{Končalovskij, Andrej Sergeevič}}
\newcommand{\AKonchalovsky}{Andrej \Konchalovsky}
%%
\newcommand{\MKonchalovsky}{Maksim Končalovskij%
    \protect\index[ndxnames]{Končalovskij, Maksim Vladimirovič}}
%%
\newcommand{\Kopper}{Kopper%
    \protect\index[ndxnames]{Kopper, J.}}
\newcommand{\JKopper}{J.\@~\Kopper}
%%
\newcommand{\Korsakova}{Korsakova%
    \protect\index[ndxnames]{Korsakova, Nina Nikolaevna}}
\newcommand{\NKorsakova}{Nina \Korsakova}
%%
\newcommand{\Krioukov}{Krjukov%
    \protect\index[ndxnames]{Krjukov, Vladimir Nikolaevič}}
\newcommand{\VKrioukov}{Vladimir \Krioukov}
%%
\newcommand{\Lebedeva}{Lebedeva%
    \protect\index[ndxnames]{Lebedeva, Marina Nikolaevna}}
\newcommand{\MLebedeva}{Marina \Lebedeva}
%%
\newcommand{\LebedevaGetsevich}{Lebedeva-Gecevič%
    \protect\index[ndxnames]{Lebedeva-Gecevič, Anna Vasil'evna}}
\newcommand{\ALebedevaGetsevich}{Anna \LebedevaGetsevich}
%%
\newcommand{\Lenin}{Lenin%
    \protect\index[ndxnames]{Lenin, Vladimir Il'ič}}
\newcommand{\VLenin}{Vladimir \Lenin}
%%
\newcommand{\Liadov}{Ljadov%
    \protect\index[ndxnames]{Ljadov, Anatolij Konstantinovič}}
\newcommand{\ALiadov}{Anatolij \Liadov}
%%
\newcommand{\Liapounov}{Ljapunov%
    \protect\index[ndxnames]{Ljapunov, Sergej Michajlovič}}
\newcommand{\SLiapounov}{Sergej \Liapounov}
%%
\newcommand{\Lipskerov}{Lipskerov%
    \protect\index[ndxnames]{Lipskerov, Konstantin Abramovič}}
\newcommand{\KLipskerov}{Konstantin \Lipskerov}
%%
\newcommand{\Liszt}{Liszt%
    \protect\index[ndxnames]{Liszt, Ferenc}}
\newcommand{\FLiszt}{Ferenc \Liszt}
%%
\newcommand{\Lobanov}{Lobanov%
    \protect\index[ndxnames]{Lobanov, Pavel Vasil'evič}}
\newcommand{\PLobanov}{Pavel \Lobanov}
%%
\newcommand{\Malik}{Malik%
    \protect\index[ndxnames]{Malik, Farhan}}
\newcommand{\FMalik}{Farhan \Malik}
%%
\newcommand{\Malko}{Malko%
    \protect\index[ndxnames]{Malko, Nikolaj Andreevič}}
\newcommand{\NMalko}{Nikolaj \Malko}
%%
\newcommand{\Martinov}{Martynov%
    \protect\index[ndxnames]{Martynov, Ivan Ivanovič}}
\newcommand{\IMartinov}{Ivan \Martinov}
%%
\newcommand{\Medtner}{Metner%
    \protect\index[ndxnames]{Metner, Nikolaj Karlovič}}
\newcommand{\NMedtner}{Nikolaj \Medtner}
%%
\newcommand{\Mendelssohn}{Mendelssohn-Bartholdy%
    \protect\index[ndxnames]{Mendelssohn-Bartholdy, Felix}}
\newcommand{\FMendelssohn}{Felix \Mendelssohn}
%%
\newcommand{\Merzhanov}{Meržanov%
    \protect\index[ndxnames]{Meržanov, Viktor Karpovič}}
\newcommand{\VMerzhanov}{Viktor \Merzhanov}
%%
\newcommand{\Meyerhold}{Mejerchol'd%
    \protect\index[ndxnames]{Mejerchol'd, Vsevolod Èmil'evič}}
\newcommand{\VMeyerhold}{Vsevolod \Meyerhold}
%%
\newcommand{\Miaskovski}{Mjaskovskij%
    \protect\index[ndxnames]{Mjaskovskij, Nikolaj Jakovlevič}}
\newcommand{\NMiaskovski}{Nikolaj \Miaskovski}
%%
\newcommand{\Michalowski}{Michalovskij%
    \protect\index[ndxnames]{Michalovskij, Aleksandr Konstantinovič}}
\newcommand{\AMichalowski}{Aleksandr \Michalowski}
%%
\newcommand{\Miklashevsky}{Miklaševskij%
    \protect\index[ndxnames]{Miklaševskij, Igor' Sergeevič}}
\newcommand{\IMiklashevsky}{Igor' \Miklashevsky}
%%
\newcommand{\Moscheles}{Moscheles%
    \protect\index[ndxnames]{Moscheles, Ignaz}}
\newcommand{\IMoscheles}{Ignaz \Moscheles}
%%
\newcommand{\Mourgue}{Mourgue%
    \protect\index[ndxnames]{Mourgue, Marie-Françoise}}
\newcommand{\MMourgue}{Marie-Françoise \Mourgue}
%%
\newcommand{\Moussorgski}{Musorgskij%
    \protect\index[ndxnames]{Musorgskij, Modest Petrovič}}
\newcommand{\MMoussorgski}{Modest \Moussorgski}
%%
\newcommand{\Mozart}{Mozart%
    \protect\index[ndxnames]{Mozart, Wolfgang Amadeus}}
\newcommand{\WMozart}{Wolfgang Amadeus \Mozart}
%%
\newcommand{\Musatov}{Musatov%
    \protect\index[ndxnames]{Musatov, Konstantin Vladimirovič}}
\newcommand{\KMusatov}{Konstantin \Musatov}
%%
\newcommand{\Naumov}{Naumov%
    \protect\index[ndxnames]{Naumov, Lev Nikolaevič}}
\newcommand{\LNaumov}{Lev \Naumov}
%%
\newcommand{\Nekrasova}{Nekrasova%
    \protect\index[ndxnames]{Nekrasova, Varvara Borisovna}}
\newcommand{\VNekrasova}{Varvara \Nekrasova}
%%
\newcommand{\Neuhaus}{Nejgauz%
    \protect\index[ndxnames]{Nejgauz, Genrich Gustavovič}}
\newcommand{\HNeuhaus}{Genrich \Neuhaus}
%%
\newcommand{\Nikolaiev}{Nikolaev%
    \protect\index[ndxnames]{Nikolaev, Leonid Vladimirovič}}
\newcommand{\LNikolaiev}{Leonid \Nikolaiev}
%%
\newcommand{\Nikonovich}{Nikonovič%
    \protect\index[ndxnames]{Nikonovič, Igor' Vladimirovič}}
\newcommand{\INikonovich}{Igor' \Nikonovich}
%%
\newcommand{\Nudelman}{Nudel'man%
    \protect\index[ndxnames]{Nudel'man, Dina Èmmanuilovna}}
\newcommand{\DNudelman}{Dina \Nudelman}
%%
\newcommand{\Oborine}{Oborin%
    \protect\index[ndxnames]{Oborin, Lev Nikolaevič}}
\newcommand{\LOborine}{Lev \Oborine}
%%
\newcommand{\Orlovsky}{Orlovskij%
    \protect\index[ndxnames]{Orlovskij, Vladimir Vladimirovič}}
\newcommand{\VOrlovsky}{Vladimir \Orlovsky}
%%
\newcommand{\Pabst}{Pabst%
    \protect\index[ndxnames]{Pabst, Pavel Avgustovič}}
\newcommand{\PPabst}{Pavel \Pabst}
%%
\newcommand{\Pachelbel}{Pachelbel%
    \protect\index[ndxnames]{Pachelbel, Johann}}
\newcommand{\JPachelbel}{Johann \Pachelbel}
%%
\newcommand{\Paderewski}{Paderewski%
    \protect\index[ndxnames]{Paderewski, Ignacy Jan}}
\newcommand{\IPaderewski}{Ignacy \Paderewski}
%%
\newcommand{\Paganini}{Paganini%
    \protect\index[ndxnames]{Paganini, Niccolo}}
\newcommand{\NPaganini}{Niccolo \Paganini}
%%
\newcommand{\Pasternak}{Pasternak%
    \protect\index[ndxnames]{Pasternak, Boris Leonidovič}}
\newcommand{\BPasternak}{Boris \Pasternak}
%%
\newcommand{\Petropavlov}{Petropavlov%
    \protect\index[ndxnames]{Petropavlov, Andrej Grigor'evič}}
\newcommand{\APetropavlov}{Andrej \Petropavlov}
%%
\newcommand{\Pleyel}{Pleyel%
    \protect\index[ndxnames]{Pleyel, Ignace}}
\newcommand{\IPleyel}{Ignace \Pleyel}
%%
\newcommand{\Pollini}{Pollini%
    \protect\index[ndxnames]{Pollini, Maurizio}}
\newcommand{\MPollini}{Maurizio \Pollini}
%%
\newcommand{\Pouchkine}{Puškin%
    \protect\index[ndxnames]{Puškin, Aleksandr Sergeevič}}
\newcommand{\APouchkine}{Aleksandr \Pouchkine}
%%
\newcommand{\Poulenc}{Poulenc%
    \protect\index[ndxnames]{Poulenc, Francis}}
\newcommand{\FPoulenc}{Francis \Poulenc}
%%
\newcommand{\Prokofiev}{Prokof'ev%
    \protect\index[ndxnames]{Prokof'ev, Sergej Sergeevič}}
\newcommand{\SProkofiev}{Sergej \Prokofiev}
%%
\newcommand{\Quonten}{Quonten%
    \protect\index[ndxnames]{Quonten, René}}
\newcommand{\RQuonten}{René \Quonten}
%%
\newcommand{\Rabinovitch}{Rabinovič%
    \protect\index[ndxnames]{Rabinovič, David Abramovič}}
\newcommand{\DRabinovitch}{David \Rabinovitch}
%%
\newcommand{\Rachmaninov}{Rachmaninov%
    \protect\index[ndxnames]{Rachmaninov, Sergej Vasil'evič}}
\newcommand{\SRachmaninov}{Sergej \Rachmaninov}
%%
\newcommand{\Rakhline}{Rachlin%
    \protect\index[ndxnames]{Rachlin, Natan Grigor'evič}}
\newcommand{\NRakhline}{Natan \Rakhline}
%%
\newcommand{\Ravel}{Ravel%
    \protect\index[ndxnames]{Ravel, Maurice}}
\newcommand{\MRavel}{Maurice \Ravel}
%%
\newcommand{\Richter}{Richter%
    \protect\index[ndxnames]{Richter, Svjatoslav Teofilovič}}
\newcommand{\SRichter}{Svjatoslav \Richter}
%%
\newcommand{\Riemann}{Riemann%
    \protect\index[ndxnames]{Riemann, Hugo}}
\newcommand{\HRiemann}{Hugo \Riemann}
%%
\newcommand{\RimskiKorsakov}{Rimskij-Korsakov%
    \protect\index[ndxnames]{Rimskij-Korsakov, Nikolaj Andreevič}}
\newcommand{\NRimskiKorsakov}{Nikolaj \RimskiKorsakov}
%%
\newcommand{\Rossi}{Rossi%
    \protect\index[ndxnames]{Rossi, Andrea}}
\newcommand{\ARossi}{Andrea \Rossi}
%%
\newcommand{\Rubinstein}{Rubinštejn%
    \protect\index[ndxnames]{Rubinštejn, Anton Grigor'evič}}
\newcommand{\ARubinstein}{Anton \Rubinstein}
%%
\newcommand{\Ryzhik}{Ryzhik%
    \protect\index[ndxnames]{Ryzhik, Lenya}}
\newcommand{\LRyzhik}{Lenya \Ryzhik}
%%
\newcommand{\Shafran}{Šafran%
    \protect\index[ndxnames]{Šafran, Daniil Borisovič}}
\newcommand{\DShafran}{Daniil \Shafran}
%%
\newcommand{\SaintSaens}{Saint-Saëns%
    \protect\index[ndxnames]{Saint-Saëns, Camille}}
\newcommand{\CSaintSaens}{Camille \SaintSaens}
%%
\newcommand{\Savshinsky}{Savšinskij%
    \protect\index[ndxnames]{Savšinskij, Samarij Il'ič}}
\newcommand{\SSavshinsky}{Samarij \Savshinsky}
%%
\newcommand{\Scarlatti}{Scarlatti%
    \protect\index[ndxnames]{Scarlatti, Domenico}}
\newcommand{\DScarlatti}{Domenico \Scarlatti}
%%
\newcommand{\Scheen}{Scheen%
    \protect\index[ndxnames]{Scheen, Christian}}
\newcommand{\CScheen}{Christian \Scheen}
%%
\newcommand{\Schnabel}{Schnabel%
    \protect\index[ndxnames]{Schnabel, Artur}}
\newcommand{\ASchnabel}{Artur \Schnabel}
%%
\newcommand{\Schubert}{Schubert%
    \protect\index[ndxnames]{Schubert, Franz}}
\newcommand{\FSchubert}{Franz \Schubert}
%%
\newcommand{\Schumann}{Schumann%
    \protect\index[ndxnames]{Schumann, Robert}}
\newcommand{\RSchumann}{Robert \Schumann}
%%
\newcommand{\Scriabine}{Skrjabin%
    \protect\index[ndxnames]{Skrjabin, Aleksandr Nikolaevič}}
\newcommand{\AScriabine}{Aleksandr \Scriabine}
%%
\newcommand{\ASScriabine}{Aleksandr Serafimovič Skrjabin%
    \protect\index[ndxnames]{Skrjabin, Aleksandr Serafimovič}}
%%
\newcommand{\Scriabina}{Skrjabina}
%%
\newcommand{\EScriabina}{Elena Aleksandrovna \Scriabina%
    \protect\index[ndxnames]{Skrjabina, Elena Aleksandrovna}}
%%
\newcommand{\VScriabina}{Vera Ivanovna \Scriabina%
    \protect\index[ndxnames]{Skrjabina, Vera Ivanovna}}
%%
\newcommand{\Serov}{Serov%
    \protect\index[ndxnames]{Serov, Dmitrij Michajlovič}}
\newcommand{\DSerov}{Dmitrij \Serov}
%%
\newcommand{\Shirinsky}{Širinskij%
    \protect\index[ndxnames]{Širinskij, Sergej Petrovič}}
\newcommand{\SShirinsky}{Sergej \Shirinsky}
%%
\newcommand{\Slivinsky}{Slivinskij%
    \protect\index[ndxnames]{Slivinskij, Vladimir Ričardovič}}
\newcommand{\VSlivinsky}{Vladimir \Slivinsky}
%%
\newcommand{\ESofronitskaya}{Elena Aleksandrovna Sofronickaja%
    \protect\index[ndxnames]{Sofronickaja, Elena Aleksandrovna}}
%%
\newcommand{\ISofronitskaya}{Irina Ivanovna Sofronickaja%
    \protect\index[ndxnames]{Sofronickaja, Irina Ivanovna}}
%%
\newcommand{\VSofronitskaya}{Valentina Nikolaevna Sofronickaja%
    \protect\index[ndxnames]{Sofronickaja, Valentina Nikolaevna}}
%%
\newcommand{\ASofronitsky}{Aleksandr Vladimirovič Sofronickij%
    \protect\index[ndxnames]{Sofronickij, Aleksandr Vladimirovič}}
%%
\newcommand{\Sofronitsky}{Sofronickij%
    \protect\index[ndxnames]{Sofronickij, Vladimir Vladimirovič}}
\newcommand{\VSofronitsky}{Vladimir \Sofronitsky}
%%
\newcommand{\Sosina}{Sosina%
    \protect\index[ndxnames]{Sosina, Ljudmila Aleksandrovna}}
\newcommand{\LSosina}{Ljudmila \Sosina}
%%
\newcommand{\Staline}{Stalin%
    \protect\index[ndxnames]{Stalin, Iosif Vissarionovič}}
\newcommand{\JStaline}{Iosif \Staline}
%%
\newcommand{\Sviatlovskaya}{Svjatlovskaja%
    \protect\index[ndxnames]{Svjatlovskaja, V. M.}}
\newcommand{\VSviatlovskaya}{V.\@~M.\@~\Sviatlovskaya}
%%
\newcommand{\Taneiev}{Taneev%
    \protect\index[ndxnames]{Taneev, Sergej Ivanovič}}
\newcommand{\STaneiev}{Sergej \Taneiev}
%%
\newcommand{\Taylor}{Taylor%
    \protect\index[ndxnames]{Taylor, Peter}}
\newcommand{\PTaylor}{Peter \Taylor}
%%
\newcommand{\Tchaikovski}{Čajkovskij%
    \protect\index[ndxnames]{Čajkovskij, Pëtr Il'ič}}
\newcommand{\PTchaikovski}{Pëtr \Tchaikovski}
%%
\newcommand{\Trazevskaya}{Tracevskaja%
    \protect\index[ndxnames]{Tracevskaja, Ol'ga Michajlovna}}
\newcommand{\OTrazevskaya}{Ol'ga \Trazevskaya}
%%
\newcommand{\Tziganov}{Cyganov%
    \protect\index[ndxnames]{Cyganov, Dmitrij Michajlovič}}
\newcommand{\DTziganov}{Dmitrij \Tziganov}
%%
\newcommand{\AVizel}{Aleksandra Èmil'evna Vizel'%
    \protect\index[ndxnames]{Vizel', Aleksandra Èmil'evna}}
%%
\newcommand{\Vizel}{Vizel'%
    \protect\index[ndxnames]{Vizel', Èmil' Oskarovič}}
\newcommand{\EVizel}{Èmil' \Vizel}
%%
\newcommand{\Voskobojnikov}{Voskobojnikov%
    \protect\index[ndxnames]{Voskobojnikov, Valerij Michajlovič}}
\newcommand{\VVoskobojnikov}{Valerij \Voskobojnikov}
%%
\newcommand{\Wagner}{Wagner%
    \protect\index[ndxnames]{Wagner, Richard}}
\newcommand{\RWagner}{Richard \Wagner}
%%
\newcommand{\White}{White%
    \protect\index[ndxnames]{White, Emily}}
\newcommand{\EWhite}{Emily \White}
%%
\newcommand{\Wieck}{Wieck%
    \protect\index[ndxnames]{Wieck, Clara}}
\newcommand{\CWieck}{Clara \Wieck}
%%
\newcommand{\Yourenev}{Jurenev%
    \protect\index[ndxnames]{Jurenev, Rostislav Nikolaevič}}
\newcommand{\RYourenev}{Rostislav \Yourenev}
%%
\newcommand{\Yudina}{Judina%
    \protect\index[ndxnames]{Judina, Marija Veniaminovna}}
\newcommand{\MYudina}{Marija \Yudina}
%%
\newcommand{\Zak}{Zak%
    \protect\index[ndxnames]{Zak, Jakov Izrailevič}}
\newcommand{\YZak}{Jakov \Zak}
%%
\newcommand{\Zhukova}{Žukova%
    \protect\index[ndxnames]{Žukova, Ol'ga Michajlovna}}
\newcommand{\OZhukova}{Ol'ga \Zhukova}
%%
\newcommand{\Ziloti}{Ziloti%
    \protect\index[ndxnames]{Ziloti, Aleksandr Il'ič}}
\newcommand{\AZiloti}{Aleksandr \Ziloti}
%%
\newcommand{\Zochtchenko}{Zoščenko%
    \protect\index[ndxnames]{Zoščenko, Michail Michajlovič}}
\newcommand{\MZochtchenko}{Michail \Zochtchenko}
%%
\newcommand{\Zolotov}{Zolotov%
    \protect\index[ndxnames]{Zolotov, Andrej Andreevič}}
\newcommand{\AZolotov}{Andrej \Zolotov}
%%
\newcommand{\Zhuravlev}{Žuravlev%
    \protect\index[ndxnames]{Žuravlev, Dmitrij Nikolaevič}}
\newcommand{\DZhuravlev}{Dmitrij \Zhuravlev}
%%
%%
%% Scientific transliteration and French transcription
%% ---------------------------------------------------
%%
\AtBeginDocument{%
    \index[ndxnames]{Džugašvili, Iosif Vissarionovič|see{Stalin, Iosif Vissarionovič}}
    \index[ndxnames]{Fejgina, Nina Maksimovna|see{Kalinenko, Nina Maksimovna}}
    \index[ndxnames]{Kalinenko, Nina Maksimovna|see{Fejgina, Nina Maksimovna}}
    \index[ndxnames]{Ul'janov, Vladimir Il'ič|see{Lenin, Vladimir Il'ič}}
    \index[ndxnames]{Aliavdina, Anna A.|see{Aljavdina, Anna A.}}
    \index[ndxnames]{Bachkirov, Dmitri Aleksandrovitch|see{Baškirov, Dmitrij Aleksandrovič}}
    \index[ndxnames]{Badeïan, Tamara Gueorguievna|see{Badejan, Tamara Georgievna}}
    \index[ndxnames]{Balakirev, Mili Alekseïevitch|see{Balakirev, Milij Alekseevič}}
    \index[ndxnames]{Benditski, Semen Solomonovitch|see{Bendickij, Semen Solomonovič}}
    \index[ndxnames]{Berdiaïev, Valerian Valerianovitch|see{Berdjaev, Valerian Valerianovič}}
    \index[ndxnames]{Berman, Lazar Naoumovitch|see{Berman, Lazar' Naumovič}}
    \index[ndxnames]{Bernblioum, Tina Mikhaïlovna|see{Bernbljum, Tina Michajlovna}}
    \index[ndxnames]{Blok, Aleksandr Aleksandrovitch|see{Blok, Aleksandr Aleksandrovič}}
    \index[ndxnames]{Blumenfeld, Felix Mikhaïlovitch|see{Blumenfel'd, Feliks Michajlovič}}
    \index[ndxnames]{Bochniakovitch, Oleg Dragomirovitch|see{Bošnjakovič, Oleg Dragomirovič}}
    \index[ndxnames]{Bogdanov-Berezovski, Valerian Mikhaïlovitch|see{Bogdanov-Berezovskij, Valerian Michajlovič}}
    \index[ndxnames]{Borissov, Iouri Albertovitch|see{Borisov, Jurij Al'bertovič}}
    \index[ndxnames]{Borodine, Aleksandr Porfirievitch|see{Borodin, Aleksandr Porfir'evič}}
    \index[ndxnames]{Bortnianski, Dmitri Stepanovitch|see{Bortnjanskij, Dmitrij Stepanovič}}
    \index[ndxnames]{Braoudo, Issaïa Aleksandrovitch|see{Braudo, Isajja Aleksandrovič}}
    \index[ndxnames]{Chafran, Daniil Borissovitch|see{Šafran, Daniil Borisovič}}
    \index[ndxnames]{Chirinski, Sergueï Petrovitch|see{Širinskij, Sergej Petrovič}}
    \index[ndxnames]{Chostakovitch, Dmitri Dmitrievitch|see{Šostakovič, Dmitrij Dmitrievič}}
    \index[ndxnames]{Chtcherbatchiov, Vladimir Vladimirovitch|see{Ščerbačëv, Vladimir Vladimirovič}}
    \index[ndxnames]{Cliburn, Harvey Lavan|see{Van~Cliburn (Harvey Lavan Jr.)}}
    \index[ndxnames]{Cooper, Emil Albertovitch|see{Kuper, Èmilij Al'bertovič}}
    \index[ndxnames]{Dedioukhine, Aleksandr Aleksandrovitch|see{Dedjuchin, Aleksandr Aleksandrovič}}
    \index[ndxnames]{Dedioukina, Lioudmila Alekseïevna|see{Dedjukina, Ljudmila Alekseevna}}
    \index[ndxnames]{Douchinova, Valentina Nikolaïevna|see{Dušinova, Valentina Nikolaevna}}
    \index[ndxnames]{Doukelski, Vladimir Aleksandrovitch|see{Dukel'skij, Vladimir Aleksandrovič}}
    \index[ndxnames]{Feïguina, Nina Maksimovna|see{Fejgina, Nina Maksimovna}}
    \index[ndxnames]{Feïnberg, Samouïl Ievguenievitch|see{Fejnberg, Samuil Evgen'evič}}
    \index[ndxnames]{Fikhtengolts, Lidia Izraïlevna|see{Fichtengol'c, Lidija Izrailevna}}
    \index[ndxnames]{Gakkel, Leonid Ievguenievitch|see{Gakkel', Leonid Evgen'evič}}
    \index[ndxnames]{Gaouk, Aleksandr Vassilievitch|see{Gauk, Aleksandr Vasil'evič}}
    \index[ndxnames]{Glazounov, Aleksandr Konstantinovitch|see{Glazunov, Aleksandr Konstantinovič}}
    \index[ndxnames]{Glinka, Mikhaïl Ivanovitch|see{Glinka, Michail Ivanovič}}
    \index[ndxnames]{Goloubovskaïa, Nadejda Iossifovna|see{Golubovskaja, Nadežda Iosifovna}}
    \index[ndxnames]{Golts, Boris Grigorievitch|see{Gol'c, Boris Grigor'evič}}
    \index[ndxnames]{Gornostaïeva, Vera Vassilievna|see{Gornostaeva, Vera Vasil'evna}}
    \index[ndxnames]{Grigorian, Djoulietta Armenovna|see{Grigorjan, Džul'etta Armenovna}}
    \index[ndxnames]{Guilels, Emil Grigorievitch|see{Gilel's, Èmil' Grigor'evič}}
    \index[ndxnames]{Guinzbourg, Grigori Romanovitch|see{Ginzburg, Grigorij Romanovič}}
    \index[ndxnames]{Igoumnov, Konstantin Nikolaïevitch|see{Igumnov, Konstantin Nikolaevič}}
    \index[ndxnames]{Ioudina, Maria Veniaminovna|see{Judina, Marija Veniaminovna}}
    \index[ndxnames]{Iourenev, Rostislav Nikolaïevitch|see{Jurenev, Rostislav Nikolaevič}}
    \index[ndxnames]{Joukova, Olga Mikhaïlovna|see{Žukova, Ol'ga Michajlovna}}
    \index[ndxnames]{Jouravlev, Dmitri Nikolaïevitch|see{Žuravlev, Dmitrij Nikolaevič}}
    \index[ndxnames]{Kabalevski, Dmitri Borissovitch|see{Kabalevskij, Dmitrij Borisovič}}
    \index[ndxnames]{Karatyguine, Viatcheslav Gavrilovitch|see{Karatygin, Vjačeslav Gavrilovič}}
    \index[ndxnames]{Kogan-Sofronitskaïa, Roksana Vladimirovna|see{Kogan-Sofronickaja, Roksana Vladimirovna}}
    \index[ndxnames]{Kontchalovski, Andreï Sergueïevitch|see{Končalovskij, Andrej Sergeevič}}
    \index[ndxnames]{Kontchalovski, Maksim Vladimirovitch|see{Končalovskij, Maksim Vladimirovič}}
    \index[ndxnames]{Korsakova, Nina Nikolaïevna|see{Korsakova, Nina Nikolaevna}}
    \index[ndxnames]{Kotchkina, Valentina Ivanovna|see{Kočkina, Valentina Ivanovna}}
    \index[ndxnames]{Kouper, Emili Albertovitch|see{Kuper, Èmilij Al'bertovič}}
    \index[ndxnames]{Krioukov, Vladimir Nikolaïevitch|see{Krjukov, Vladimir Nikolaevič}}
    \index[ndxnames]{Lebedeva-Guetsevitch, Anna Vassilievna|see{Lebedeva-Gecevič, Anna Vasil'evna}}
    \index[ndxnames]{Lebedeva, Marina Nikolaïevna|see{Lebedeva, Marina Nikolaevna}}
    \index[ndxnames]{Liadov, Anatoli Konstantinovitch|see{Ljadov, Anatolij Konstantinovič}}
    \index[ndxnames]{Liapounov, Sergueï Mikhaïlovitch|see{Ljapunov, Sergej Michajlovič}}
    \index[ndxnames]{Lobanov, Pavel Vassilievitch|see{Lobanov, Pavel Vasil'evič}}
    \index[ndxnames]{Malko, Nikolaï Andreïevitch|see{Malko, Nikolaj Andreevič}}
    \index[ndxnames]{Martynov, Ivan Ivanovitch|see{Martynov, Ivan Ivanovič}}
    \index[ndxnames]{Medtner, Nikolaï Karlovitch|see{Metner, Nikolaj Karlovič}}
    \index[ndxnames]{Merjanov, Viktor Karpovitch|see{Meržanov, Viktor Karpovič}}
    \index[ndxnames]{Meyerhold, Vsevolod Emilievitch|see{Mejerchol'd, Vsevolod Èmil'evič}}
    \index[ndxnames]{Miaskovski, Nikolaï Iakovlevitch|see{Mjaskovskij, Nikolaj Jakovlevič}}
    \index[ndxnames]{Michałowski, Aleksandr Konstantinovitch|see{Michalovskij, Aleksandr Konstantinovič}}
    \index[ndxnames]{Miklachevski, Igor Sergueïevitch|see{Miklaševskij, Igor' Sergeevič}}
    \index[ndxnames]{Moussatov, Konstantin Vladimirovitch|see{Musatov, Konstantin Vladimirovič}}
    \index[ndxnames]{Moussorgski, Modeste Petrovitch|see{Musorgskij, Modest Petrovič}}
    \index[ndxnames]{Naoumov, Lev Nikolaïevitch|see{Naumov, Lev Nikolaevič}}
    \index[ndxnames]{Nekrassova, Varvara Borissovna|see{Nekrasova, Varvara Borisovna}}
    \index[ndxnames]{Neuhaus, Heinrich Goustavovitch|see{Nejgauz, Genrich Gustavovič}}
    \index[ndxnames]{Nikolaïev, Leonid Vladimirovitch|see{Nikolaev, Leonid Vladimirovič}}
    \index[ndxnames]{Nikonovitch, Igor Vladimirovitch|see{Nikonovič, Igor' Vladimirovič}}
    \index[ndxnames]{Noudelman, Dina Emmanouïlovna|see{Nudel'man, Dina Èmmanuilovna}}
    \index[ndxnames]{Oborine, Lev Nikolaïevitch|see{Oborin, Lev Nikolaevič}}
    \index[ndxnames]{Orlovski, Vladimir Vladimirovitch|see{Orlovskij, Vladimir Vladimirovič}}
    \index[ndxnames]{Pabst, Pavel Avgoustovitch|see{Pabst, Pavel Avgustovič}}
    \index[ndxnames]{Pasternak, Boris Leonidovitch|see{Pasternak, Boris Leonidovič}}
    \index[ndxnames]{Petropavlov, Andreï Grigorievitch|see{Petropavlov, Andrej Grigor'evič}}
    \index[ndxnames]{Pouchkine, Aleksandr Sergueïevitch|see{Puškin, Aleksandr Sergeevič}}
    \index[ndxnames]{Prokofiev, Sergueï Sergueïevitch|see{Prokof'ev, Sergej Sergeevič}}
    \index[ndxnames]{Rabinovitch, David Abramovitch|see{Rabinovič, David Abramovič}}
    \index[ndxnames]{Rachmaninov, Sergueï Vassilievitch|see{Rachmaninov, Sergej Vasil'evič}}
    \index[ndxnames]{Rakhline, Natan Grigorievitch|see{Rachlin, Natan Grigor'evič}}
    \index[ndxnames]{Richter, Sviatoslav Teofilovitch|see{Richter, Svjatoslav Teofilovič}}
    \index[ndxnames]{Rimski-Korsakov, Nikolaï Andreïevitch|see{Rimskij-Korsakov, Nikolaj Andreevič}}
    \index[ndxnames]{Rubinstein, Anton Grigorievitch|see{Rubinštejn, Anton Grigor'evič}}
    \index[ndxnames]{Savchinski, Samari Ilitch|see{Savšinskij, Samarij Il'ič}}
    \index[ndxnames]{Scriabina, Ielena Aleksandrovna|see{Skrjabina, Elena Aleksandrovna}}
    \index[ndxnames]{Scriabina, Vera Ivanovna|see{Skrjabina, Vera Ivanovna}}
    \index[ndxnames]{Scriabine, Aleksandr Nikolaïevitch|see{Skrjabin, Aleksandr Nikolaevič}}
    \index[ndxnames]{Scriabine, Aleksandr Serafimovitch|see{Skrjabin, Aleksandr Serafimovič}}
    \index[ndxnames]{Slivinski, Vladimir Ritchardovitch|see{Slivinskij, Vladimir Ričardovič}}
    \index[ndxnames]{Sofronitskaïa, Ielena Aleksandrovna|see{Sofronickaja, Elena Aleksandrovna}}
    \index[ndxnames]{Sofronitskaïa, Irina Ivanovna|see{Sofronickaja, Irina Ivanovna}}
    \index[ndxnames]{Sofronitskaïa, Valentina Nikolaïevna|see{Sofronickaja, Valentina Nikolaevna}}
    \index[ndxnames]{Sofronitski, Aleksandr Vladimirovitch|see{Sofronickij, Aleksandr Vladimirovič}}
    \index[ndxnames]{Sofronitski, Vladimir Vladimirovitch|see{Sofronickij, Vladimir Vladimirovič}}
    \index[ndxnames]{Sossina, Lioudmila Aleksandrovna|see{Sosina, Ljudmila Aleksandrovna}}
    \index[ndxnames]{Staline, Iossif Vissarionovitch|see{Stalin, Iosif Vissarionovič}}
    \index[ndxnames]{Sviatlovskaïa, V. M.|see{Svjatlovskaja, V. M.}}
    \index[ndxnames]{Taneïev, Sergueï Ivanovitch|see{Taneev, Sergej Ivanovič}}
    \index[ndxnames]{Tchaïkovski, Piotr Ilitch|see{Čajkovskij, Pëtr Il'ič}}
    \index[ndxnames]{Tchinaïev, Vladimir Petrovitch|see{Činaev, Vladimir Petrovič}}
    \index[ndxnames]{Tratsevskaïa, Olga Mikhaïlovna|see{Tracevskaja, Ol'ga Michajlovna}}
    \index[ndxnames]{Tsyganov, Dmitri Mikhaïlovitch|see{Cyganov, Dmitrij Michajlovič}}
    \index[ndxnames]{Vizel, Aleksandra Emilievna|see{Vizel', Aleksandra Èmil'evna}}
    \index[ndxnames]{Vizel, Emil Oskarovitch|see{Vizel', Èmil' Oskarovič}}
    \index[ndxnames]{Voskoboïnikov, Valeri Mikhaïlovitch|see{Voskobojnikov, Valerij Michajlovič}}
    \index[ndxnames]{Zak, Iakov Izraïlevitch|see{Zak, Jakov Izrailevič}}
    \index[ndxnames]{Ziloti, Aleksandr Ilitch|see{Ziloti, Aleksandr Il'ič}}
    \index[ndxnames]{Zochtchenko, Mikhaïl Mikhaïlovitch|see{Zoščenko, Michail Michajlovič}}
    \index[ndxnames]{Zolotov, Andreï Andreïevitch|see{Zolotov, Andrej Andreevič}}}
%%
%%
%% Deferred code execution
%% -----------------------
%%
\AtBeginDocument{%
    \overfullrule=5pt
    \lefthyphenmin=3
    \righthyphenmin=3
    \uchyph=-1
    \emergencystretch=3em
    \tolerance=9999
    \clubpenalty=10000
    \widowpenalty=10000
    \displaywidowpenalty=10000
    \predisplaypenalty=10000
    \postdisplaypenalty=50
    \brokenpenalty=10000
    \binoppenalty=10000
    \relpenalty=10000
    \finalhyphendemerits=4000000
    \hbadness=2500
    \vbadness=1000}
%%
%%
%% End of document class
%% ---------------------
%%
\endinput
