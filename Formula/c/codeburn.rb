class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.22.tgz"
  sha256 "16856cd5b910eb16a632ac3c875f93118bf37c1106e55461ced5f7316f4c8498"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e94dc5caddbded2cf3e5ed6e1a090022cf9e13529234d976125469c692afb7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac9ec86ae74cdb13224578d3c67796a92526f68c18263273c2df23f799f1e78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
