class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.39.1.tgz"
  sha256 "22594a76d0aec0cdabd41050fdd354381c106c48a2f8f5edf98394b4b5e987f7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4007703c5882e16a833e766c568ba1087cd27f20a395363a76f5982aaff28eb6"
    sha256 cellar: :any,                 arm64_sequoia: "4007703c5882e16a833e766c568ba1087cd27f20a395363a76f5982aaff28eb6"
    sha256 cellar: :any,                 arm64_sonoma:  "4007703c5882e16a833e766c568ba1087cd27f20a395363a76f5982aaff28eb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d11b96ef4ea48212913a9296e0c470a4713b04c49e276f4738d3f5311f3f908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970dccf6e6168e18879cf0c535ccf5e8c0fb7b7df384eb3f48a9fb44cbb1c7c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
