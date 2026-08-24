class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.102.0.tgz"
  sha256 "5b29a0cd88c0e1ac22a63558e04a11af85248b30f2024fce98c4fec5387da5e9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5521030cb8341779f32e2b7f5bbf1610e79cdfe27a269495e8db7be23f6c5915"
    sha256 cellar: :any,                 arm64_sequoia: "5521030cb8341779f32e2b7f5bbf1610e79cdfe27a269495e8db7be23f6c5915"
    sha256 cellar: :any,                 arm64_sonoma:  "5521030cb8341779f32e2b7f5bbf1610e79cdfe27a269495e8db7be23f6c5915"
    sha256 cellar: :any,                 sonoma:        "2fa9560edf522f4ebd33e0105f2ef04ad385edc6bc88413ea09a6912bcdffeaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b8afd806a47583522c42de8cc3871983afa1f0376d8e582445c3790601cd37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4f45ac764b55c61d09930628451d4ddd5161b41042252b3ef318553d09431c"
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
