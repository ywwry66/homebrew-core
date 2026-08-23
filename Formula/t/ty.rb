class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/88/0f/c767853e88567a2ec7e996dd95e3105b1bc62c95d103689311ef0f4a603c/ty-0.0.74.tar.gz"
  sha256 "da14344fc8625fc9ff359bafb856ad575636ea86d9bb6a629b146bff27b380e6"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caabcff81c7f7093fec7b80d2f49888792a5a64655cbe0a38933822916637d9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da22318f06765c269f9b9c9853f1ad50f5057b5694f5b16277297e95729e30fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca13a9e967319e1a8cdb70d588bc87200639fd3114c4c38221579c3e5202ea7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8716726bc1117044c12ee352fc2bf2008cbd3030dff4e1ffe95ac649d8d1f426"
    sha256 cellar: :any,                 arm64_linux:   "27be5feb968e64f0ecad0b4e4d8f90443f42800769bd4ba5a44a90af3cc8ebf9"
    sha256 cellar: :any,                 x86_64_linux:  "6d49a32a6dcf91b979ef89634b3bd922cd6ea68d5b6007c7e5dd28115705f6cc"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
