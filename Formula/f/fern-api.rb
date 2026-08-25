class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.104.0.tgz"
  sha256 "887506329472dd266ec0c0908ad2b8a80b966dd8c32d9055638e57d9d58f5de2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76dab7eb2df4fe1c5f5e03b02765fff7ea39d5c3a04c55821dcb7b2de147346a"
    sha256 cellar: :any,                 arm64_sequoia: "76dab7eb2df4fe1c5f5e03b02765fff7ea39d5c3a04c55821dcb7b2de147346a"
    sha256 cellar: :any,                 arm64_sonoma:  "76dab7eb2df4fe1c5f5e03b02765fff7ea39d5c3a04c55821dcb7b2de147346a"
    sha256 cellar: :any,                 sonoma:        "500d61b9b8a2c28105d7d9112a71dd414bd2a62e62c2a41c40569e9496163f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b882b00d6e128d483b7447fd469a12d333560642922f57352964a297a0d454df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "120dd5611e3e6891d2ae843e3021b0be3e68bbf6f1089517b5917b4366e4a3bb"
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
