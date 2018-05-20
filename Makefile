NAME=ananyev-master

all:
	context --synctex=1 $(NAME).tex
view:
	nohup zathura $(NAME).pdf 1>/dev/null 2>&1 &
clean:
	context --purge
