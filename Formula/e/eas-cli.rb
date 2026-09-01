class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-23.1.0.tgz"
  sha256 "2677909a17c7e4be11e7701f6ec2461e8d193997c512de90152b5675758424ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f8adcc85e140c855839ed5fee78fbb9448d1a24a6c2819379d5babff5a046cb"
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
