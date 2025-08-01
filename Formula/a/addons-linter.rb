class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.18.0.tgz"
  sha256 "083cc2a01800df654021683939066521942a5e1075e02113425616126b75fac2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6bad77d75215e57406ae5b0bc2709a6a5ea00d8b4d226d0b157cafcd691074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6bad77d75215e57406ae5b0bc2709a6a5ea00d8b4d226d0b157cafcd691074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a6bad77d75215e57406ae5b0bc2709a6a5ea00d8b4d226d0b157cafcd691074"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5e5c3f3f4cdb3c8c9ce9d4ab6cacd8884d4a3a33580b5fa16dac3bd05ae72e9"
    sha256 cellar: :any_skip_relocation, ventura:       "c5e5c3f3f4cdb3c8c9ce9d4ab6cacd8884d4a3a33580b5fa16dac3bd05ae72e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a6bad77d75215e57406ae5b0bc2709a6a5ea00d8b4d226d0b157cafcd691074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6bad77d75215e57406ae5b0bc2709a6a5ea00d8b4d226d0b157cafcd691074"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/addons-linter --version")

    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "Test Addon",
        "version": "1.0",
        "description": "A test addon",
        "applications": {
          "gecko": {
            "id": "test-addon@example.com"
          }
        }
      }
    JSON

    output = shell_output("#{bin}/addons-linter #{testpath}/manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end
