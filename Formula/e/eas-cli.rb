class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.4.0.tgz"
  sha256 "6e775eae9a618b529b0b6cedbe99eff3dc8ce59ccba251c476c674d520894945"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f86ac0b716e4c1974c12957c528df420f906de330fc51903aa13307fe8e7287c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
