class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.3.tgz"
  sha256 "c307d28c7b953331653c78317651ef8dfd847ac04b9b0cc3e6bd1fcf449cccd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d0afc2246e37c4a5725dd7644f013d5bb485028c3a4dcb87694d27b67e59369"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
