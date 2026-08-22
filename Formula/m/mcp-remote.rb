class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.1.43.tgz"
  sha256 "0ce36d4637b8910d61a067d0e8ad9ad0f889e3900246a71328b26b7693d6299a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5c5a4fd4bda7f39e477de7e8c1b3b33f6c659f42a958ff931ce11a8d161d92d"
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
