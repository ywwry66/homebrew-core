class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.47.tgz"
  sha256 "d182b39b2a030f598a0905e8a8b38c90cae261bce7dff3dfa3a76298cc6d58ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5372600c628764f032e8a20eeb6470ccee805002e77f4bc510023938ab227742"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")

    output = shell_output("#{bin}/gnhf --current-branch 2>&1", 1)
    assert_match "gnhf: This command must be run inside a Git repository", output
  end
end
