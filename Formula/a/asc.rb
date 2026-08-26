class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.4.tar.gz"
  sha256 "8a36292f3e63fd5408c3232688a8e257c159c9f9ec08a34510e1ae2b40559885"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acef7e1383701cb91c4aaca2b452e2c61ffd6491bc9a2da9da011bc64ea6deac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad4e5e9a988ea7788fbafe1040399350d49b81019df4a16a0427a598b5f0404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "facb464196e5bd3893334ac04d9e4c6744b4182a0a8bf5d0555ca6c20a774e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1fdc2d2bbdc7908a0bbca41d8dfa1ee9e93dd129580f0167f276e10a6840d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0e0cd020b92a9fe2c1a9a2e7cf3c35e257304227e3956d8c385bcd980efe75b"
    sha256 cellar: :any,                 x86_64_linux:  "8d1e4cb94c5b3d3c2a16ed9dc6c80cb08d462e19c70457c1a7c66fbc393c7e3b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
