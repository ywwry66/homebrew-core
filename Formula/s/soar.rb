class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "6cab6e40c7e34a5f461662f030f57e21f9691a9a60f17b824cccd5399678e2bb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "9939346d70200550b7f8da6ffc39202041daa165800d7dcac40b177031c4fd7d"
    sha256 cellar: :any, x86_64_linux: "a8563b16a10e83df1b8fbd74a981fb49a1f135766c7068e1817915c1e602b784"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', shell_output("cat test.toml")
  end
end
