class Glci < Formula
  desc "Run GitLab CI/CD pipelines locally"
  homepage "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci"
  url "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci/-/archive/v0.7.0/glci-v0.7.0.tar.gz"
  sha256 "350367daf09af8da22b0d4376222bc004c43b372151d6206b3ce717857c15d62"
  license "MIT"
  head "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci.git", branch: "main"

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = %W[
      -X gitlab.com/gitlab-org/ci-cd/runner-tools/glci/pkg/version.Commit=#{tap&.user || "homebrew"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/glci"
    generate_completions_from_executable(bin/"glci", "completion")
  end

  def caveats
    <<~EOS
      glci requires a running container engine (Docker or Podman) to execute jobs.
    EOS
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
      test-job:
        stage: test
        script:
          - echo hello
    YAML
    assert_match "test-job", shell_output("#{bin}/glci jobs")
    assert_match "test-job", shell_output("#{bin}/glci show --plain")
    assert_match tap&.user || "homebrew", shell_output("#{bin}/glci version 2>&1")
  end
end
