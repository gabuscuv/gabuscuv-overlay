# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# CMake picked to avoid automagic dependencies in meson.build
inherit cmake git-r3

DESCRIPTION="The open source OpenXR runtime."
HOMEPAGE="https://gitlab.freedesktop.org/mateosss/basalt/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mateosss/basalt.git"
LICENSE="BSD"
SLOT="0"

IUSE="dbus ffmpeg gles gstreamer opencv opengl psvr sdl systemd uvc vive vulkan wayland X"

BDEPEND=""
# sudo dnf install -y gcc g++ cmake git tbb-devel eigen3-devel glew-devel ccache libjpeg-turbo-devel libpng-devel lz4-devel bzip2-devel boost-regex boost-filesystem boost-date-time boost-program-options gtest-devel opencv-devel

# dev-libs/liblzw ?
DEPEND="
	net-libs/libbtbb
	dev-cpp/eigen
	media-libs/glew
	virtual/jpeg
	media-libs/libpng
	dev-libs/lz4 
	app-arch/bzip2
	dev-libs/boost
	dev-libs/libfmt
	media-libs/opencv
"

RDEPEND="${DEPEND}"

## TODO: Remplace this const strings
# Target: /usr/
bsltinstall = ${D}
# Git Repo Cloned: ${WORK}/basalt
bsltdeps = ${WORKDIR}/basalt

src_configure() {
	sed -i "s#/home/mateo/Documents/apps/bsltdeps/#$bsltdeps/#" basalt/data/monado/*.toml
    local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=$bsltinstall
		-DCMAKE_BUILD_TYPE=RelWithDebInfo 
		-DBUILD_TESTS=off 
		-DBASALT_INSTANTIATIONS_DOUBLE=off
    ) 

	cmake_src_configure
}

src_compile() {
	cd $bsltdeps && mkdir build && cd build
}
