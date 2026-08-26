class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.2.4.tgz"
  sha256 "401593b18cfb6cb478c0b452e75aa1e38f6320d9a9eda390d68ad92c4f8d4522"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30131aa850f41e3ecacd02d393f4a8d5d0eeebf041194ba1859703b2d6940ce1"
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
