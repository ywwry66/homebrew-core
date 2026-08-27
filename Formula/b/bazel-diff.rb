class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v45.1.0.tar.gz"
  sha256 "ba83f478e19addb3a7514344fbb0ff6a1bb9d5fb2e4e72d9f447e2da7d617e12"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e559fe592d5eb52043420d85cf59dc5e949186ccffb829f1422989da603bb29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e559fe592d5eb52043420d85cf59dc5e949186ccffb829f1422989da603bb29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e559fe592d5eb52043420d85cf59dc5e949186ccffb829f1422989da603bb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc71a3340056061ce67a6837c4ecc1065920561169e188b82b085401efb4f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc71a3340056061ce67a6837c4ecc1065920561169e188b82b085401efb4f60"
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
