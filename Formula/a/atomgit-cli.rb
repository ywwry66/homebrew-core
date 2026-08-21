class AtomgitCli < Formula
  desc "Command-line interface for AtomGit"
  homepage "https://atomgit.com/hust-open-atom-club/atomgit-cli"
  url "https://raw.atomgit.com/hust-open-atom-club/atomgit-cli/archive/refs/heads/v0.7.2.tar.gz"
  sha256 "100a177997c7c6199f9d8633fe4cebc5ec6d974a807e1c5318d2634ba14c008b"
  license "MulanPSL-2.0"
  head "https://atomgit.com/hust-open-atom-club/atomgit-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Version=#{version}
      -X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Source=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ag"), "./cmd/ag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ag version")

    system bin/"ag", "alias", "set", "rv", "repo", "view"
    aliases = shell_output("#{bin}/ag alias list")
    assert_match "rv", aliases
    assert_match "repo view", aliases
  end
end
