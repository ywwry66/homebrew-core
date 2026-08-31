class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "cdabbd70646c41f48fded463fd937a79b1686b3bed6673d14eb9dd9e0e4663f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ed7ccd776762896cae329061f28894faa5878c1c4253df6dc70c6d459afb14c"
    sha256 cellar: :any, arm64_sequoia: "6dc62f8cdba9d01bf911b9cee55ee0a3c34d1aa9ff52167459a145a55ed711a8"
    sha256 cellar: :any, arm64_sonoma:  "68869fee25e58c1cc3cb6b3a5204fdadde090c07a8c9667e812753f49880bd75"
    sha256 cellar: :any, sonoma:        "70b2fedede54de683de486cb11fae2651d602cf69399d2b756a98d23320bdfef"
    sha256 cellar: :any, arm64_linux:   "14a37cdeba8a4c6bf0e3b1fa948d2bdfbc04e11bce7f318f99e8a5370a40bd1a"
    sha256 cellar: :any, x86_64_linux:  "96a2e01e1b04b381fd598293afe428585e30ea823ca676500b6dba1ddaba458b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read
  end
end
