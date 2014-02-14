aclocal && \
autoheader && \
libtoolize --automake --copy && \
automake --add-missing --copy && \
autoconf
