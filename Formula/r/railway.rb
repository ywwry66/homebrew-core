class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.47.1.tar.gz"
  sha256 "88f5696de765f0230953349f87bdd05076b977083ccc52dda1b4d1626b00dca0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a702a1c8338faa5ef50a1e84fdb62fb8d846aeba508ad80753a460f2919cdf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227ecdde6967f3befdbc96d75d97e4abc37a7f0af3c375a0bdf2a8618029c2da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbde932cd2783d370a8078379bb96456694fdd6eca77d59119dd66c9f704d7ee"
    sha256 cellar: :any,                 arm64_linux:   "d7f50028ba0ea1b781556a51916ef6139e81a7753787fe76de266fa4a92ac2cf"
    sha256 cellar: :any,                 x86_64_linux:  "852e5614ed9fcd9468883c39b124259c0834d891be2baacb824814a6ce7ab3bd"
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
