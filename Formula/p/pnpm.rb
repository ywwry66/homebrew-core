class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.24.0.tgz"
  sha256 "d1eab2433172661cc36a18ec85fce93f771db1962717329cc01ec9c2824ca24f"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "82d7e8560c5192ffa92ba0fec2db3f70fcd78a36dc43d3bb1ef5147b4511be52"
    sha256 cellar: :any,                 arm64_sequoia: "82d7e8560c5192ffa92ba0fec2db3f70fcd78a36dc43d3bb1ef5147b4511be52"
    sha256 cellar: :any,                 arm64_sonoma:  "82d7e8560c5192ffa92ba0fec2db3f70fcd78a36dc43d3bb1ef5147b4511be52"
    sha256 cellar: :any,                 tahoe:         "6c64d4d4f1d239f1759a4083a85a737a08e46ec668de6c0716b043b635267b99"
    sha256 cellar: :any,                 sequoia:       "6c64d4d4f1d239f1759a4083a85a737a08e46ec668de6c0716b043b635267b99"
    sha256 cellar: :any,                 sonoma:        "6c64d4d4f1d239f1759a4083a85a737a08e46ec668de6c0716b043b635267b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5542eb4192344444b735ddb2dc85fb3a6ed21113f5ccda4ec482678b1534b691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5542eb4192344444b735ddb2dc85fb3a6ed21113f5ccda4ec482678b1534b691"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  # downloads npm packages during install
  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
