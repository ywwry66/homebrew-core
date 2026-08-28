class Shimmy < Formula
  desc "Small local inference server with OpenAI-compatible GGUF endpoints"
  homepage "https://github.com/Michael-A-Kuykendall/shimmy"
  url "https://github.com/Michael-A-Kuykendall/shimmy/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "fbac58683eaabe87fe1cd00926b6bfbb8be8d042253bf6ec2965bce8149b675d"
  license "Apache-2.0"
  head "https://github.com/Michael-A-Kuykendall/shimmy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9444ab7a168600c349ccd4ceecbe1fe6a6b8d842528723e88f2c19a0ffc82f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e19b184b50a422d72c9b57e978c3a4e37e2c83ee911c55f8d9048814cd67ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dbb1d985126dff10187dd8ff9f96a6d39b018bc7c046a4a39e28ccb27f0caac"
    sha256 cellar: :any,                 arm64_linux:   "f4121cb2bc6c692447077af970c58b79907637d15107f0dcf5710f2a1cc2e0f1"
    sha256 cellar: :any,                 x86_64_linux:  "b5940dbe62ff9d7af970c560b64fb27df685e246d99d2acaf2a7f5aa808cfdb9"
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
