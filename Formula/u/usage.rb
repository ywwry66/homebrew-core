class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "d8e1fe100a404bffa93f6dc8222ed2c54a44018ebf772ecf47f2e3e1c0a4c15b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e28e0a454a28c8404ec176906a282516c9ece7f2a51ec3f1a813ed384941169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029c3036b60fc11d1add7ff55f84b7c2354e9586d8ced68cdb58f8789c693f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02b702a4123ba05f531f331ddaa21e68880f96079ce697e0400bdb9a8674fe4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "282bbafb323d1711bf68043503c1ef849a0862197e4a32dcbd18969cf30f1132"
    sha256 cellar: :any,                 arm64_linux:   "a3409055f6ba1fb549f09522645bb3dea24874b9c69c04086e71396ecf0db006"
    sha256 cellar: :any,                 x86_64_linux:  "026d70076f744c08c21c288a369284ee073cb5a2f6f36692616d14239854ff17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
