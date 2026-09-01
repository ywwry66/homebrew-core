class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.5.tgz"
  sha256 "837b119cec9a95c8eb991cbf6641d172b6d3943adb5df57a27e86b22d9eba3ff"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5314f3d114de0384a793438e96f370035615421ec9546e9fe64f30fa840d5e2d"
    sha256 cellar: :any, arm64_sequoia: "5314f3d114de0384a793438e96f370035615421ec9546e9fe64f30fa840d5e2d"
    sha256 cellar: :any, arm64_sonoma:  "5314f3d114de0384a793438e96f370035615421ec9546e9fe64f30fa840d5e2d"
    sha256 cellar: :any, arm64_linux:   "ddbd7668715be0e6cc4eda03690733a14d5133689949600f0fb732c7f239d3fc"
    sha256 cellar: :any, x86_64_linux:  "18153584a5890a4cad7609988dc3ba3b8bd2b57029446df5a08332d582564195"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
