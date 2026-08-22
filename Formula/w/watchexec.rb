class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "86da4682d38bd8357fee4652f02896db409dd40d35cef5582451f6c1adc2271f"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "210d95978dc025c10f4e8b948beacbf8d0ff9d2f41ed4861f3900ec8863bbd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288493819b278f06d26caa1738eea0f4b5b10767c9f8969cd3db518bbff4b7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87639e5acce8089ec674d74ea6f293cb646ba0d1f06899ff8c932e44ca85ea98"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f7a5c8b7b4f88de0a5b1107b54f2a8364c08f122dd313b5e2311c77b503efd9"
    sha256 cellar: :any,                 arm64_linux:   "3dad7bb80c956949a30927c6c32dbf6dda8745dcb010ea8c98f1d235213cc155"
    sha256 cellar: :any,                 x86_64_linux:  "4babc521933b723e75b0803a2cdcbd923aca6c32e0db3509af8ac41dbbc736b0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
