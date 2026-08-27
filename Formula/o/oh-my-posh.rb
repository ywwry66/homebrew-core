class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v30.8.1.tar.gz"
  sha256 "23da73c3a25ed50b496a8c978b7ebf2b679aef638121a4d465fb5d9e84735c79"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de082c80c769ea132f1dd492a654d4ee1392aff60340148d10fbd9b5cdc32971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba7f560da89a0212cedf9090518a7b81d2ce5b0ad7828d13c461570607433ccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c0082064ec448e898931d0442c125e32e1c58f1919e126d3ee55ed56f75b6a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab11143cbdff0e87490aa3c36b9ec82f552bf73a8831c2f4363ed67faa2565d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051c3f1898b07b5bafffd85ecbde424e8372af9b51a3de51bf8f3f35a424f809"
    sha256 cellar: :any,                 x86_64_linux:  "9f40bb5196e67e4bc47aeb3b224442cff177625e902047120971de62c98348a2"
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
