class Mcpsnoop < Formula
  desc "Transparent proxy and TUI for debugging MCP traffic"
  homepage "https://github.com/kerlenton/mcpsnoop"
  url "https://github.com/kerlenton/mcpsnoop/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e7ab00599b1be81183d40c3c3121e65aa7054ac616e0804a4b28e0d873f156a0"
  license "MIT"
  head "https://github.com/kerlenton/mcpsnoop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80e6eea12f15d9a6829d497e0ff8e4529cb2bf07d06ef0dfc284eab52d34835b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e6eea12f15d9a6829d497e0ff8e4529cb2bf07d06ef0dfc284eab52d34835b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e6eea12f15d9a6829d497e0ff8e4529cb2bf07d06ef0dfc284eab52d34835b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f8e321f24e2cddca791c9f19796f4d134f7e6aa10ae93f9f49f24665d5e5968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a420b50cdc155c6ead1a84a81aa376318f432d8736e3c700f0d958568b1d81"
    sha256 cellar: :any,                 x86_64_linux:  "047160897178e03473b2b69d077bcbc675827396978a641c787e6b6368111450"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mcpsnoop"
    generate_completions_from_executable(bin/"mcpsnoop", "completion")
  end

  test do
    ENV["MCPSNOOP_HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/mcpsnoop version")

    # Wrap a trivial "server" so the shim writes a real session, then check it.
    system bin/"mcpsnoop", "--label", "brewtest", "--", "true"
    assert_match "brewtest", shell_output("#{bin}/mcpsnoop export -T text")
  end
end
