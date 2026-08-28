class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.6.0.tgz"
  sha256 "fb72bb436ba94ed6e47fe3f02e3e15dc9715154e452a639bf77e4c9789aa280b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8960a711427a849b5e9271cc846b054a5ed76a753ff686501d1dc890c992145c"
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
