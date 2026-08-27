class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.2.5.tgz"
  sha256 "06b6bb1997afb6dc9c60c080e25a8d1ec456e3cd76f5f725bbbd8d01f5b6997d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a4c0a19296ebcdcdff8ad420972f3e1d253a128cf707f7331ca9333e65eb5b2"
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
