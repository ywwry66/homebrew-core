class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "8eff3e5fe159d2a718e578808b129a8603b45e91c54f194704c20916acf181d6"
  license "ISC"
  compatibility_version 1
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5d780da58b7c74eff9bff8d785e09ee6337e1bd0110f64c8b56d1f0a4ada16f"
    sha256 cellar: :any,                 arm64_sequoia: "7413e13d1540f8a4dd02efd21158343a56ce2ce0a08a26c87fac4ce907f3f352"
    sha256 cellar: :any,                 arm64_sonoma:  "731bdc3bbf8cd9c3bb2b77a591a00769a40732cf10ed96a496c0472f7f7b905e"
    sha256 cellar: :any,                 sonoma:        "a842a34f619967b87993662603ea4377b0ccdb336eae88aa3b523afed6eff1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9149a77bd63d1d429ca394cc345f14545e01fd34ed8e02b3d21487477d057151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ca9e32707506cfb8d3044b804f5151e29a8429048f540c956db65f23785c74"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "liblo"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"simple.c", "simple.c"
    (testpath/"CMakeLists.txt").write <<~EOS
      add_executable(simple ${CMAKE_CURRENT_SOURCE_DIR}/simple.c)
      target_link_libraries(simple PRIVATE monome)
    EOS

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"

    # assert no output and failure for missing device
    assert_equal "", shell_output("build/simple", 255)
  end
end
