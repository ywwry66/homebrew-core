class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "19b91c9a291e77ad71b3acb231ecbd052df75d2fcabbf47582cb3d9807ee8119"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8403bbb3f7f37c218119f818c59d0c39cba586f7ffa604d2c7381a95dc4da49a"
    sha256 cellar: :any, arm64_sequoia: "be79a28833c3fde89ee6d7a0bc90b58333d84f6855621bf0090ab547886468af"
    sha256 cellar: :any, arm64_sonoma:  "e2b567ec441f682e88dbd01f4b0f29ca9a14993b070bebedcf84eaffc4bdc8cb"
    sha256 cellar: :any, sonoma:        "47097c5ea1b7ddc7b241da05136c7d860aaddfe2f15be53c5a8525c8fb7ee0c6"
    sha256 cellar: :any, arm64_linux:   "bf72e6db929e140e4aa98bec21f952d1965342ef61a1f91928d85d686100ded3"
    sha256 cellar: :any, x86_64_linux:  "92e47d7bfb6de9e02936bb0f6b1d841ff657039d3bf69f7151162759aeaf0f68"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  # Add missing <algorithm> include, upstream PR, https://github.com/LadybugDB/ladybug/pull/855
  patch do
    url "https://github.com/LadybugDB/ladybug/commit/1411b812e9d9a40cb0129fda76e72c902fb1f3d8.patch?full_index=1"
    sha256 "a008f8a9bb4913ed2a743cd02149992f04de90abf6fdd118c14025798dbd9772"
    type :unofficial
    resolves "https://github.com/LadybugDB/ladybug/pull/855"
  end

  # Add more standard library includes that libc++ 23 no longer provides transitively
  patch do
    url "https://github.com/LadybugDB/ladybug/commit/464d7f38134dc2b45ad7b0d8ebf8a7943a748f0d.patch?full_index=1"
    sha256 "76f344776c4a992eb26d22063d9ab72a260a948f8e98c640e3dea8ac2d4e91b2"
    type :unofficial
    resolves "https://github.com/LadybugDB/ladybug/pull/860"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unwanted headers and libraries for `cppjieba`
    rm_r Dir["{#{include},#{share}}/cppjieba/*"]
  end

  test do
    # Upstream versioning up to patch version, so skip for 4th number in version
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end
