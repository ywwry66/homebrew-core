class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cf0814005bd39c02b7c48d385a258e2e4e1fd57980bb57db72ecb490494de06c"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a56f50cdeca8cfb86b4683aa7dcf022d6d4d843c92884d58d325ff8c5a50255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c065e334e7bfb3db6e3668f6c3c78928339e7d50ce2eedfd01b9e7701224f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f415cd895262f2b554a09116192d76165d05f2026539dfea29350f927ea6a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfeac8e3f8d9c7043d3dd003a20ddff3397fe2ae2ce1fa86949c1734aac2fcf"
    sha256 cellar: :any,                 arm64_linux:   "3722239450105ca0084a82b3c42979e4bc581f76eea5f5c0cb9d98f4cd29b684"
    sha256 cellar: :any,                 x86_64_linux:  "2b519514a720bcac399dc8ff1f8f56ac29401bfd547b5d01b4c700de899822d5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end
