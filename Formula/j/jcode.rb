class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.81.4.tar.gz"
  sha256 "d765fdfaa58a98c01d97f2d6668d487d5906b05eb253952ad5f19bd369847b94"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a754a045a2fe804cd2646494c322a82e726316a1c5fbf56dc8a09cd397589c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0540ab10157d39907ad4b6e9284639e3b33e1ddee7d7b44d4b781dc24b4cc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c7818adc510af99b77995ce8ee7f1701f38c4850ea4afc07d76a9ffb6fedf4"
    sha256 cellar: :any,                 arm64_linux:   "abcdd73ee2848774ccacb27eb3c090af95864ee96cb28cfe29785e987696732b"
    sha256 cellar: :any,                 x86_64_linux:  "dd6d41977b5f11ac251bf9c6ad6fac1485ce579d1de184525b4f3c109fdc4125"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
