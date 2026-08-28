class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.0.tar.gz"
  sha256 "69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0132c8e0cc42d0771119fe9035d4cfedf6dea68fbbf34764e45ec67b544ef2ad"
    sha256 cellar: :any, arm64_sequoia: "825621b11d97ac082e0c0b3c508fcbb3396dd2d6ce37125a411041cd0d1d6627"
    sha256 cellar: :any, arm64_sonoma:  "baf8d67e2b1798a60cc120dc3d52167913dcd1b7800e3de490dfb21f161ca5ff"
    sha256 cellar: :any, arm64_linux:   "e64ca0855afb3353d722057af53179b5e43bc6388f4394ac0643091b5b1912a1"
    sha256 cellar: :any, x86_64_linux:  "097cd1e780d9caec6a6aad10d49c0dba4e3192af2fb07254032e66926c361195"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libnfs"
  depends_on "libssh"
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "uchardet"

  uses_from_macos "m4" => :build
  uses_from_macos "libxml2"

  def install
    args = %w[
      -DUSEWX=OFF
      -DUSESDL=OFF
      -DTTYX=OFF
      -DNETROCKS=ON
      -DNR_AWS=OFF
      -DNR_SMB=OFF
      -DMULTIARC=ON
      -DPYTHON=OFF
      -DCOLORER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-GNinja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # This is a TUI application, better tests are not possible
    assert_match version.to_s, shell_output("#{bin}/far2l --version")
    assert_match(/tty/i, shell_output("#{bin}/far2l -h 2>&1"))
  end
end
