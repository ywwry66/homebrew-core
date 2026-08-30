class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.1.0.tar.gz"
  sha256 "2cebea8497e2b0b9805e25a960d65020de0111cb7a3bed1f607183fde340e583"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9a556e434f8f2e873169ee079f164e3826a3584012a82b739e6007512edbfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a874746d364ba97c93b9974d7ca8b33c0aab90b191d9523ff53b0d8f12169e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1e6f48a23cfbdcb9a076b65d67084cd594d24bacc2a48a5633bea2a5d58878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd0bbc37bbb0e6c1981e791bcf990dce1c0d081027a14701e7dab17c61b451a1"
    sha256 cellar: :any,                 x86_64_linux:  "e102b65c6382ae499fe9f878bafb8b690fd1d8fe0a069cc1a3c13de9caf2b580"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
