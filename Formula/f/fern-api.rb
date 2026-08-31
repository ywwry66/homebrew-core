class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.109.0.tgz"
  sha256 "305aaed67e527836361aaaad1ef6610ecd3526aa130f4744e32d0c05e14abc4c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "931cd2dad4a6f9f8033ad33f3d1a45a8ba1796cac17ed11d6424fd527faa123c"
    sha256 cellar: :any,                 arm64_sequoia: "931cd2dad4a6f9f8033ad33f3d1a45a8ba1796cac17ed11d6424fd527faa123c"
    sha256 cellar: :any,                 arm64_sonoma:  "931cd2dad4a6f9f8033ad33f3d1a45a8ba1796cac17ed11d6424fd527faa123c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a77ddc4ab04e5557ca494ba59080ade57e6ed323a422a89e28b8549fac1552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ea5a3c26868ca336e0925e33db91b4aecbabf549386e58585c0f0848676a1f"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
