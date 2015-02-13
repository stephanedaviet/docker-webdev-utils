FROM node:0.10
MAINTAINER Stéphane Daviet <stephane.daviet@serli.com>

# Install Yo stack and some usefull tools
RUN npm install -g yo generator-angular grunt-cli gulp bower

# Grunt will listen on 9000 port number
EXPOSE 9000

# Install Ruby
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.0
# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update \
&& apt-get install -y bison libgdbm-dev ruby \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir -p /usr/src/ruby \
&& curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
| tar -xjC /usr/src/ruby --strip-components=1 \
&& cd /usr/src/ruby \
&& autoconf \
&& ./configure --disable-install-doc \
&& make -j"$(nproc)" \
&& make install \
&& apt-get purge -y --auto-remove bison libgdbm-dev ruby \
&& rm -r /usr/src/ruby

# Install SASS and Compass
RUN gem install sass
RUN gem install compass

# Add a user
RUN adduser --disabled-password --home=/home/user --gecos "" user

# Run all operations in user mode
USER user
ENV HOME /home/user
WORKDIR /home/user
