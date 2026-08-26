class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.93",
      revision: "ade6c35e11a3aa1f95413227760aed7bdb402acf"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f06f39928c543fd68d6ec5a862787988a3eaf6a2b58a9b29df99327aa46834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f06f39928c543fd68d6ec5a862787988a3eaf6a2b58a9b29df99327aa46834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f06f39928c543fd68d6ec5a862787988a3eaf6a2b58a9b29df99327aa46834"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a1546aaff9d522db448eb11dc36ce1c91c7bc3502a50a7c6da6b6c0ffc4e065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d376b39a6eec0666c5573e4f51fcae015997095351e6a8e408922d9147ccb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57a0fd6937c3827bcbf1208f7454600eb2054eaf08d3990748a08be822d5a8ae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
