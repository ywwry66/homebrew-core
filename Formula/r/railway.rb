class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.45.2.tar.gz"
  sha256 "b309350e5018e8c812f1d5ceb851e6d20b5040cf37659b34cd8d9459b4f9dd60"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "848e2bc158a27e420a01b0e32949547537d3b7d4d26ce9972cbf2e6363a37857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f98477796e989ea54658168b4876ddf1bfebeeb2bbd71c72d823f58c8947b450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6365cd7bacf2395c224c142fdebcb34bdfc10dd3ad17dbd6c472173f6497e97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "66557ea1309130aeadd898eecb3c9b196375285670db76f1f9f7a879cd754195"
    sha256 cellar: :any,                 arm64_linux:   "2d0c1b922f86e01c6fe8fea719cda3ee5ffd234585c960ac4bf925d083fb90a5"
    sha256 cellar: :any,                 x86_64_linux:  "29eb8b2e5d47cb9e8dacc184493491d44752bae610ef89b1353c252ecd5a0d78"
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
