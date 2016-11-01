FROM tristansalles/usyd-uos-geos-base:v1.01

MAINTAINER Tristan Salles

# Install COVE model
COPY  COVE.zip /
RUN unzip -o /COVE.zip -d /COVE && \
  cd /COVE/COVE.0/driver_files && \
  make -f spiral_bay_make.make && \
  mv spiral_bay.out cove && \
  mv cove /usr/local/bin

# Install XBEACH model
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    automake \
    autoconf \
    libtool \
    shtool \
    autogen \
    subversion

RUN apt-get -y install libjpeg-dev zlib1g-dev

RUN cd /usr/local && \
    svn checkout --username tristan.salles.x --password C33Mv2_D https://svn.oss.deltares.nl/repos/xbeach/trunk

RUN pip install --upgrade pip

RUN pip install mako Pillow plotly colorlover cmocean

RUN cd /usr/local/trunk && \
    sh autogen.sh && \
    ./configure --with-netcdf && \
    make && \
    make install

# Install TRACPY
RUN git clone https://github.com/hetland/octant.git && \
    cd octant && \
    pip install -e .
    #cd .. && \
    #cp -r .local/lib/python2.7/site-packages/octant* /usr/lib/python2.7/dist-packages && \
    #rm -r .local/lib/python2.7/site-packages/octant*

COPY  tools.py /
RUN git clone https://github.com/kthyng/tracpy.git && \
    cp tools.py tracpy/tracpy && \
    cd tracpy && \
    pip install -e .
    #cd .. && \
    #cp -r .local/lib/python2.7/site-packages/tracpy* /usr/lib/python2.7/dist-packages && \
    #rm -r .local/lib/python2.7/site-packages/tracpy*
