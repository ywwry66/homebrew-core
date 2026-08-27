class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.127.tar.gz"
  sha256 "f278804300443b5a9c14dfc9e495d0ab3d93676b01132ae0623618053fa0bfa5"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c166933555a92276bdff16f0dcd3b6f866592b89aa4b69f01e478dac002032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c166933555a92276bdff16f0dcd3b6f866592b89aa4b69f01e478dac002032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c166933555a92276bdff16f0dcd3b6f866592b89aa4b69f01e478dac002032"
    sha256 cellar: :any_skip_relocation, sonoma:        "c847468214c2cfb29011ca62096ace4c6dc0e63174230ad17fd2226e32886d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8559269ff00f0c0798f2b075b0e4526a970ea07722b5dbd93bb417d36c365ad3"
    sha256 cellar: :any,                 x86_64_linux:  "e9e56c912d20feee5011914dd9ae4167033ad1177c5e5b71f0fe7c549b90e39f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
