class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "8f067347f75a0d61b3e8ba08e2d7ecefca2255cae7d95e5386a3931d066945c3"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e216d46a6caae25115862e6663247c11118bf4aace7036571e9025fd53337e72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e216d46a6caae25115862e6663247c11118bf4aace7036571e9025fd53337e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e216d46a6caae25115862e6663247c11118bf4aace7036571e9025fd53337e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4c15f2b09b098034ebf896c231f89cdab3934bb1f26202f8ed5142d74ac90b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3686469e814cacb3014a15bf86c148c3164d87eaba160404d09766abe2a463d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3998e1057b707788c0cfb7017d97ac266a2a7af38880eaca050609485a4d4365"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
