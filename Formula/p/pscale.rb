class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.325.0.tar.gz"
  sha256 "db4ed49123cf47e0e558f6370f3b906e2563497d15b230927328d99c28e178fb"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b24ab668cad42ca1e97a2bbfcbfc69763b9bdb6d7fcaffc11571d75fc9cf3e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a8d56c1e1af32b57f4e98e4d93aa74aa4258fccb0356155aadcc1a7953267c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08991982adbd86e62faebbe56721dcc8600f81aa577e73e9e5cfec6ca6af5fd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d7595ff3f724794fee0e920bbeacc6072a43db286ddaac89ce7bf31b375c2ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf6132880975038186a7bb60c60e1ba383a43e94577371663e9f84d5e4df1624"
    sha256 cellar: :any,                 x86_64_linux:  "5b00b788d4d44a76db5f773e3aa6c0d3b61681a214fb7a32cc85ea39d0e036fb"
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
