class Khaos < Formula
  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3d20d75c1977eb9c490f10cbe09cfcbfdfc673479f499877fd7b872555c0c0c1"
  license "Apache-2.0"
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27aae6be06ea65e71b4526de56ea5fc931266fe0a3026924920f6a4e6144042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34411877f46172d6f042ff9ed4be47f92853b0210e8580f8155316156b537e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "444cd5acc17ab739bd7bb86206dcb9d697a34161ec17814858fc7424a7f08af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "48fea830726057ec7c84f1b2eba291f7f5eae437aad7c82f022af464e5ada476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1683aedd45cd01dbbcef388c7da973e9170bdd5241909d648b4e0d35ce75420"
    sha256 cellar: :any,                 x86_64_linux:  "41d80a8196f1a046942670a3913f3deb59723ffad3c01a4e522bdf04c40d2b83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/khaos"
    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
  end
end
