class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "5a25407c941d5b3fa1aa1c969ef884191afa0768e7873c82bca4db678c601b8a"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "config: set telegram.api_id and telegram.api_hash", shell_output("#{bin}/tele 2>&1", 1)
  end
end
