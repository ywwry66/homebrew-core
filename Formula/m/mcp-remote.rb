class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.1.45.tgz"
  sha256 "b29e2879ee36702223ab892c7ad683fc6cf4b0db7b8e995cdda501a775967d7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0ac1320d62e437b2a1b5c830c8f28c1d031df4326b620b18f2e67d5e8fd71e5"
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
