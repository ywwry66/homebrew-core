class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "a262600ada8d3450c46f31d4546000ffd767649863403df0282d11ea6ac7f225"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a2ac08c090c80282a76cf3979af3d0ae0f196a9686907178011f5b02360462f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8df3b162701e0a40e26f294084f1c36505639978e2f0d2bd8e807b2b79c5f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e5a3b8e471bfb5b2797a9b2a6feb674ba4fffcfe887c70800a506f7d82e49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06516c015cd6d5c6c429055fa215233f14427648cbaaeb3c30b16d1bf5ad8359"
    sha256 cellar: :any,                 x86_64_linux:  "f07dcecb210a665ae3afcf25be92aca16374b66ede0388b18715ff8d3bcdf0d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
