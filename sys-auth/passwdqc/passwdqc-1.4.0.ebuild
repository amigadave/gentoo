# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam toolchain-funcs

DESCRIPTION="Password strength checking library (and PAM module)"
HOMEPAGE="http://www.openwall.com/passwdqc/"
SRC_URI="http://www.openwall.com/${PN}/${P}.tar.gz"

LICENSE="Openwall BSD public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

pkg_setup() {
	QA_FLAGS_IGNORED="/$(get_libdir)/security/pam_passwdqc.so
		 /usr/$(get_libdir)/libpasswdqc.so.0"
}

src_prepare() {
	default
	sed -i -e 's:`uname -s`:Linux:' Makefile || die
}

_emake() {
	emake \
		SHARED_LIBDIR="/usr/$(get_libdir)" \
		SECUREDIR="$(getpam_mod_dir)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		"$@"
}

src_compile() {
	_emake pam utils
}

src_install() {
	_emake DESTDIR="${ED}" install_lib install_pam install_utils
	dodoc README PLATFORMS INTERNALS
}
