class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.0/llvm-project-23.1.0.src.tar.xz"
  sha256 "ab1f0e3ec52448c33e8782eaf0422504b87c7b016b22514653ee0d8fcee479ff"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "20b758ea0f85206173d2e5d0cb1fae821c1e564734ef41710c0dcce16ecae001"
    sha256 cellar: :any, arm64_sequoia: "52eda2ab54bbd01f932b378d0f9252c603991777e1a8ba82e1c2e0dcfb8008d5"
    sha256 cellar: :any, arm64_sonoma:  "7d954df221c0306b9ac081664929e5e8d846af67f5369bb731c603003de15dfa"
    sha256 cellar: :any, sonoma:        "ffa0ea875d7f2df92b0e6626ceefaf14b7bf9c1f6f770bbd732e54b04a172b10"
    sha256 cellar: :any, arm64_linux:   "fa97216a9bbab8cb142d0a997971de723fa64e037d6bfc0e1129927a1a7ec0bf"
    sha256 cellar: :any, x86_64_linux:  "2ffd460a8f75247262e09eb2854d007fa85b9c86a855196d78f6db4dd53a072a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  fails_with :gcc do
    cause "needs 2x or more memory to build: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=119705"
  end

  def install
    llvm = Formula["llvm"]
    resource_dir = Pathname(Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp)
    relative_resource_dir = resource_dir.realpath.relative_path_from(llvm.prefix.realpath)
    clang_resource_dir = llvm.opt_prefix/relative_resource_dir
    flang_resource_dir = prefix/relative_resource_dir

    common_args = %W[
      -GNinja
      -DBUILD_SHARED_LIBS=ON
      -DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm
      -DLLVM_ENABLE_FATLTO=ON
      -DLLVM_ENABLE_LTO=ON
    ]

    flang_args = %W[
      -DCLANG_DIR=#{llvm.opt_lib}/cmake/clang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_RAM_PER_COMPILE_JOB=5000
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}/cmake/mlir
    ]
    flang_args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?

    flang_rt_args = %W[
      -DCMAKE_Fortran_COMPILER_WORKS=ON
      -DCMAKE_Fortran_COMPILER=#{bin}/flang
      -DFLANG_RT_ENABLE_SHARED=ON
      -DFLANG_RT_ENABLE_STATIC=ON
      -DFLANG_RT_INCLUDE_TESTS=OFF
      -DLIBOMP_FORTRAN_MODULES_ONLY=ON
      -DLLVM_BINARY_DIR=#{llvm.opt_prefix}
      -DLLVM_ENABLE_RUNTIMES=flang-rt;openmp
      -DLLVM_INCLUDE_TESTS=OFF
      -DOPENMP_ENABLE_OMPT_TOOLS=OFF
    ]

    system "cmake", "-S", "flang", "-B", "build", *flang_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", "runtimes", "-B", "build-rt", *flang_rt_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build-rt"
    system "cmake", "--install", "build-rt"

    # Add symlink to avoid extra RPATH on Linux. See if the upstream provides a better way of handling:
    # https://github.com/llvm/llvm-project/blob/main/flang-rt/cmake/modules/AddFlangRT.cmake#L379-L392
    lib.install_symlink flang_resource_dir.glob("lib/*/#{shared_library("*")}")

    # Remove the C/Fortran header that we manually install in `llvm` formula.
    header = "include/ISO_Fortran_binding.h"
    odie "Check on ISO_Fortran_binding.h!" unless identical?(clang_resource_dir/header, flang_resource_dir/header)
    rm(flang_resource_dir/header)
    rmdir(flang_resource_dir/"include") # intentionally not using rm_r to fail on new headers

    # Allow flang to find LLVM libraries as it expects them relative to driver
    symlink_src_paths = clang_resource_dir.glob("lib/**/*").select(&:file?) + [
      clang_resource_dir/"include",
      llvm.opt_lib/shared_library(OS.mac? ? "libLTO" : "LLVMgold"),
      llvm.opt_lib/shared_library("libomp"),
    ]
    symlink_src_paths.each { |src| (prefix/src.relative_path_from(llvm.opt_prefix)).make_relative_symlink src }
    (prefix/"etc").install_symlink etc/"clang"

    # FIXME: Flang 23 now installs Fortran modules into a path with macOS full kernel version.
    # As a workaround, we symlink into original path so they work across macOS security updates
    if OS.mac?
      triple = Utils.safe_popen_read(llvm.opt_bin/"clang", "--print-target-triple").chomp
      (include/"flang").install_symlink (flang_resource_dir/"finclude/flang"/triple).children
    end
  end

  test do
    (testpath/"hello.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    (testpath/"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN

    system bin/"flang", "-v", "hello.f90", "-o", "hello"
    assert_equal "Hello World!", shell_output("./hello").chomp

    system bin/"flang", "-v", "-flto", "test.f90", "-o", "test"
    assert_equal "Done", shell_output("./test").chomp

    (testpath/"omptest.f90").write <<~FORTRAN
      PROGRAM omptest
      USE omp_lib
      !$OMP PARALLEL NUM_THREADS(4)
      WRITE(*,'(A,I1,A,I1)') 'Hello from thread ', OMP_GET_THREAD_NUM(), ', nthreads ', OMP_GET_NUM_THREADS()
      !$OMP END PARALLEL
      ENDPROGRAM
    FORTRAN

    system bin/"flang", "-v", "-fopenmp", "omptest.f90", "-o", "omptest"
    testresult = shell_output("./omptest")

    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    sorted_testresult = testresult.split("\n").sort.join("\n")
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"runtimes.f90").write <<~FORTRAN
      Program main
        Complex :: y
        y = y/2
      End Program
    FORTRAN
    system bin/"flang", "-v", "runtimes.f90"

    return if OS.linux?
    return unless (etc/"clang").exist? # https://github.com/Homebrew/homebrew-test-bot/issues/805

    assert_match %r{^Configuration file: .*/etc/clang/.*\.cfg$}i,
                 shell_output("#{bin}/flang --version")
  end
end
