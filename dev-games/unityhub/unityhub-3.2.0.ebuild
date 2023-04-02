# Copyright 1999-2023 Gentoo Authors
# Copyright 2023 Gabriel Bustillo del Cuvillo (Based on app-editors/vscode)
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


QA_PREBUILT="
	/opt/unityhub/bin/code-tunnel
	/opt/unityhub/chrome_crashpad_handler
	/opt/unityhub/chrome-sandbox
	/opt/unityhub/code
	/opt/unityhub/libEGL.so
	/opt/unityhub/libffmpeg.so
	/opt/unityhub/libGLESv2.so
	/opt/unityhub/libvk_swiftshader.so
	/opt/unityhub/libvulkan.so*
	/opt/unityhub/resources/app/extensions/*
	/opt/unityhub/resources/app/node_modules.asar.unpacked/*
	/opt/unityhub/swiftshader/libEGL.so
	/opt/unityhub/swiftshader/libGLESv2.so
"


# Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, xdg-utils, libatspi2.0-0, libuuid1, libsecret-1-0
# Recommends: libappindicator3-1
DEPEND="
        >=app-accessibility/at-spi2-core-2.46.0:2
        app-crypt/libsecret[crypt]
        dev-libs/expat
        dev-libs/glib:2
        dev-libs/nspr
        dev-libs/nss
        media-libs/alsa-lib
        media-libs/mesa
        net-print/cups
        sys-apps/util-linux
        sys-apps/dbus
        x11-libs/cairo
        x11-libs/gdk-pixbuf:2
        x11-libs/gtk+:3
        x11-libs/libdrm
        x11-libs/libX11
        x11-libs/libxcb
        x11-libs/libXcomposite
        x11-libs/libXdamage
        x11-libs/libXext
        x11-libs/libXfixes
        x11-libs/libxkbcommon
        x11-libs/libxkbfile
        x11-libs/libXrandr
        x11-libs/libxshmfence
        x11-libs/pango
        "
RDEPEND="${DEPEND}"

QA_PREBUILT="opt/${MY_PN}/*"

S="${WORKDIR}"

src_install() {
    unpack_deb ${A}
    doins -r *
    fperms 0755  /opt/${PN}/${PN}{,-bin}
    fperms 0755  /opt/${PN}/UnityLicensingClient_V1/createdump
    fperms 0755  /opt/${PN}/UnityLicensingClient_V1/Unity.Licensing.Client
    fperms +x /opt/${PN}/resources/app.asar.unpacked/lib/linux/7z/linux64/7z
    make_desktop_entry "${MY_PN}" "UnityHub" "${MY_PN}" "Development"
## newicon "resources/app/resources/linux/code.png" "${MY_PN}.png"
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
}