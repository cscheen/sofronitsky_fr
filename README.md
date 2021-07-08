# Vladimir Sofronitsky

## Sommaire

1.  [Introduction](#introduction)
2.  [Discographie au format PDF](#discographie-au-format-pdf)
3.  [Compilation des sources](#compilation-des-sources)
4.  [Contact](#contact)
5.  [Remerciements](#remerciements)
6.  [Licence](#licence)
7.  [Mentions légales](#mentions-legales)

## Introduction

Ce dépôt est consacré à une discographie du pianiste russe
[Vladimir Sofronitsky](https://fr.wikipedia.org/wiki/Vladimir_Sofronitsky).
Il comporte aussi une chronologie de l'activité de récital du musicien et
une bibliographie.
Le document est proposé sous la forme d'un fichier PDF et de ses sources.

Le fichier PDF est linéarisé (optimisé) pour un affichage efficient sur le
*Web*.
Sa compression est maximale.

Les sources du document peuvent être compilées avec le moteur de composition
typographique
[LuaTeX](http://luatex.org/),
le système de préparation de document et format
[LaTeX](https://www.latex-project.org/),
le système de composition de bibliographie
[BibLaTeX](https://github.com/plk/biblatex)
(avec le programme de traitement
[Biber](https://github.com/plk/biber))
et le programme d'indexation
[Xindy](http://www.xindy.org/).

## Discographie au format PDF

La discographie au format PDF peut être obtenue *via* le lien ci-dessous.

![PDF](https://github.com/cscheen/sofronitsky/blob/master/img/pdf.png)
[Discographie](https://github.com/cscheen/sofronitsky/blob/master/dvs.pdf)

Si vous souhaitez vérifier le téléchargement effectué, la somme de contrôle
SHA224 du fichier PDF se trouve dans le fichier `dvs.sha`, à employer avec
l'utilitaire
[sha224sum](https://www.gnu.org/software/coreutils/manual/coreutils.html).

## Compilation des sources

La liste antichronologique des modifications apportées aux sources du
document, à partir de la première version publique (2016-11-29), se trouve
dans le fichier `CHANGELOG.md`.

### Prérequis

Afin de compiler les sources, les logiciels suivants sont requis :

*   [LuaTeX](http://luatex.org/),
*   [LaTeX](https://www.latex-project.org/),
*   [BibLaTeX](https://github.com/plk/biblatex),
*   [Biber](https://github.com/plk/biber),
*   [Xindy](http://www.xindy.org/).

Le logiciel suivant est utile, mais non nécessaire :

*   [QPDF](https://github.com/qpdf/qpdf).

Les polices de caractères suivantes sont requises, au format OTF :

*   [Libertinus Serif](https://github.com/alerque/libertinus),
*   [Source Sans 3](https://github.com/adobe-fonts/source-sans),
*   [Source Code Pro](https://github.com/adobe-fonts/source-code-pro),
*   [Asana-Math](https://www.ctan.org/pkg/asana-math),
*   [CCIcons](https://github.com/ummels/ccicons).

Le plus simple est d'utiliser une distribution récente du système TeX, par
exemple
[TeX Live](http://www.tug.org/texlive/).
Le dépôt est testé et fonctionne avec la version 2021 de TeX Live.

### Compilation

Le fichier `MANIFEST.txt` indique la fonction de chaque source du document.

Si votre système d'exploitation ne reconnaît pas les liens symboliques,
alors il faudra sans doute recopier (ou déplacer) la classe de document
`dvs.cls` du sous-répertoire `cls/` vers la racine du dépôt :

```sh
cp -p cls/dvs.cls dvs.cls
```

On peut utiliser le *script* de *shell* `dvs.sh` (ou s'en inspirer).
Sinon, exécuter une première fois le programme `lualatex` sur le fichier
maître `dvs.tex`, après avoir établi un lien symbolique vers la classe de
document si votre système d'exploitation reconnaît de tels liens :

```sh
ln -s cls/dvs.cls dvs.cls
lualatex dvs.tex
```

puis quatre fois les programmes `biber`, `xindy` et `lualatex` (dans cet
ordre) sur leurs fichiers auxiliaires respectifs, afin de résoudre les
références croisées du texte, de la bibliographie et des index :

```sh
biber --isbn-normalise dvs.bcf
xindy -o dvs.inda -t dvs.ilga -C utf8 -L general -M xdy/dvs_a.xdy dvs.idxa
xindy -o dvs.indd -t dvs.ilgd -C utf8 -L general -M xdy/dvs_d.xdy dvs.idxd
xindy -o dvs.indn -t dvs.ilgn -C utf8 -L general -M xdy/dvs_n.xdy dvs.idxn
xindy -o dvs.indp -t dvs.ilgp -C utf8 -L general -M xdy/dvs_p.xdy dvs.idxp
xindy -o dvs.indu -t dvs.ilgu -C utf8 -L general -M xdy/dvs_u.xdy dvs.idxu
xindy -o dvs.indw -t dvs.ilgw -C utf8 -L general -M xdy/dvs_w.xdy dvs.idxw
lualatex dvs.tex
```

## Contact

Si vous souhaitez me contacter à propos de ce dépôt, le plus simple est de
poster un message *via* l'interface de GitHub afin de rapporter des erreurs
(*issues*) ou de demander des modifications (*pull requests*).

## Remerciements

Je remercie
[Farhan Malik](http://www.farhanmalik.com/)
de m'avoir autorisé à distribuer ce document sur le *Web* -- il n'existerait
pas sans la discographie préparée par Farhan Malik et publiée dans la revue
*International Piano Quarterly* (ISSN 1368-9770) en 1998.
Son autorisation ne signifie pas que Farhan Malik approuve ce document, et
je reste seul responsable des erreurs et omissions qui entachent mon
travail.

J'en profite pour inviter les lecteurs à me faire part de leurs remarques,
s'ils le souhaitent.
Des détails sont donnés ci-dessus, au paragraphe
[Contact](#contact).

## Licence

Sauf mention contraire explicite, les fichiers de ce dépôt sont sous la
licence *Creative Commons Attribution 4.0 International*
([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)).
Une copie du texte de la licence se trouve dans le fichier `LICENSE.txt`.

La seule exception concerne les fichiers qui permettent la compilation du
document à partir de ses sources.
Ces fichiers sont sous la licence *LaTeX Project Public License 1.3c*
([LPPL 1.3c](https://www.ctan.org/license/lppl1.3c)).
Les fichiers concernés sont la classe de document `cls/dvs.cls` et les six
styles d'index `xdy/dvs_*.xdy`.
Une copie du texte de la licence se trouve dans le fichier `LPPL.txt`.

## Crédits informatiques

Les logiciels utilisés afin de réaliser et compiler ce document sont les
suivants :

*   [Audacity](https://www.audacityteam.org/)
    (écoutes comparatives des sources audio),
*   [Sonic Visualiser](https://sonicvisualiser.org/)
    avec le greffon
    [MATCH](https://code.soundsoftware.ac.uk/projects/match-vamp)
    (écoutes comparatives des sources audio),
*   [Sonic Lineup](https://sonicvisualiser.org/sonic-lineup/index.html)
    (écoutes comparatives des sources audio),
*   [LuaTeX](http://luatex.org/)
    (moteur de composition typographique),
*   [LaTeX](https://www.latex-project.org/)
    (système de préparation de document et format),
*   [BibLaTeX](https://github.com/plk/biblatex)
    (système de composition de bibliographie),
*   [Biber](https://github.com/plk/biber)
    (programme de traitement de bibliographie),
*   [Xindy](http://www.xindy.org/)
    (programme d'indexation),
*   [QPDF](https://github.com/qpdf/qpdf)
    (programme de linéarisation ou optimisation de fichier PDF).
