class OpenCodeReview < Formula
  desc "AI-powered code review tool with deterministic pipelines and an LLM agent"
  homepage "https://github.com/alibaba/open-code-review"
  url "https://github.com/alibaba/open-code-review/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "9f834e916b5038bdbebba4dfd18283e2ead1648d305c894aa87520ccb8e875b2"
  license "Apache-2.0"
  head "https://github.com/alibaba/open-code-review.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b2937348ff8f04e3bddb047aa34851148984ae360b589c8e56c0e3d72e4732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b2937348ff8f04e3bddb047aa34851148984ae360b589c8e56c0e3d72e4732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7b2937348ff8f04e3bddb047aa34851148984ae360b589c8e56c0e3d72e4732"
    sha256 cellar: :any_skip_relocation, sonoma:        "810538bcce05845e4fdb0b95ba02db34b4fdbd1426a5c051cb3101480bebf698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19b36cf5a5dcb35c66361a23da15f95485a1867e9eb672dda975f4bf9af1569"
    sha256 cellar: :any,                 x86_64_linux:  "15e8d49e5ee6b5593aeef8255e1290c757163b48798b001f751d9470b8edf9bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocr"), "./cmd/opencodereview"
    generate_completions_from_executable(bin/"ocr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocr --version")

    # "rules check" resolves which built-in review rule applies to a file.
    # It runs fully offline but expects to sit inside a git repo.
    system "git", "init", testpath
    (testpath/"main.go").write "package main\n"
    output = shell_output("#{bin}/ocr rules check main.go")
    assert_match "File: main.go", output
    assert_match "Pattern: **/*.go", output
    assert_match "Source: System built-in", output
  end
end
