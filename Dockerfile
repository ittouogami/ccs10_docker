FROM ubuntu18
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ARG CCS_VER=10.0.0.00010
ARG IP=192.168.0.200
ARG URIS=smb://${IP}/Share/CCS${CCS_VER}/
ARG CCS_MAIN=CCS${CCS_VER}_linux-x64.tar.gz
RUN \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install sudo && \
  apt-get -y -qq --no-install-recommends install \
          locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq --no-install-recommends install \
          notification-daemon \
          software-properties-common \
          build-essential \
          binutils \
          usbutils \
          net-tools \
          xterm \
          unzip \
          git \
          dbus \
          libgconf-2-4 \
          libpython2.7 \
          libnss3 \
          libxss1 \
          libusb-0.1-4 &&\
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y -qq --no-install-recommends install \
          libc6:i386 &&\
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /CCS-INSTALLER && \
  curl -u guest ${URIS}${CCS_MAIN} | tar zx --strip-components=1 -C /CCS-INSTALLER &&\
  /CCS-INSTALLER/ccs_setup_${CCS_VER}.run --enable-components PF_MSP430 --prefix /opt/TI --mode unattended &&\
  rm -rf /CCS-INSTALLER &&\
#RUN /opt/TI/css/install_scripts/install_drivers.sh
  printf 'env SWT_GTK3=0 /opt/TI/ccs/eclipse/ccstudio' > /usr/bin/ccs &&\
  chmod +x /usr/bin/ccs
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

