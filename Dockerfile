FROM aantonw/alpine-wkhtmltopdf-patched-qt

# install dependencies    
RUN apk add --no-cache libgcc libstdc++ ncurses-libs libstdc++6 ttf-dejavu \
	font-isas-misc msttcorefonts-installer build-base make gcc zlib zlib-dev \
	libffi-dev openssl-dev ca-certificates

# install defualt python3.6
RUN apk add --update --no-cache python3 py3-pip \
	&& ln -sf /usr/bin/pip3 /usr/bin/pip \
	&& rm -rf /var/cache/apk/*

# compile and install python 3.8
RUN wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz \
	&& tar -xvf Python-3.8.2.tgz  \
	&& rm Python-3.8.2.tgz \
	&& cd Python-3.8.2  \
	&& ./configure --prefix=/usr/local/python3.8 --with-ssl \
	&& make \
	&& make install

ENV PATH "/usr/local/python3.8/bin:$PATH"

RUN ln -s /usr/local/python3.8/bin/python3.8 /usr/bin/python3.8

# use python3.8 in virtualenv
RUN pip install --upgrade pip \
	&& pip install virtualenv \
	&& virtualenv venv -p python3.8 \
	&& source venv/bin/activate

RUN python3 -c "import sys; print(sys.version)"
