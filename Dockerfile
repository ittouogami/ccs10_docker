FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"

SHELL ["/bin/bash", "-c"]
ENV VIVADO_VER=2019.1
ARG URIS=smb://192.168.103.223/Share/Vivado2019.1/
ARG VIVADO_MAIN=Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz
COPY install_config_main.txt /VIVADO-INSTALLER/
RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential binutils ncurses-dev u-boot-tools file tofrodos iproute2 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
# Main
  curl -u guest ${URIS}${VIVADO_MAIN} | tar zx --strip-components=1 -C /VIVADO-INSTALLER && \
  /VIVADO-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER/install_config_main.txt && \
  rm -rf /VIVADO-INSTALLER
# /root/.Xilinx generated

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh && source /opt/Xilinx/Vivado/$VIVADO_VER/settings64.sh"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["/bin/bash", "-l"]
#CMD ["source /opt/Xilinx/Vivado/2019.1/settings64.sh"]

