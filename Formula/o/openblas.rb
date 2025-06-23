class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "6dd2a63ac9d32643b7cc636eab57bf4e57d0ed1fff926dfbc5d3d97f2d2be3a6"
  # The main license is BSD-3-Clause. Additionally,
  # 1. OpenBLAS is based on GotoBLAS2 so some code is under original BSD-2-Clause-Views
  # 2. lapack-netlib/ is a bundled LAPACK so it is BSD-3-Clause-Open-MPI
  # 3. interface/{gemmt.c,sbgemmt.c} is BSD-2-Clause
  # 4. relapack/ is MIT but license is omitted as it is not enabled
  license all_of: ["BSD-3-Clause", "BSD-2-Clause-Views", "BSD-3-Clause-Open-MPI", "BSD-2-Clause"]
  head "https://github.com/OpenMathLib/OpenBLAS.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "135aee4c324efce7de6269682367ce7a934daabb873c2edc0ea32e77d5857bd7"
    sha256 cellar: :any,                 arm64_sequoia: "c8b91996840c394ac8f97e200bffacc20c300b5ec4f7d0b30d89f35a8e973c86"
    sha256 cellar: :any,                 arm64_sonoma:  "978353b2670e5ccb034c4b5c68fc75747bfc3c95b50bc1c412030f5c6d50637c"
    sha256 cellar: :any,                 sonoma:        "bb4e278d374d524fe6284140264907278d29a1bd373a94b32fe039295b881ec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc71fe7c9141a710dcfef0277565ba7d58eaa63c35718fc38fd77e01e4a61e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa5c092b66e69dd666b9476801dfd33a7bd84041a3ce85fd32b4e9b78a95b9b"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "gcc" # for gfortran

  on_macos do
    depends_on "libomp"
  end

  # Fix configuration header on Linux Arm with GCC 12
  # https://github.com/OpenMathLib/OpenBLAS/pull/5606
  patch do
    url "https://github.com/OpenMathLib/OpenBLAS/commit/c077708852c7262b6bc0da6bc094b447e7ba7b3c.patch?full_index=1"
    sha256 "e59596a7bec1fa6c22c4bee20c8040faa15fa57aa6486acd99b9688aef15f4da"
  end

  def install
    ENV.runtime_cpu_detection

    target = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    when :westmere
      "NEHALEM"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    args = %W[
      -DUSE_OPENMP=ON
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=ON
      -DNUM_THREADS=64
      -DTARGET=#{target}
    ]

    args << "-DDYNAMIC_ARCH=ON" if !OS.mac? || Hardware::CPU.intel?

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_Fortran_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
    pkgshare.install "cpp_thread_test"

    inreplace lib/"pkgconfig/openblas.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    cp_r pkgshare/"cpp_thread_test/.", testpath
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkgconf --cflags --libs openblas").chomp.split
    %w[dgemm_thread_safety dgemv_thread_safety].each do |test|
      inreplace "#{test}.cpp", '"../cblas.h"', '"cblas.h"'
      system ENV.cxx, *ENV.cxxflags.to_s.split, "-std=c++11", "#{test}.cpp", "-o", test, *flags
      system "./#{test}"
    end
  end
end
