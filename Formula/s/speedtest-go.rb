class SpeedtestGo < Formula
  desc "CLI and Go API to Test Internet Speed using speedtest.net"
  homepage "https://github.com/showwin/speedtest-go"
  url "https://github.com/showwin/speedtest-go/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "01c518f34eefbb6653a33538bb27daed4ef56318741b3d2d5412e9a3d81bed6e"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  depends_on "go" => :build

  conflicts_with "speedtest-cli", because: "both install `speedtest` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"speedtest")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    assert_match "Available city labels", shell_output("#{bin}/speedtest --city-list").to_s
  end
end
