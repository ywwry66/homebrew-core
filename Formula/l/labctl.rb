class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.109.tar.gz"
  sha256 "56cf54c4630cda92bd6608ac3648b8fd67aabecab18510aa03773a21137515f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29101fef3d9756ddfa47befd6b65d6d5a3b3da8e8035f70447da62f1ad551199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29101fef3d9756ddfa47befd6b65d6d5a3b3da8e8035f70447da62f1ad551199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29101fef3d9756ddfa47befd6b65d6d5a3b3da8e8035f70447da62f1ad551199"
    sha256 cellar: :any_skip_relocation, sonoma:        "37210994f36e3d63b1d8ec6cdc1e15bb3b89eb84fa2a5d9176d7bbe008bc19b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd87478059c2157741d1522006015babebca7f3c82819aa84e24a3bfb92ef8b4"
    sha256 cellar: :any,                 x86_64_linux:  "353a38fa55dc1545525446be0c9766863138b71590fef4b9acbdfd22639355c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
