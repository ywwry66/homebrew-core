class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.14.0.tar.gz"
  sha256 "761b64e16fc13fd2c772338a1a0503ba21e763b0e287185176a900cdaa5ea432"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcd339faabe943d37147713864e8fc0d03cdb6470caf632d49496145490ac8bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd339faabe943d37147713864e8fc0d03cdb6470caf632d49496145490ac8bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcd339faabe943d37147713864e8fc0d03cdb6470caf632d49496145490ac8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d7cf1ca722ee3ca05441baa663abe2bd722af20d9e42ad195f7a63505aa8753"
    sha256 cellar: :any,                 x86_64_linux:  "36c5cf7006fff4dd45c669ab70d35efda3d3fc8caecf5e9d987dc224e157f455"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
