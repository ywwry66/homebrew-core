class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "cacec89bd105d8f0da73537054e471e818c983cf9b453e79ca17bd5d7afaefbe"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b25ef5ee0e90e38e71694b16f14be4ab9d9929172d3afd303fa502c6c590da9"
    sha256 cellar: :any, arm64_sequoia: "16aadf6e62295187d42869ed30dbdf200b0a58033cb79f7ddf92dc736a75d6df"
    sha256 cellar: :any, arm64_sonoma:  "34cccafe8f81d3fe31fee179a5537f2c04c1d13c992bf51d997ed0619fcd2392"
    sha256 cellar: :any, arm64_linux:   "5b26f974a618b88cec8f9f8cf2d8c6c863b1c5d97134c67083dc929ae76dfcee"
    sha256 cellar: :any, x86_64_linux:  "9343062093a601698d403d38ac82172b70f8dc9b9e7caf047a139f31f807da25"
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

  def install
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

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
