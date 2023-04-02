# Copyright 2021 Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Copyright 2023 Gabriel (gabuscuv) Bustillo del Cuvillo <gabuscuv@gmail.com> (based on onnxruntime-1.9.1)
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

CPUINFO_COMMIT=5916273f79a21551890fd3d56fc5375a78d1598d
ONNX_COMMIT=ad834eb73ee0cd9b6fa9ea892caeed5fa17d7dc0

DESCRIPTION="cross-platform, high performance ML inferencing and training accelerator"
HOMEPAGE="https://github.com/microsoft/onnxruntime"
SRC_URI="
	https://github.com/microsoft/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/onnx/onnx/archive/${ONNX_COMMIT}.tar.gz -> onnx-${ONNX_COMMIT:0:10}.tar.gz
"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="benchmark test"

# libonnxruntime_framework.so: undefined reference to `onnx::AttributeProto_AttributeType_Name[abi:cxx11](onnx::AttributeProto_AttributeType)'
RESTRICT="test"

S="${WORKDIR}/${P}/cmake"

# Needs https://gitlab.com/libeigen/eigen/-/commit/d0e3791b1a0e2db9edd5f1d1befdb2ac5a40efe0.patch on eigen-3.4.0
RDEPEND="
	dev-python/numpy
	dev-cpp/abseil-cpp
	dev-libs/date:=
	>=dev-libs/boost-1.66:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	dev-libs/flatbuffers:=
	dev-cpp/nlohmann_json:=
	dev-libs/nsync
	dev-cpp/eigen:3
	benchmark? ( dev-cpp/benchmark )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=(
	##"${FILESDIR}/onnxruntime-system_libs.patch"
)

src_prepare() {
	cmake_src_prepare

##	rm -r "${S}/external/pytorch_cpuinfo" || die
##	mv "${WORKDIR}/cpuinfo-${CPUINFO_COMMIT}" "${S}/external/pytorch_cpuinfo" || die

##	rm -r "${S}/external/onnx" || die
##	mv "${WORKDIR}/onnx-${ONNX_COMMIT}" "${S}/external/onnx" || die

##	rm -r "${S}/external/mp11" || die
##	mv "${WORKDIR}/mp11-${MP11_COMMIT}" "${S}/external/mp11" || die

##	rm -r "${S}/external/flatbuffers" || die
##	mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_PV}" "${S}/external/flatbuffers" || die

##	rm -r "${S}/external/optional-lite" || die
##	mv "${WORKDIR}/optional-lite-${OPTIONAL_LITE_COMMIT}" "${S}/external/optional-lite" || die

##	rm -r "${S}/external/SafeInt/safeint" || die
##	mv "${WORKDIR}/SafeInt-${SAFEINT_COMMIT}" "${S}/external/SafeInt/safeint" || die
}

src_configure() {
	append-cppflags "-I/usr/include/eigen3"

	local mycmakeargs=(
		-Donnxruntime_PREFER_SYSTEM_LIB=ON
		-Donnxruntime_BUILD_BENCHMARKS=$(usex benchmark)
		-Donnxruntime_BUILD_UNIT_TESTS=$(usex test)
	)

	cmake_src_configure
}
