NAME=ananyev-master

DIAGS=diags

.PHONY: all view diags clean

all: $(NAME).pdf

view:
	nohup zathura $(NAME).pdf 1>/dev/null 2>&1 &

$(NAME).pdf: $(wildcard *.tex)
	make diags
	context --synctex=1 $(NAME).tex

diags: $(patsubst %.tex,%.pdf,$(wildcard $(DIAGS)/*.tex))
	echo $<

$(DIAGS)/%.pdf: $(DIAGS)/%.tex
	latexmk -lualatex -cd $<

clean:
	latexmk -f -c
	cd diags/; latexmk -f -c

purge:
	latexmk -f -C
	cd diags/; latexmk -f -C
