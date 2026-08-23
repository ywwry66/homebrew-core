class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "8d1cb5f778be6fd941184dec07e2c8255827442638c6311a11a32036902e2090"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf72faf3d9895dfc0876dee26b903a755806dd4b632848cc0824adb86ec060a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf72faf3d9895dfc0876dee26b903a755806dd4b632848cc0824adb86ec060a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdf72faf3d9895dfc0876dee26b903a755806dd4b632848cc0824adb86ec060a"
    sha256 cellar: :any_skip_relocation, sonoma:        "735316d0f11a0141c84aa4ad81d333109b7bb276450f8a1ed8b66cde6da885bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f0b3cc5dcfde96dff8e7b43af4dea7305bb8a0d61d1d20acc983f44c24c1ecc"
    sha256 cellar: :any,                 x86_64_linux:  "8ddbf85ae5d6b219baef1d1898ce397dd0a5a2246b8b36a1d94b399ae22d40fc"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
