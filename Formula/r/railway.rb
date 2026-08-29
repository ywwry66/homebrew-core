class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.45.10.tar.gz"
  sha256 "86b10a39fb776e86ac852b6531abb2e35b3629d14c7b98d17a1d3a66ec7632a7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b797114af669fb2bb85f47603f42fe88d78a723603daa451d898eea895c99fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04935e8b87e2518b5942630be119af75506e65647d78fb0784b113a4350b22eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53af979de725763eda5009f73e7b76fa3374787b894d5500b37a506b0b7018bd"
    sha256 cellar: :any,                 arm64_linux:   "502119fdb18c8540616815d16eb2fdd72956718f00189741b39e5ab9c605cdd2"
    sha256 cellar: :any,                 x86_64_linux:  "d379916f921d7b52836808d51541654e25223feaea3b06bc03c6f261c01b5354"
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
