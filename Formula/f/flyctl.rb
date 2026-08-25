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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "833890887cc85bec3d23df80d6da8d49195232437d99e8be75e382af3f5cb102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833890887cc85bec3d23df80d6da8d49195232437d99e8be75e382af3f5cb102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833890887cc85bec3d23df80d6da8d49195232437d99e8be75e382af3f5cb102"
    sha256 cellar: :any_skip_relocation, sonoma:        "d519de1d519fc9b1c0f62d4268b23b19c27c016cafedcb8b57d84b515a3fbf3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee10b159673055463b5a942b4ab405888e2f11a3482104a29ca85f63ab5fbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96078096cbf13110aacf497698da3f135c90535db03e21cddf228922c5e1da60"
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
