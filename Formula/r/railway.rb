class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.45.6.tar.gz"
  sha256 "c9230b67a7cc1e384a6235b994dd5b54405ee2f5ddcd4036c3c888faa658c924"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6174d13d6333bd2e5125ae0b7a69592886e8c6ad1c6ee58a9e3f431a7e8f4069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0de54b7150d4bdf51996e9246af4a2facfdff7efd7cd30483b383ab450b191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b504d74810444de53f9799b66ca7c6a3d2a5f2cd48862aaaa516cec7340be57"
    sha256 cellar: :any,                 arm64_linux:   "e0118fa77acc5fc8cdc20d338cea2a93e26a95bd1534c4b7d893aa2bcb249762"
    sha256 cellar: :any,                 x86_64_linux:  "98660c0253d272927d3aad1cf70e6104ab6659b83d91d484eeb1da0e9230a060"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
