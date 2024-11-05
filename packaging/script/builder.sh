#!/bin/sh

shell_quote_string() {
  echo "$1" | sed -e 's,\([^a-zA-Z0-9/_.=-]\),\\\1,g'
}

usage () {
    cat <<EOF
Usage: $0 [OPTIONS]
    The following options may be given :
        --builddir=DIR      Absolute path to the dir where all actions will be performed
        --get_sources       Source will be downloaded from GitHub
        --build_src_rpm     If it is 1, src rpm will be built
        --build_source_deb  If it is 1, source deb package will be built
        --build_rpm         If it is 1, rpm will be built
        --build_deb         If it is 1, deb will be built
        --install_deps      Install build dependencies (root privileges required)
        --help) usage ;;
Example: $0 --builddir=/tmp/SORTING_LIB --get_sources=1 --build_src_rpm=1 --build_rpm=1
EOF
        exit 1
}

append_arg_to_args () {
  args="$args "`shell_quote_string "$1"`
}

parse_arguments() {
    pick_args=
    if test "$1" = PICK-ARGS-FROM-ARGV
    then
        pick_args=1
        shift
    fi
  
    for arg do
        val=`echo "$arg" | sed -e 's;^--[^=]*=;;'`
        optname=`echo "$arg" | sed -e 's/^\(--[^=]*\)=.*$/\1/'`
        case "$arg" in
            --builddir=*) WORKDIR="$val" ;;
            --build_src_rpm=*) SRPM="$val" ;;
            --build_source_deb=*) SDEB="$val" ;;
            --build_rpm=*) RPM="$val" ;;
            --build_deb=*) DEB="$val" ;;
            --get_sources=*) SOURCE="$val" ;;
            --install_deps=*) INSTALL="$val" ;;
            --help) usage ;;      
            *)
              if test -n "$pick_args"
              then
                  append_arg_to_args "$arg"
              fi
              ;;
        esac
    done
}

check_workdir(){
    if [ "x$WORKDIR" = "x$CURDIR" ]
    then
        echo >&2 "Current directory cannot be used for building!"
        exit 1
    else
        if ! test -d "$WORKDIR"
        then
            echo >&2 "$WORKDIR is not a directory."
            exit 1
        fi
    fi
    return
}

get_system(){
    if [ -f /etc/redhat-release ]; then
        RHEL=$(rpm --eval %rhel)
        ARCH=$(echo $(uname -m) | sed -e 's:i686:i386:g')
        OS_NAME="el$RHEL"
        OS="rpm"
    else
        ARCH=$(uname -m)
        OS_NAME="$(lsb_release -sc)"
        OS="deb"
    fi
    return
}

install_deps() {
    if [ $INSTALL = 0 ]
    then
        echo "Dependencies will not be installed"
        return;
    fi
    if [ ! $( id -u ) -eq 0 ]
    then
        echo "It is not possible to install dependencies. Please run as root"
        exit 1
    fi
    if [ "x$OS" = "xrpm" ]
    then
        yum -y update
        yum -y install git wget rpm-build gcc-c++ make python3-pip python3-devel
    else
        apt-get -y update
        apt-get -y install git wget build-essential fakeroot devscripts debhelper python3-pybind11 python3-pip 
    fi
    return;
}

get_sources(){
    cd $WORKDIR
    if [ $SOURCE = 0 ]
    then
        echo "Sources will not be downloaded"
        return 0
    fi
    git clone ${REPO} ${NAME}-${VERSION}
    retval=$?
    if [ $retval != 0 ]
    then
        echo "There were some issues during repo cloning from GitHub. Please retry one more time"
        exit 1
    fi
    cd ${NAME}-${VERSION}
    if [ ! -z $BRANCH ]
    then
        git reset --hard
        git clean -xdf
        git checkout $BRANCH
    fi
    cd ../
    tar -zcvf ${NAME}-${VERSION}.tar.gz ${NAME}-${VERSION}
    mkdir $WORKDIR/source_tarball
    mkdir $CURDIR/source_tarball
    cp ${NAME}-${VERSION}.tar.gz $WORKDIR/source_tarball
    cp ${NAME}-${VERSION}.tar.gz $CURDIR/source_tarball
    cd $CURDIR
    return
}

