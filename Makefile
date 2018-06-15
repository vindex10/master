NAME=ananyev-master

DIAGS=diags

.PHONY: all view diags clean bw

all: $(NAME).pdf

view:
	nohup zathura $(NAME).pdf 1>/dev/null 2>&1 &

$(NAME).pdf: $(patsubst %.tex,%.pdf,$(wildcard $(DIAGS)/*.tex))\
			 $(wildcard *.tex)\
			 $(wildcard assets/*.tex)\
			 $(wildcard img/*)\
			 literature.bib
	latexmk  -lualatex --synctex=1 $(NAME).tex

diags: $(patsubst %.tex,%.pdf,$(wildcard $(DIAGS)/*.tex))
	echo $<

$(DIAGS)/%.pdf: $(DIAGS)/%.tex
	latexmk -lualatex -cd $<

bw: $(NAME).pdf
	mkdir -p bw
	gs -o - -sDEVICE=inkcov $(NAME).pdf | grep -E '^(Page|\s)' | grep -E "^\s" | awk '$$0+$$1+$$2 < 0.008 {print "bw/"NR".pdf"}' > bw/bw
	gs -o - -sDEVICE=inkcov $(NAME).pdf | grep -E '^(Page|\s)' | grep -E "^\s" | awk '$$0+$$1+$$2 >= 0.008 {print "bw/"NR".pdf"}' > bw/color
	pdfseparate $(NAME).pdf "bw/%d.pdf"
	pdfunite `cat bw/bw` bw/bw.pdf
	pdfunite `cat bw/color` bw/color.pdf
	rm -f `cat bw/bw` `cat bw/color`
clean:
	-latexmk -f -c
	-rm -f *.{acn,bbl,glo,ist,run.xml}
	-rm -f *-blx.bib
	-cd diags/; latexmk -f -c

purge: clean
	-latexmk -f -C
	-cd diags/; latexmk -f -C
