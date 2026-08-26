class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.107.2.tar.gz"
  sha256 "0a263f94529c5c714f8507b79fb6c5b02508df87322ad4683ee0c80991684f34"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa834eac4396094643dacba3599be30e53b14b45ef29cd69336fdc87c8ca1565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa834eac4396094643dacba3599be30e53b14b45ef29cd69336fdc87c8ca1565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa834eac4396094643dacba3599be30e53b14b45ef29cd69336fdc87c8ca1565"
    sha256 cellar: :any_skip_relocation, sonoma:        "84f055c72c471dcbc3bb565531a3b27f4d7653a1712270323509527c51eb453c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5ac2880d6fbbebdef03fbd95771a5d38d406cf4377df505334960d3aaa6c8c"
    sha256 cellar: :any,                 x86_64_linux:  "8855fc4f97058e6cecaed5fce5be4995f6481f4a7e8b3f4c65e3cb4797025be2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