get_tar(){
    TARBALL=$1
    TARFILE=$(basename $(find $WORKDIR/$TARBALL -name 'sorting*.tar.gz' | sort | tail -n1))
    if [ -z $TARFILE ]
    then
        TARFILE=$(basename $(find $CURDIR/$TARBALL -name 'sorting*.tar.gz' | sort | tail -n1))
        if [ -z $TARFILE ]
        then
            echo "There is no $TARBALL for build"
            exit 1
        else
            cp $CURDIR/$TARBALL/$TARFILE $WORKDIR/$TARFILE
        fi
    else
        cp $WORKDIR/$TARBALL/$TARFILE $WORKDIR/$TARFILE
    fi
    return
}

get_deb_sources(){
    param=$1
    echo $param
    FILE=$(basename $(find $WORKDIR/source_deb -name "sorting-*.$param" | sort | tail -n1))
    if [ -z $FILE ]
    then
        FILE=$(basename $(find $CURDIR/source_deb -name "sorting-*.$param" | sort | tail -n1))
        if [ -z $FILE ]
        then
            echo "There is no sources for build"
            exit 1
        else
            cp $CURDIR/source_deb/$FILE $WORKDIR/
        fi
    else
        cp $WORKDIR/source_deb/$FILE $WORKDIR/
    fi
    return
}

