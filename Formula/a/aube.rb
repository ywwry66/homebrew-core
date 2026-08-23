class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a6772070e66399a400d942f8ee4fab3ea0babe02fa97f3a4eb255ce776172415"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4f763855ef0ad27c33340a6b7d6b228fa6eb161623905f6d8f3b00b17c3b59f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0c6848180556a6b77b0eb35b6aaf67b0113e95d8274fb39998ca2a6818a187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "330422fc7a92f96d90ac9448bcd50f7e51b462b23fca0b8cf9edc241442ad913"
    sha256 cellar: :any_skip_relocation, sonoma:        "216c80465ac860123f9358b5211a258b080b24012e0a0ef4808847dd785d7529"
    sha256 cellar: :any,                 arm64_linux:   "80a403b1d5abaf6aa2733fe2239c7ef909236f82eb09079e22b6b0d472443b0c"
    sha256 cellar: :any,                 x86_64_linux:  "d7afee6d6dd7acbf2455abd312bf97d73edbf4207b98d74159740b3ef2e3adf9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
