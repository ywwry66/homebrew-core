class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.26.tgz"
  sha256 "f67a3a27a5afbc957ac092fbfa60dcce3dae4c504b47c882ef3112a4013df98e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e0af9f98add5bed4b849ab6a76ce910edffa324ddda2c7328dce6bf7a11ae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e0af9f98add5bed4b849ab6a76ce910edffa324ddda2c7328dce6bf7a11ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25e0af9f98add5bed4b849ab6a76ce910edffa324ddda2c7328dce6bf7a11ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "123bb536bf863edf478e22ec4ede3c45d242819723775d91b2638e1c54237175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b561167c9c690b2b25d9dbee6cbf8e1e2db5dd136734a91aaef0678cc2a73d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b561167c9c690b2b25d9dbee6cbf8e1e2db5dd136734a91aaef0678cc2a73d3f"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
