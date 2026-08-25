class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.3.0.tgz"
  sha256 "4b29d3de0c4f16cc4856838ae2044f66c637e5568852086a1fd24b3ea10c46ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "249811ac06b30ee944d6cefa9f94cfd63288e75c6a5958633e0d5b49d53e701c"
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
