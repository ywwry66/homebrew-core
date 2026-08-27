class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.15.2.tgz"
  sha256 "ba815d77ef726ae1319dda19f689bae7d5fa2a0db9650b6619b82d3a593e9e62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e16587bd4191273f56120143f0e6443234bff513bd5875ab65c1959ba269322"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4dfcf7af1bd49048d02bece28af362cb3065019dfe5d39af6464781abb1dfda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25f50dcd00035fcd6dbe086e307a61ee434ae2ed99c0789fc14b7289c71bb0fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce4f190e8ae6c0aaf33de72bf808d3c98a25b9444d5418124427b9eaee7ab16b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a003d750c06a37420a9a7b7ad71d8732dbcab4b54d72661178392c8efe0d4919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a003d750c06a37420a9a7b7ad71d8732dbcab4b54d72661178392c8efe0d4919"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    # Replace prebuilt binary by compiling based on upstream build script:
    # https://github.com/oldj/node-font-list/blob/master/scripts/build-darwin.sh
    cd libexec/"lib/node_modules/yamlresume/node_modules/font-list/libs/darwin" do
      rm("fontlist")
      system ENV.cc, "fontlist.m", "-framework", "AppKit", "-framework", "Foundation", "-o", "fontlist"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
