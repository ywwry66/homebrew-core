class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "176f62fa0d40d60b5effcd0c07b69265fef86e0197aaf01a0905a79bba9a4039"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "485075f850b181ccf37d327a351e64665465c568d77b897863fdd680c051c493"
    sha256 cellar: :any, arm64_sequoia: "44e052a3de64af22172235ee98bfe8fb730a74276b5317b0fab4d2e5662cceb6"
    sha256 cellar: :any, arm64_sonoma:  "2c61ce39f8754f595bf4e2b163eefbca105b01fcaad254d51362712bbe2a4f87"
    sha256 cellar: :any, sonoma:        "9ad03308261c91eb3959c7f8ec25c67aaf8fb17fd600c34597fba479ee5dfd7c"
    sha256 cellar: :any, arm64_linux:   "27294b65332408069e5f81f22a4a395cb8275f9454ac8181794802f9d9b08306"
    sha256 cellar: :any, x86_64_linux:  "dc6d24a3367a5ba09793838962f5ab57c366acd006a8e02503e57d3fb64919a1"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
