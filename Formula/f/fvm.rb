class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://github.com/leoafarias/fvm/archive/refs/tags/4.3.0.tar.gz"
  sha256 "2e235266a540387d8a7c54472256abc2429d0770738e344bac89e24fa89bbfa6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62472a43cb288f9d6bae7c7055d0322922d3fdad72cce3f75dac3bf1631bde15"
    sha256 cellar: :any,                 arm64_sequoia: "f00f10a801d47ca548ab9bd894731dafee88420c50ae62a9705f9bfbcfa75060"
    sha256 cellar: :any,                 arm64_sonoma:  "19758065be63eeb895166e0bc445ce361db8ef0b989a0a3a3b91f7715303032b"
    sha256 cellar: :any,                 sonoma:        "31de32409dcb2cb7ba9b17c6b2b75cca7c41dd7a456607d11827338fd826e547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b75e668f31164bd613d84afe26db0f6e006d29dc74aa24d6d6f8efa1ac0a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b994f6a0fed87bf1d10330cfb34e9e3cc86863cc6fcd5af7fe2090608fed2727"
  end

  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:fvm"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    system "dart", "pub", "get"
    system "dart", "compile", "aot-snapshot", "--output", "fvm.aot", "bin/main.dart"
    libexec.install "fvm.aot"

    (bin/"fvm").write <<~BASH
      #!/bin/bash
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/fvm.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fvm --version")

    output = shell_output("#{bin}/fvm api context --compress")
    context = JSON.parse(output).fetch("context")
    assert_equal version.to_s, context.fetch("fvmVersion")
    assert_equal testpath.to_s, context.fetch("workingDirectory")

    assert_match "No SDKs have been installed yet.", shell_output("#{bin}/fvm list")
  end
end
