# Copyright 2023 Gabriel Bustillo del Cuvillo
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="A wallpaper plugin integrating wallpaper engine into kde wallpaper setting."
HOMEPAGE="https://github.com/catsout/wallpaper-engine-kde-plugin"
EGIT_REPO_URI="https://github.com/catsout/wallpaper-engine-kde-plugin.git"
LICENSE="GPL-2"
SLOT="0"

IUSE="+mpv -plasmapkg"

DEPEND="
    mpv? ( media-video/mpv )
    dev-qt/qtwebsockets
    dev-python/websockets
    kde-plasma/systemsettings
    kde-frameworks/plasma
    dev-util/vulkan-headers
"

src_configure() {
	local mycmakeargs=(
    "-DUSE_PLASMAPKG=$(usex plasmapkg)"
    )
    cmake_src_configure
}

src_install() {
    if use plasmapkg; then
	    emake DESTDIR="${D}" install_pkg
    fi
    emake DESTDIR="${D}" install
}