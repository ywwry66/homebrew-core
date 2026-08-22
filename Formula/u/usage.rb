class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "9742bf204947556bc5f2eb7715fdee4350435aa764527e916efff14c0b355efa"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c0ab2a24e2958d24a06252cda3b037303968453c529e534e964d2a031120cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b010e93da0b659f06d0120aa9a8e643f77efc5a3d4674e5cdb6d901faf55c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99ab3a7e5a6591c5ef30fb82228eead1fea1871beb2e76e8146d3800b5d0e288"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1dbdf0107ff160054d0cc3c89c7d7358a39fa99579c9eca25b80ef09a10e03"
    sha256 cellar: :any,                 arm64_linux:   "a9e4090525d3749f33080db84153c9b6fcf6614fd3c5a4055f974535289a1ab8"
    sha256 cellar: :any,                 x86_64_linux:  "db643d2a88a7999e32cd78391ac9bb0aaca1ff3f927b440a2155941b6f3c34d4"
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
