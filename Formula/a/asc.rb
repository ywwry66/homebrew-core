class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.0.tar.gz"
  sha256 "d26f78ad3a125e097cf69c29c06f1c4d1f52db93266f311ef30ab399c2ae9c84"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d36d7dafd132f7d669f85cb8fbd7d9abdba149f67d8f88601b24b8a8bc994040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364a1b093f2d6819afcd141d9df934b87043919152a71019103abd55b5243f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027cba7fdabc501742f71b2cc535b199cee7ff19b700b404a80dfedad8016716"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a064bb25a556073f0e69b52861b30744904f5fd97e65e9107193e10ba6895d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e87dfa6b904898cf53155646d07b1943905a01e481f14bc4470121753a4fdabd"
    sha256 cellar: :any,                 x86_64_linux:  "2f94b64e1cbf2accbccacd26ba72dbb8560deabfbea8a6bcb2042231848b0f58"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
