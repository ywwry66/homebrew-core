class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.43.4.tar.gz"
  sha256 "ebe84287c26648246b8b07a858e01ab05ce7538a6cbaa294424e208dbeb1b2f8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cdf717fdbf10d2d91f648c076cd31c8d8dc7e1dbdfa541aa9320352cc414d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f0d64dbe2a558e216c9a8e8d926d28ff7a3b1460a7dd0c66e71f6751aa07a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7bc832e0923295b9f364401d51ff5141d551408f6b3df5696e0ee87aab5d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "591e92b49c94936a29deca510273ee6df56fb572989b1dab56fb6399c0cb280d"
    sha256 cellar: :any,                 arm64_linux:   "51e42ebb0fce8ea04f78cbdc87b9901e3fcc10a632a896ee8afd3056177357f1"
    sha256 cellar: :any,                 x86_64_linux:  "d8185855b6a4c95063017e307d0d374c57c1cf89c72f21c3f2e15ad22660c01b"
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
