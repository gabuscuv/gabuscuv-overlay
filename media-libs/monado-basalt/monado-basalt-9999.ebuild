# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# CMake picked to avoid automagic dependencies in meson.build
inherit cmake git-r3

DESCRIPTION="The open source OpenXR runtime."
HOMEPAGE="https://gitlab.freedesktop.org/mateosss/basalt/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mateosss/basalt.git"
LICENSE="BSD"
SLOT="0"

IUSE="test"

BDEPEND=""
# sudo dnf install -y gcc g++ cmake git tbb-devel eigen3-devel glew-devel ccache libjpeg-turbo-devel libpng-devel lz4-devel bzip2-devel boost-regex boost-filesystem boost-date-time boost-program-options gtest-devel opencv-devel

#  ? dev-libs/lz4 
DEPEND="
	dev-cpp/eigen
	media-libs/glew
	virtual/jpeg
	media-libs/libpng
	app-arch/bzip2
	dev-libs/boost
	dev-libs/libfmt
	media-libs/opencv
"

RDEPEND="${DEPEND}"

## TODO: Remplace this const strings
# Target: /usr/
# Git Repo Cloned: ${WORK}/basalt
##bsltdeps = ${WORKDIR}/basalt

src_prepare(){
	sed -i "s#/home/mateo/Documents/apps/bsltdeps/#$WORKDIR/#" data/monado/*.toml || die 
	eapply_user
	cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=RelWithDebInfo 
		-DBUILD_TESTS=$(use_enable test) 
		-DBASALT_INSTANTIATIONS_DOUBLE=off
    ) 

	cmake_src_configure
}

src_compile() {
	mkdir build && cd build
}
