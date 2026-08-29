class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "f5c1f75633cce19c07dbb42017e16c09cc3866f666424c52189a56ae508457a1"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75a01fba37e1d1f2e32fe3b00752ac87762f2aab2c309377266dec7d27a02493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c5b21675685c2770aa36111395ff1ee4165b42181a5ef879d928d949052fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841e24e3cf04f1ef0554cc045cf048f23d02854374f282691d42bcbe2f8a3c7a"
    sha256 cellar: :any,                 arm64_linux:   "a7c3554656a818a1a8b4c6df037970300d663c25d637fd3af545f06af3cd20fe"
    sha256 cellar: :any,                 x86_64_linux:  "25ce5bd85460e4a04771389ff3f71e303366031cdef18980b7b37143720d9543"
  end

  depends_on "cmake" => :build # for llama-cpp-sys-2
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"shimmy", "serve", "--bind", "127.0.0.1:11435"]
    keep_alive true
    log_path var/"log/shimmy.log"
    error_log_path var/"log/shimmy.error.log"
  end

  test do
    resource "test-gguf" do
      url "https://huggingface.co/ChristianAzinn/gte-small-gguf/resolve/main/gte-small.Q2_K.gguf?download=true"
      sha256 "71bc9beaecd0a3c5f075b8959f84c4cdf6c27dbc39930b0ab4d7c443b9373bc6"
    end

    assert_match version.to_s, shell_output("#{bin}/shimmy --version")

    resource("test-gguf").stage testpath/"models"
    output = shell_output("#{bin}/shimmy list")
    assert_match "Total available models: 1", output
  end
end
