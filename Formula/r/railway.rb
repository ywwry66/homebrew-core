class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.45.5.tar.gz"
  sha256 "069e3c2d40a6917840da6c086eb02563e6faf42db562baee3503c85691b1f2b1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "049b84887f8d602d47354db35043360012b9275c59c68ddbc4ee8138146ad1aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d3f0a9d65a119e6bc03836a411fb26e0fe9434e20bb83823766dedb9c54727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f41c56d19bc84d5d031d415b1e0ccab5c2cc8e822ac15f9d4117d94a946756"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c6ae399cf28e385ee0bde8f2ea0d89b756d3a1a8496ee8acf43611488a6d0ec"
    sha256 cellar: :any,                 arm64_linux:   "98c56c1a3200f57aa888a21ef37f2f6cb3519c86307bf2d991030f0cf468806d"
    sha256 cellar: :any,                 x86_64_linux:  "7a0b59326fe5cec761b89e9b03b8a8562053550bd4201729b5938ecb4f252a4d"
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
