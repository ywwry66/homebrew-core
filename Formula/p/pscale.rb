class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.326.0.tar.gz"
  sha256 "af2379f2e7e793b618a9380b806a8aeec7b7e8926051a4a2e647dd46fc0ca0b2"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ee908e1a1dd3483d32c45d9c6d371900784d6fb72cd706a9874354c19aea4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8106f59fe4bf77a1f5c607242369021b8157b69362e8f29132afc66722f2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b2252176ea0d90e0b7b9863263231bdecee16f8a5d13cdfe3a7899f0e28b75"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca029fa266be1b80ce3cc4cb77320ffb7af38d8fb5806191e59805bdeb5cfd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdab238dbe4274f0305700337d3b38e6a9ee3d8cbf9fdc21a5733008b23a93ec"
    sha256 cellar: :any,                 x86_64_linux:  "6f8d0ad2f34dc41b5338d401b3a6ed694d35978545e77b92bd36c33d7fbda287"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
