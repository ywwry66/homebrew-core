class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  revision 1
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef2a25298e96da7827cf583bb109e200d2a1938c87aff6d96b23fc7319fea7cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27f6ece51837928385e929a0ca73481cdef71e46f55fd9e506bf600bc800bfe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c959e6058773a5bd27a9e398fa7ce82991d7af7d3d4791c4fb64cb50833a0816"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ac0ee7d92a3549d72f0c4d368beea040c1fbb084811fa1f2c0ba8ff24b31544"
    sha256 cellar: :any_skip_relocation, ventura:        "865fc29ae1000e103b25c1107cceb2b1a4e2dfbb492eb22616cfd4660c7113f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8694ad0ea4c4b708c92a0ca47c5ce322d085696017a9ae8b244987e5b2707916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648d9e52376f1d0bceebf52a373fa82d90fa0abab0b191b56007596a73019f6e"
  end

  depends_on "curl"
  depends_on "python@3.12"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
