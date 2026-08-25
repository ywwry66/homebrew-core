class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.9.tgz"
  sha256 "1cbaa08ff448e851b42de1602d63b6fad7c6a3868ca057689371cdcf50b1c059"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de76b2fd2c66eefcfd3bd2db7394ba5b6e19a64309c69dd2cdb1ca9ade737996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de76b2fd2c66eefcfd3bd2db7394ba5b6e19a64309c69dd2cdb1ca9ade737996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de76b2fd2c66eefcfd3bd2db7394ba5b6e19a64309c69dd2cdb1ca9ade737996"
    sha256 cellar: :any_skip_relocation, sonoma:        "de76b2fd2c66eefcfd3bd2db7394ba5b6e19a64309c69dd2cdb1ca9ade737996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de76b2fd2c66eefcfd3bd2db7394ba5b6e19a64309c69dd2cdb1ca9ade737996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0919e286dbc592c467c46cbc9e3c5d45f5483617376d0ca4b77cebd088bd549e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
