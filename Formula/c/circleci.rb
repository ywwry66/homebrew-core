class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49012",
      revision: "3bc297635b4d9ff9060f13d6b6ff437e660cccde"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1982491e5c702f93675f00643346525832d979e3b801ec6f916957f6f8e0933d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af921f43128dfd3874e97cc5bddb1352a5856f78b74f8c5b24754985ad5c0c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1481258373e856f84e7fcc3e34a0bcde9f971fbaa5bdbd1a6bcb11c117856c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9771b9a0529023c003f953d0e43ffc8295adff3be4d240f07fc1e91c4ec5b7"
    sha256 cellar: :any,                 x86_64_linux:  "9d560e6b69a8c52a674d7eb65b4e9780402f65aa05ea7753713d077460e663ed"
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
