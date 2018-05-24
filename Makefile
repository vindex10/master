NAME=ananyev-master

DIAGS=diags

.PHONY: all view diags clean

all: $(NAME).pdf

view:
	nohup zathura $(NAME).pdf 1>/dev/null 2>&1 &

$(NAME).pdf: $(patsubst %.tex,%.pdf,$(wildcard $(DIAGS)/*.tex)) $(wildcard *.tex) literature.bib
	latexmk  -lualatex --synctex=1 $(NAME).tex

diags: $(patsubst %.tex,%.pdf,$(wildcard $(DIAGS)/*.tex))
	echo $<

$(DIAGS)/%.pdf: $(DIAGS)/%.tex
	latexmk -lualatex -cd $<

clean:
	-latexmk -f -c
	-rm -f *.{acn,bbl,glo,ist,run.xml}
	-rm -f *-blx.bib
	-cd diags/; latexmk -f -c

purge: clean
	-latexmk -f -C
	-cd diags/; latexmk -f -C
