class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.17.1.tgz"
  sha256 "c24f5e83293dcde24385610b4f332806a4483271133dd804e753d5d5183712ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b83dc3ac9fc46d2bc44b16b2150f658eae3e680bb1b4af7b9a29d6dafa7c406"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
