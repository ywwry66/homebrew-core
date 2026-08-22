class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.102.6.tar.gz"
  sha256 "225b34e6f7f26916f68947b33bee44ec21d3d3132a8e6568ddee9d805ed22c4c"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c4a7939647aa68e3d141c0d4e8cd569ac0503e56847e3c27c3f7a215fea9277"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4a7939647aa68e3d141c0d4e8cd569ac0503e56847e3c27c3f7a215fea9277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4a7939647aa68e3d141c0d4e8cd569ac0503e56847e3c27c3f7a215fea9277"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf3267a4628df7f8613c622248459da5aab6f56e30d7e8d6afd83a00dc81d587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e4dea8dee5a0b1b68e3091b36f5fd724ea00ac9a6a6a47a9f1208c5a085afe6"
    sha256 cellar: :any,                 x86_64_linux:  "1922bff635259abd833fafa8c2bec08e52c801ba23e0eded161be40330347524"
  end

  depends_on "go" => :build

  # Fix linking on Linux arm64 with Go 1.27, which rejects cpuid 2.0.4's linkname to `runtime.sched_getaffinity`.
  patch do
    url "https://github.com/depot/cli/commit/627f8a6dfad7e7f2f33c774d3aa22af9884f0ebb.patch?full_index=1"
    sha256 "bffa3eaea34bebeeb3c27fb9ed326137b8824a1ded170eeeb2cdd91c30dd48ac"
    type :unofficial
    resolves "https://github.com/depot/cli/pull/570"
  end

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end
