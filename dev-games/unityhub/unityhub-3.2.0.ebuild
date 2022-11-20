# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7
MY_PN="${PN/-bin/}"

inherit eutils desktop xdg-utils unpacker
DESCRIPTION="Unity Launcher"
HOMEPAGE="https://unity3d.com/"
SRC_URI="https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${PV}.deb"
RESTRICT="mirror strip bindist"
LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils, libatspi2.0-0, libuuid1, libsecret-1-0
# Recommends: libappindicator3-1
DEPEND=""
RDEPEND="${DEPEND}

QA_PREBUILT="opt/${MY_PN}/*"

S="${WORKDIR}"

src_install() {
    unpack_deb ${A}
    # Install in /opt
    dodir /opt
    cp -pPR "${S}" "${D}/opt/${MY_PN}"
    fperms 0755 /opt/${MY_PN}

    dosym "../../opt/${MY_PN}/unityhub" "/usr/bin/${MY_PN}"
    make_desktop_entry "${MY_PN}" "VSCodium" "${MY_PN}" "Development;IDE"
    newicon "resources/app/resources/linux/code.png" "${MY_PN}.png"
}

pkg_postinst() {
    xdg_desktop_database_update
    xdg_icon_cache_update
    xdg_mimeinfo_database_update
}
pkg_postrm() {
    xdg_desktop_database_update
    xdg_icon_cache_update
    xdg_mimeinfo_database_update
