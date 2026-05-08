all:
	gcc -o icons icons.c `pkg-config --cflags --libs gtk+-3.0 gtk-layer-shell-0 gio-2.0` -lm
install:
	install -Dm755 icons /usr/local/bin/icons
uninstall:
	rm -f /usr/local/bin/icons