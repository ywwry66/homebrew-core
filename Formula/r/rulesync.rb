class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.16.0.tgz"
  sha256 "ac6e4b5f21a1ed38bd737900b4b829015b1b48236a4142e5e7f4a99177a2c47b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818845685fa4c5687e77222de48b859fdb8bffbdef47701e9828cd7a7c93f732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818845685fa4c5687e77222de48b859fdb8bffbdef47701e9828cd7a7c93f732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818845685fa4c5687e77222de48b859fdb8bffbdef47701e9828cd7a7c93f732"
    sha256 cellar: :any_skip_relocation, sonoma:        "2773c59c9f6c39dbc10de196404b37aa270194fbcfb20c683c168fcb388bfdb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2773c59c9f6c39dbc10de196404b37aa270194fbcfb20c683c168fcb388bfdb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2773c59c9f6c39dbc10de196404b37aa270194fbcfb20c683c168fcb388bfdb0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
