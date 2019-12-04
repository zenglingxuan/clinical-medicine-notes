CURDIR := invocation_directory()
PDFCMD := "pandoc --filter pandoc-tablenos -s --filter pandoc-imagine --latex-engine=xelatex -M CJKmainfont:文泉驿微米黑 --toc"
HTMLCMD := "pandoc --standalone -c " + CURDIR + "/Templates/solarized-light.min.css --template " + CURDIR + "/Templates/mermaid_template.html5 --filter pandoc-mermaid --mathjax --toc"
HTMLDARKCMD := "pandoc -c " + CURDIR + "/Templates/solarized-dark.min.css --template " + CURDIR + "/Templates/mermaid_template.html5 --filter pandoc-mermaid --mathjax --toc"

html +FILES:
	@for f in {{FILES}}; do just _html $f; done;

pdf +FILES:
	@for f in {{FILES}}; do just _pdf $f; done;

htmldark +FILES:
	@for f in {{FILES}}; do just _htmldark $f; done;

_html FILE:
	#!/usr/bin/env bash
	BN="`basename {{FILE}} .md`"
	DN="`dirname {{FILE}}`"
	echo "Converting: {{FILE}} -> $DN/$BN.html"
	{{HTMLCMD}} --metadata pagetitle="$DN/$BN" "{{FILE}}" -o "$DN/$BN.html";

_pdf FILE:
	#!/usr/bin/env bash
	BN="`basename {{FILE}} .md`"
	DN="`dirname {{FILE}}`"
	echo "Converting: {{FILE}} -> $DN/$BN.pdf"
	{{PDFCMD}} --metadata pagetitle="$DN/$BN" "{{FILE}}" -o "$DN/$BN.pdf";

_htmldark FILE:
	#!/usr/bin/env bash
	BN="`basename {{FILE}} .md`"
	DN="`dirname {{FILE}}`"
	echo "Converting: {{FILE}} -> $DN/$BN.html"
	{{HTMLDARKCMD}} --metadata pagetitle="$DN/$BN" "{{FILE}}" -o "$DN/$BN.html";

clean:
	fd -I '(.html|.pdf)$' --exec rimraf;
	fd -I '^pd-images$' --exec rimraf;
