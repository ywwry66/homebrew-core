class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.4.0.tgz"
  sha256 "6aa2bd895b3ee7761214ac3bdea77b6b4a27db4421b6399980a1166575f6e793"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80dc48a0ef7b464147810c2013a03939d9295dd50e06ddae9d16bbf462ec57e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end
