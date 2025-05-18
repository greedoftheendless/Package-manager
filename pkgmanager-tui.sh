# Maintainer: Your Name <your.email@example.com>
pkgname=pkgmanager
pkgver=1.0.0
pkgrel=1
pkgdesc="A terminal-based interactive package search tool for Arch Linux (pacman/yay/paru)"
arch=('any')
url="https://github.com/greedoftheendless/pkgmanager"
license=('MIT')
depends=('bash' 'gum' 'tldr')
source=("$pkgname.sh")
sha256sums=('SKIP')

package() {
  install -Dm755 "$srcdir/$pkgname.sh" "$pkgdir/usr/bin/pkgsearch-tui"
}
