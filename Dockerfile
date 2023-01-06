FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y tor haproxy ruby-full libssl-dev wget curl build-essential zlib1g-dev libyaml-dev libssl-dev netcat && \
    ln -s /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/libssl.so.1.0.0 && \
    wget http://archive.ubuntu.com/ubuntu/pool/universe/p/polipo/polipo_1.1.1-8_amd64.deb && \
    dpkg -i polipo_1.1.1-8_amd64.deb && \
    update-rc.d -f tor remove && \
    update-rc.d -f polipo remove && \
    gem install excon -v 0.96.0

ADD start.rb /usr/local/bin/start.rb
ADD newnym.sh /usr/local/bin/newnym.sh
ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
ADD uncachable /etc/polipo/uncachable

RUN chmod +x /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/newnym.sh

EXPOSE 5566 4444

CMD ["/bin/bash", "-c", "/usr/local/bin/start.rb"]
