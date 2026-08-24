class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.1.49.tgz"
  sha256 "1448cf35c4cd77af0eacb1ef6a8231d4bc7fe8c28ea9449f8e19ba3ef866aec7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e93c7a36411a5842232a95c9ebdfb25b9b231cb3f0773bc9f4f3a9eb4882e7c"
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
