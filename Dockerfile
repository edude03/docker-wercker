FROM golang:1.6.2

ENV WERCKER_COMMITISH c1629b0ed455c07aaca93378d2ab34675c8fefa9
ENV WERCKER_SRC_URL https://github.com/wercker/wercker/tarball/$WERCKER_COMMITISH
ENV WERCKER_SRC_PATH /tmp/master.tar.gz
ENV WERCKER_BUILD_PATH $GOPATH/src/github.com/wercker/wercker

# Download Wercker
RUN wget $WERCKER_SRC_URL -O $WERCKER_SRC_PATH

# Make directory & Extract src; --strip-compoenets changes /wercker-master/... to /...
RUN mkdir -p $WERCKER_BUILD_PATH && tar -C $WERCKER_BUILD_PATH -zxvf $WERCKER_SRC_PATH --strip-components=1

# Install & run govendor
RUN go get github.com/kardianos/govendor && cd $WERCKER_BUILD_PATH && govendor sync

# Build Wercker
RUN cd $WERCKER_BUILD_PATH && go build

# Add wercker to path
RUN ln -s $WERCKER_BUILD_PATH/wercker /bin/wercker

ENTRYPOINT ["/bin/wercker"]
