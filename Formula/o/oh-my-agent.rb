class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.7.3.tgz"
  sha256 "4f14162ee20d849917b01a17ee58e1c74cd2eca49ce424808d56f866de2bef26"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5f232e777ddeca0d3b44ff76b77d68724a18ab73767d713c3360c63a940c95d"
    sha256 cellar: :any, arm64_sequoia: "31595581c2f78f38366233d162c4c2b553564cd100e856a66233e7b2c7354aea"
    sha256 cellar: :any, arm64_sonoma:  "61539b19ced270a7505ccf53ba69b8c84aa8e6b80a1a8a9075d5aa9063798d7a"
    sha256 cellar: :any, sonoma:        "ee4787aee2734803b3fffa53f4607e72b7c5dbc3dfe9dfe0094506b03725a42d"
    sha256 cellar: :any, arm64_linux:   "e0ec07962247620e553fdcc320b1863c0b1093afd214e46995b4171a90b25ea6"
    sha256 cellar: :any, x86_64_linux:  "f61e294540df0cadf7660a9d8112f16bf8e9b2056742fe0b6ca614fa75a9f562"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
