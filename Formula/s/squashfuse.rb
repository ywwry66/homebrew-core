class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.3/squashfuse-0.6.3.tar.gz"
  sha256 "0c9f582ca488dc5eb450830d72f45a042ef5c0476118502ab5ed86ae9dd8bd46"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_linux:  "94a37af6f804adec645cb81f2316643667bd09383beda744cd846b15427ef98d"
    sha256 cellar: :any, x86_64_linux: "78bac5668ec9d888061ddbc005efbb9667655cd1c0ec763343cd9854b502bc5b"
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "lz4"
  depends_on "lzo"
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Unfortunately, making/testing a squash mount requires sudo privileges, so
    # just test that squashfuse execs for now.
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
