class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.9.tgz"
  sha256 "d8cda3c4af670826759c31e82ebf3e41268766385a534756a8eb5266612e0153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d2e92f860231bde6996716e6d01d3ab3d9306174b6e58dec8a218bbee4a41c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
