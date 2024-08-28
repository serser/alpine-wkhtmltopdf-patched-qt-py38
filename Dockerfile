# 二开推荐阅读[如何提高项目构建效率](https://developers.weixin.qq.com/miniprogram/dev/wxcloudrun/src/scene/build/speed.html)
# 选择基础镜像。如需更换，请到[dockerhub官方仓库](https://hub.docker.com/_/python?tab=tags)自行选择后替换。
# 已知alpine镜像与pytorch有兼容性问题会导致构建失败，如需使用pytorch请务必按需更换基础镜像。
# FROM alpine:3.13

FROM aantonw/alpine-wkhtmltopdf-patched-qt

# 容器默认时区为UTC，如需使用上海时间请启用以下时区设置命令
# RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

# 使用 HTTPS 协议访问容器云调用证书安装
RUN apk add ca-certificates

    
RUN apk add --no-cache libgcc libstdc++ ncurses-libs libstdc++6 ttf-dejavu font-isas-misc msttcorefonts-installer \
	build-base make gcc zlib zlib-dev libffi-dev openssl-dev
        # gtk+ openssl glib fontconfig bash vim postgresql-client \
		# libc-dev gettext-dev zlib-dev bzip2-dev libffi-dev pcre-dev \
		# glib-dev atk-dev expat-dev libpng-dev freetype-dev fontconfig-dev \
		# libxau-dev libxdmcp-dev libxcb-dev xf86bigfontproto-dev libx11-dev \
		# libxrender-dev pixman-dev libxext-dev cairo-dev perl-dev \
		# libxfixes-dev libxdamage-dev graphite2-dev icu-dev harfbuzz-dev \
		# libxft-dev pango-dev gtk+-dev libdrm-dev \
		# libxxf86vm-dev libxshmfence-dev wayland-dev mesa-dev openssl-dev

COPY mac-fonts /usr/share/fonts

# 安装依赖包，如需其他依赖包，请到alpine依赖包管理(https://pkgs.alpinelinux.org/packages?name=php8*imagick*&branch=v3.13)查找。
# 选用国内镜像源以提高下载速度
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
	&& apk add --update --no-cache python3 py3-pip \
	&& ln -sf /usr/bin/pip3 /usr/bin/pip \
	&& rm -rf /var/cache/apk/*

# RUN wget https://www.zlib.net/zlib-1.3.1.tar.gz \
# 	&& tar -xvf zlib-1.3.1.tar.gz \
# 	&& rm zlib-1.3.1.tar.gz \
# 	&& cd zlib-1.3.1 \
# 	&& ./configure \
# 	&& make \
# 	&& make install

# https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz

RUN wget https://mirrors.huaweicloud.com/python/3.8.2/Python-3.8.2.tgz \
	&& tar -xvf Python-3.8.2.tgz  \
	&& rm Python-3.8.2.tgz \
	&& cd Python-3.8.2  \
	&& ./configure --prefix=/usr/local/python3.8 --with-ssl \
	&& make \
	&& make install

ENV PATH "/usr/local/python3.8/bin:$PATH"


RUN ln -s /usr/local/python3.8/bin/python3.8 /usr/bin/python3.8


RUN pip config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple \
	&& pip config set global.trusted-host mirrors.cloud.tencent.com \
	&& pip install --upgrade pip \
	&& pip install virtualenv \
	&& virtualenv venv -p python3.8 \
	&& source venv/bin/activate

RUN python3 -c "import sys; print(sys.version)"
docker build -t serser/alpine-wkhtmltopdf-patched-qt-py38 .