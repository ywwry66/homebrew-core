class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.6.tgz"
  sha256 "321cca18367aeaac94fce4576c482139360d24d90ebfa80ff7edb574b0558d6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05cbae540ae083a894eb22bd77ec6957ebf4207c163877dde5595bcb7b2e0a36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
