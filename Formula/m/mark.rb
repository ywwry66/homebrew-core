class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.16.0.tar.gz"
  sha256 "d9c6b4cd84652373d113e8f73e871ab210d0bb16a89b8e95637ee7615164357d"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37e30d3cba8ee696b0b1d3f5a91870ecba6218490d8251a234650551ab97b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37e30d3cba8ee696b0b1d3f5a91870ecba6218490d8251a234650551ab97b33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37e30d3cba8ee696b0b1d3f5a91870ecba6218490d8251a234650551ab97b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43ee38d136f52df951911789f680200e52812a663c03ae5e4cd517c33e1d9727"
    sha256 cellar: :any,                 x86_64_linux:  "cccdf136d8f8c0781e8055db42a8e5a991d48dca5d2078f46fe19bbbbea86c4d"
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
