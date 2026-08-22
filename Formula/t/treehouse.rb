class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "c8941c4df4e3193e7a27698d521f2f3d86b8cf399cd7ae8206395ee2920ce4de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b362851c9cf4ae0d0447ea41b1ba7b4d75b04362ca539a393d0aba64fc15eb75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "192fcb68d3f27b8b24213b8d0665f4f2c81a41fcb01cd69366fc5eb6f0d888a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcc08bd00a68c8e25ad4c6179616c01b4b2d1a8d7c8c66b43ca4616efabb3059"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b92c94b5bd1024c82011c1938bd753d846a1e76cb4bc5b8bb68a1a6fac88d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f01428541422efa7b152d0afce7a8149dd444d2f055b4dd0fda0e082a5fdac8a"
    sha256 cellar: :any,                 x86_64_linux:  "44be09073e4667f1e923db83573c7dbcedc7fe859b7b56bd7c25ab68272c0c6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end
