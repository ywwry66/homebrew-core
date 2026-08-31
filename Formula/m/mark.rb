class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.15.0.tar.gz"
  sha256 "d81159680527bccbb2c2fba0a99e4b137dcaf7321f1c2ed2ce9fac82832d2c78"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6804e5630971b280839c7ae8288dc3b0f4cc245d80193aa5f43b791e928170d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6804e5630971b280839c7ae8288dc3b0f4cc245d80193aa5f43b791e928170d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6804e5630971b280839c7ae8288dc3b0f4cc245d80193aa5f43b791e928170d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60b28123888b2dcf78b2be7864d8f6a07001303a318f1092ea57614b7fea1019"
    sha256 cellar: :any,                 x86_64_linux:  "5974a3d51fc2da56dee1ad2d47e5da3b4f5246354242498a0b7c87e887835164"
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
