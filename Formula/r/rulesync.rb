class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.17.0.tgz"
  sha256 "1fecbe98c922b47aafe506dd972a28c22d7524ea8befce8fa0c615c486632d7a"
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
