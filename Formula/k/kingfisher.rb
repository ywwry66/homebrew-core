class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9ba06e23ed6605ad28ea612d2ac82bc9ac5122ba3024798f5dc3215f60f2b317"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "003aefb0bd414077488bb88ca269525b5270c66ec319909a6662374e5fecbff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708f64fc333da014dcfaac762c377cf668c26b5c237efcf698bb2edac7773177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5273355f2c4d7407b5ac462b2ce52c14b6f77be5e8e4c532d403f6e54e4897a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1795f404dc1a80f269ef9bcf736028bbccfcc1f34f287d0dded4f083d571fb5c"
    sha256 cellar: :any,                 arm64_linux:   "14fcba038efb6797765138f303c6ffb0af83ca0fcfb0a85e7fe59b5f1e4795c8"
    sha256 cellar: :any,                 x86_64_linux:  "1e3b74eecde8c824954054dc97ebfbe8b2e7b530ee0d082d184ba3fd1bacc855"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
