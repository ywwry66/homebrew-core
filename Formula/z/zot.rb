class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.54.tar.gz"
  sha256 "561ee1dd62022f3f4c777a19abb5c54ad1f728055a7b049363703daeb135a0fb"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd025046a596972721e80466495e2021b24eb687b6f5516c8b9116a9e8d08aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd025046a596972721e80466495e2021b24eb687b6f5516c8b9116a9e8d08aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd025046a596972721e80466495e2021b24eb687b6f5516c8b9116a9e8d08aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc137cfdcbcda5f6bddd965853fb69c6b0c093cb7f231bc77282b22030745474"
    sha256 cellar: :any,                 x86_64_linux:  "7654c0274433da7a7db8e5b927b902505dacff23df3783982891686b93390140"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
