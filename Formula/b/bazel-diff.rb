class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v45.0.2.tar.gz"
  sha256 "e0510eb15182900350a7efbcec0b78acf8ac4c86bb5414562e525c2c2271688d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae55642f2b4481d944bc90f6565d965056a52d0c070298df6c3c20fea9ee3759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae55642f2b4481d944bc90f6565d965056a52d0c070298df6c3c20fea9ee3759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae55642f2b4481d944bc90f6565d965056a52d0c070298df6c3c20fea9ee3759"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae55642f2b4481d944bc90f6565d965056a52d0c070298df6c3c20fea9ee3759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7817c1918f8f2ccfbf39c3b5751be8a09001c4d78bebbca773f24f76e7081980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7817c1918f8f2ccfbf39c3b5751be8a09001c4d78bebbca773f24f76e7081980"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