build_srpm(){
    if [ $SRPM = 0 ]
    then
        echo "SRC RPM will not be created"
        return;
    fi
    if [ "x$OS" = "xdeb" ]
    then
        echo "It is not possible to build src rpm here"
        exit 1
    fi

    cd $WORKDIR
    get_tar "source_tarball"
    rm -fr rpmbuild
    TARFILE=$(basename $(find . -name 'sorting-*.tar.gz' | sort | tail -n1))
    NAME=$(echo ${TARFILE}| awk -F '-' '{print $1}')
    VERSION_TMP=$(echo ${TARFILE}| awk -F '-' '{print $2}')
    VERSION=${VERSION_TMP%.tar.gz}
    #
    mkdir -vp rpmbuild/{SOURCES,SPECS,BUILD,SRPMS,RPMS}
    cd rpmbuild/SPECS/
    tar vxzf ${WORKDIR}/../source_tarball/${TARFILE} --wildcards "*/packaging/rpm/sorting-library.spec" --strip=3
    cd ${WORKDIR}
    cp ${WORKDIR}/../source_tarball/${TARFILE} ${WORKDIR}/rpmbuild/SOURCES
    rpmbuild -bs --define "_topdir ${WORKDIR}/rpmbuild" --define "dist .generic" rpmbuild/SPECS/sorting-library.spec

    mkdir -p ${WORKDIR}/srpm
    mkdir -p ${CURDIR}/srpm
    cp rpmbuild/SRPMS/*.src.rpm ${CURDIR}/srpm
    cp rpmbuild/SRPMS/*.src.rpm ${WORKDIR}/srpm

    return
}



build_rpm(){
    if [ $RPM = 0 ]
    then
        echo "RPM will not be created"
        return;
    fi
    if [ "x$OS" = "xdeb" ]
    then
        echo "It is not possible to build rpm here"
        exit 1
    fi
        SRC_RPM=$(basename $(find $WORKDIR/srpm -name 'sorting*.src.rpm' | sort | tail -n1))
    if [ -z $SRC_RPM ]
    then
        SRC_RPM=$(basename $(find $CURDIR/srpm -name 'sorting*.src.rpm' | sort | tail -n1))
        if [ -z $SRC_RPM ]
        then
            echo "There is no src rpm for build"
            echo "You can create it using key --build_src_rpm=1"
            exit 1
        else
            cp $CURDIR/srpm/$SRC_RPM $WORKDIR
        fi
    else
        cp $WORKDIR/srpm/$SRC_RPM $WORKDIR
    fi
    cd $WORKDIR
    SRCRPM=$(basename $(find . -name '*.src.rpm' | sort | tail -n1))
    mkdir -vp rpmbuild/{SOURCES,SPECS,BUILD,SRPMS,RPMS}
    mv *.src.rpm rpmbuild/SRPMS
    rpmbuild --define "_topdir ${WORKDIR}/rpmbuild" --define "dist .el${RHEL}" --rebuild rpmbuild/SRPMS/${SRCRPM}
    return_code=$?
    if [ $return_code != 0 ]; then
        exit $return_code
    fi
    mkdir -p ${WORKDIR}/rpm
    mkdir -p ${CURDIR}/rpm
    cp rpmbuild/RPMS/*/*.rpm ${WORKDIR}/rpm
    cp rpmbuild/RPMS/*/*.rpm ${CURDIR}/rpm
    return
}

build_source_deb(){
    if [ $SDEB = 0 ]
    then
        echo "Source DEB package will not be created"
        return;
    fi
    if [ "x$OS" = "xrpm" ]
    then
        echo "It is not possible to build source deb here"
        exit 1
    fi
        get_tar "source_tarball"
    #
    TARFILE=$(basename $(find . -name 'sorting-*.tar.gz' | sort | tail -n1))
    NAME=$(echo ${TARFILE}| awk -F '-' '{print $1"-"$2}')
    VERSION_TMP=$(echo ${TARFILE}| awk -F '-' '{print $3}')
    VERSION=${VERSION_TMP%.tar.gz}
    #
    rm -fr ${NAME}-${VERSION}
    #
    NEWTAR=${NAME}_${VERSION}.orig.tar.gz
    mv ${TARFILE} ${NEWTAR}
    #
    #
    tar xzf ${NEWTAR}
    cd ${NAME}-${VERSION}
    mv packaging/debian ./
    dch -D unstable --force-distribution -v "${VERSION}-${DEB_RELEASE}" "Update to new release ${NAME} ${VERSION}-${DEB_RELEASE}"
    dpkg-buildpackage -S
    #
    cd ../
    ls
    mkdir -p $WORKDIR/source_deb
    mkdir -p $CURDIR/source_deb
    cp *_source.changes $WORKDIR/source_deb
    cp *.dsc $WORKDIR/source_deb
    cp *.diff* $WORKDIR/source_deb
    cp *.tar* $WORKDIR/source_deb
    cp *_source.changes $CURDIR/source_deb
    cp *.dsc $CURDIR/source_deb
    cp *.diff* $CURDIR/source_deb
    cp *.tar* $CURDIR/source_deb
    return
}

build_deb(){
    if [ $DEB = 0 ]
    then
        echo "DEB package will not be created"
        return;
    fi
    if [ "x$OS" = "xrpm" ]
    then
        echo "It is not possible to build deb here"
        exit 1
    fi
    for file in 'dsc' 'orig.tar.gz' 'changes' 'diff.gz' 
    do
        get_deb_sources $file
    done
    cd $WORKDIR
    rm -fv *.deb
    export DEBIAN_VERSION="$(lsb_release -sc)"
    DSC=$(basename $(find . -name '*.dsc' | sort | tail -n 1))
    DIRNAME=$(echo ${DSC} | sed -e 's:_:-:g' | awk -F'-' '{print $1"-"$2}')
    VERSION=$(echo ${DSC} | sed -e 's:_:-:g' | awk -F'-' '{print $3}')
    ARCH=$(uname -m)
    #
    dpkg-source -x ${DSC}
    cd ${NAME}-${VERSION}

    dch -b -m -D "$DEBIAN_VERSION" --force-distribution -v "${VERSION}-${DEB_RELEASE}.${DEBIAN_VERSION}" 'Update distribution'
    #
    dpkg-buildpackage -rfakeroot -uc -us -b
    mkdir -p $CURDIR/deb
    mkdir -p $WORKDIR/deb
    cp $WORKDIR/*.deb $WORKDIR/deb
    cp $WORKDIR/*.deb $CURDIR/deb
    return
}

# Main
CURDIR=$(pwd)
WORKDIR=
SRPM=0
SDEB=0
RPM=0
DEB=0
SOURCE=0
INSTALL=0
NAME="sorting-library"
RPM_RELEASE=1
DEB_RELEASE=1
BRANCH="master"
REPO="https://github.com/EvgeniyPatlan/sorting-library.git"
VERSION="1.0"

parse_arguments PICK-ARGS-FROM-ARGV "$@"

check_workdir
get_system
install_deps
get_sources
build_srpm
build_source_deb
build_rpm
build_deb
