class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.128.tar.gz"
  sha256 "662fd8dd5d836547e45aa91876f4daa867397af7a9d83eaa0cccd9fcb6876a6d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95556858720ecae08db6b9931ec919854da5055c5b695cde2259f97734ff47b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95556858720ecae08db6b9931ec919854da5055c5b695cde2259f97734ff47b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95556858720ecae08db6b9931ec919854da5055c5b695cde2259f97734ff47b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72e925dab567f7594e0f392788374a2eb8546ad3cd0537ceb14c3559061405e"
    sha256 cellar: :any,                 x86_64_linux:  "f9ddc0354ccab41b6749b22c17862f1ea00c5d905be162136c0cfda4a034e575"
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
