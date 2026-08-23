class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "8572780dca68d49090bd46ee124a9195fdec75b18ee96b782f8da09490bfe0d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "479c2d06d5262bf99a509e8a490a27ec7417184048d349ad74f22a78fc3dc904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f858a062cc31f78dfeb6e6900118745acf04ff0665214879be24f60ac15a4c5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2f373aefa7b6147ef72dd0fde2624b9a19bc875d23bebf6b77ce0e1a876ed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "260cbf854e5ccafb46d440e4416d193fcba3303264546ef63c2b77b30bf24735"
    sha256 cellar: :any,                 arm64_linux:   "a961b8fb9be16f221a418a13f3c77e58965f1d35b0ffe65eb844c388cccb42e7"
    sha256 cellar: :any,                 x86_64_linux:  "8065be39989320380aa4bd7bf77933e88b045e3f44bb03fc5cfeec6dd0d9fa6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/obscura-cli")
  end

  test do
    output = shell_output(
      "#{bin}/obscura fetch 'data:text/html,<title>Homebrew Test</title>' --eval 'document.title'",
    )
    assert_equal "Homebrew Test\n", output

    # obscura blocks fetches to loopback/private addresses by default (SSRF protection)
    blocked = shell_output("#{bin}/obscura fetch http://127.0.0.1:1/ 2>&1", 1)
    assert_match "private/internal IP address", blocked
  end
end
