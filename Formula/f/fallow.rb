class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "82fab87458cadcda76805d806c769aa8ed99f6059af2ddc2df57f68454a6ee99"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01c0ef56261781b667e0f2f41d04a4dc320beed7bed499427523dfad18950ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e030893e3782ccff79787a921ae29566041f3a52d8b841256d3a217c747b30a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac5e1a5b45283872655de0195faf3b50a1c2006182dfb6d1b554b51719b2da3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "483353648b018c1a4da6c37d402383812e15db29d6180d711a9b51dcc6944d1e"
    sha256 cellar: :any,                 arm64_linux:   "375093311210ee88ba5eb407bacc823ad30e1c6b7e5af8bff74426ffa08567f4"
    sha256 cellar: :any,                 x86_64_linux:  "aa223dcc04d611c8101ff8bb5cfc5f4e552875052b3287b700af334d3e571afe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end
