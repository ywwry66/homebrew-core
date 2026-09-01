class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49092",
      revision: "3390415c1270889aaae2e147d3fb279ded39bdf0"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea4f177f00a0edf45c5dd72f5033c0f961c514a2a62b0c0854764c68c19b954b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81a0a4b4f5069304c411bbeac29d0cf957745d3bf130f2efc48282ab38bbeeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e645690e5488d9b9a194e4fe1438024d86eae95e6c2fad7bb8318279b19bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2681029d40cfdba5fae0930eb16eeae986b509f9b4e192aa724bf84366020fa"
    sha256 cellar: :any,                 x86_64_linux:  "a193e81caef6def868f0887743361227a74093af7f9590f1ecbd537b75ae9a8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
