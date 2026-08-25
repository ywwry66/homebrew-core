class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.91",
      revision: "721aee94a408089ac70c5e0b8fa4d5e2169456ba"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0c1a4faa26671eae83da834b9156c26c48d1f5c6377cb63fa6c1ade83f010a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c1a4faa26671eae83da834b9156c26c48d1f5c6377cb63fa6c1ade83f010a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c1a4faa26671eae83da834b9156c26c48d1f5c6377cb63fa6c1ade83f010a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "49acea48e019508d655ffa279f553edc197416403966793c50cc13dbccb07bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5538ac5aceb0fa2e6a53bb8793603978487d01621397159ce1f09d3e8709c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56173863b62304711983a09984cbcf803ee87af6bf6e525320a56975d137eb0"
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
