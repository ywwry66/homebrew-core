class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.11.tgz"
  sha256 "61cbb40ccc715cf9d20f5e3cb843bef41901025b76574b7fb514e0b84a552df6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e152ffc4ee786eb3ff96ff3be9b347eb435b929df443dae8696373f5c5b8807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e152ffc4ee786eb3ff96ff3be9b347eb435b929df443dae8696373f5c5b8807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e152ffc4ee786eb3ff96ff3be9b347eb435b929df443dae8696373f5c5b8807"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea5a61e1745ff3378e4d5ddab5f31c51cbfd0e8ca8f099092cffa04f43f09fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cd4dcd65ebd916b09c33ae570e80469a9a22f5c6d1ea0a5f72be4cedf6817f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd4dcd65ebd916b09c33ae570e80469a9a22f5c6d1ea0a5f72be4cedf6817f6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    prebuilts = %w[
      @rollup/rollup
      @rolldown/binding
      @tailwindcss/oxide
      lightningcss
      vite/node_modules/lightningcss
    ]
    rm_r(node_modules.glob("{#{prebuilts.join(",")}}-*"))

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
