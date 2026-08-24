class Jarl < Formula
  desc "Just another R linter"
  homepage "https://jarl.etiennebacher.com"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.6.0.tar.gz"
  sha256 "86620fcdb654d18be5f9fc62257ff577eade56cb1a6d9a3bc7d6e6857006a8a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45fc95c331aecc9e9f67b7aa447aa1789abad939906779f3d58bb51daf25bc9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e0b769f6aff9bfbd8ce678d007c033d2da67ea640a63a3a846aa4291bdd509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3a65db005fd59432a89600b1c4a7c20c6cc21830085978546e898b43bc69faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2953143e10d3c181beaca7f6af7d07c1345725e2bb68b56bba9e5270af500017"
    sha256 cellar: :any,                 arm64_linux:   "1ba5b56ee9e7b427d08df9d30aa0da1d15831127551e0ff8e1225c386161f28c"
    sha256 cellar: :any,                 x86_64_linux:  "5af2d4141c8130f3bbaec1b7edd1c4b48b02329adc390454a07fc340f43f2158"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    (testpath/"test.R").write <<~R
      # Simple R code for testing
      any(is.na(x))
    R

    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    system bin/"jarl", "check", testpath/"test.R", "--fix", "--allow-no-vcs"

    formatted_content = (testpath/"test.R").read
    assert_match "anyNA(x)", formatted_content
  end
end
