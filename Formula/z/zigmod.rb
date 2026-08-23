class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://github.com/nektro/zigmod/archive/refs/tags/r103.tar.gz"
  sha256 "965bd1aacbe4fee5c3dbbe0715d40f5b6a6413065bf5dc0385ba1ba1acc6c2e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "191db97f9a713579a2e77e19094341fdf4dba14c759317f0a4c4dee97655f108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99193968424db2d8466faca76289850d8b0328ed98d0b335e8b33a0264b59140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a25ace134ea328fb7b2194bf423aa39f9cada68dfbb3bead606737a7fefb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802a610c37181a0ace9e4013ec5ebc2d0f83f1dc4bf139299c8127b9d0513093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16cb1acf242e2c9a8cb520633cf1befd7139391a76d88ad10a031d443c31431e"
  end

  depends_on "pkgconf" => :build
  depends_on "zig@0.15"

  def install
    args = %W[
      -Dtag=r#{version}
      -Dstrip=true
    ]

    # Upstream doesn't use `-Doptimize`, see: https://github.com/nektro/zigmod/pull/109
    system "zig", "build", *args, *std_zig_args.map { |s| s.sub "-Doptimize=", "-Dmode=" }
  end

  test do
    (testpath/"dependency/src").mkpath
    (testpath/"dependency/zigmod.yml").write <<~YAML
      id: 8w9skd2bi3x7vh6z6xcu3taaz1tww2ghbjt5p1e9fyj1pgsu
      name: zigmod-test-dependency
      main: src/lib.zig
      license: MIT
      description: Test zig.mod dependency
      min_zig_version: 0.11.0
      dependencies:
    YAML
    (testpath/"dependency/src/lib.zig").write <<~ZIG
      pub fn message() []const u8 {
        return "Hello from zigmod dependency!";
      }
    ZIG
    system "git", "-C", testpath/"dependency", "init"
    system "git", "-C", testpath/"dependency", "add", "."
    system "git", "-C", testpath/"dependency", "-c", "user.name=Homebrew",
                  "-c", "user.email=brew@test-bot.local", "commit", "-m", "init"

    (testpath/"zigmod.yml").write <<~YAML
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git #{testpath}/dependency
    YAML

    (testpath/"src/lib.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
        std.log.info("Hello, world!");
      }
    ZIG

    system bin/"zigmod", "fetch"
    assert_path_exists testpath/"deps.zig"
    assert_path_exists testpath/"zigmod.lock"

    assert_match version.to_s, shell_output("#{bin}/zigmod version")
  end
end
