class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.51.tar.gz"
  sha256 "2c037644a81efe173a81597fa6de5422ca7b0e6b650965001f5045e02dff1fe1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d7bfee129a39f906b622559cfc37eece46075dd3038a5b12128b4149b0139d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7bfee129a39f906b622559cfc37eece46075dd3038a5b12128b4149b0139d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d7bfee129a39f906b622559cfc37eece46075dd3038a5b12128b4149b0139d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bb5e319d36403297f7896234271b446a0f1ea5f19654e0f494ac281e268f7e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "675d0c5084f06ddd77b8a6458dd40cf80bf6b4f8412ad5aa481fad3c089e0ca7"
    sha256 cellar: :any,                 x86_64_linux:  "6643eddd8daf9705819ab1f177e1ed140c6b1446954d76544ffbbbe8a0da702c"
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
