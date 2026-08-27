class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.3.0.tgz"
  sha256 "a0ad4c9f129c918cbd1565a4aaae4bb3f74b215096f122aa5a80a38e883f5e27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83962e841a01241733899c7ba3bd3211b9276e0e26e35236cfd9e6bb840041e9"
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
