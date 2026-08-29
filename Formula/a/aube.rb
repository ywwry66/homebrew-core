class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "821e285925b4020ff005afe6431430d90cd196543fbfb95c5a6d4b9d6dcffc8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d7da502ee780ba444476c9860fa0f191b24be950b1376802ea4a8caa01f1383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f9db3dc6ad041cde92704bba85e205637755c8f9cb9cfc95ea4982cd2da52a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9fabc994674c8a9e5d5cd846e8137a8eb1c31a31c4e7ab5d9b98dc7e12c8074"
    sha256 cellar: :any,                 arm64_linux:   "0357040dcf889fe09a3eef1b64edc9923b17442530daf6e400a7d6788cd04650"
    sha256 cellar: :any,                 x86_64_linux:  "b18c711025d25cb7911abd98b0521348f00c0fc4d7f8cecfd7badea62307cbad"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
