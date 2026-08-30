class PlinkNg < Formula
  desc "Whole-genome association analysis toolset (PLINK 2.0)"
  homepage "https://www.cog-genomics.org/plink/2.0/"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.0.0-a.7.4.tar.gz"
  version "2.0.0-a.7.4"
  sha256 "370b8c6127deb5231b72a581f7869409db7fa314ef66e7b96553f621fdbe61a1"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-a\.\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d03ea01ab1c85e4ead87ba21ca5fcb2ab2a6ff4302edc4bfed1f6e76c395073"
    sha256 cellar: :any, arm64_sequoia: "e2edf93f8b4f65aac0e34706769864d6ad37669eeec55ccb70aab1df131c1bb8"
    sha256 cellar: :any, arm64_sonoma:  "09168d48489881f43385d782eadfa9ecdaabe5f16e9224380e316060c51e0325"
    sha256 cellar: :any, arm64_linux:   "411aed802a40536a706a870b092765aad045c019ce488bf07e9abc838edc14b6"
    sha256 cellar: :any, x86_64_linux:  "28a595a27b7595d2d24e489a9878fda886d2045e76e06da5d618bbdb8866351f"
  end

  depends_on "zstd"

  on_linux do
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  def install
    cd "2.0/build_dynamic" do
      # Link against zstd rather than the bundled copy.
      args = ["STATIC_ZSTD="]
      # OpenBLAS ships LAPACK and LAPACKE, so a single -lopenblas is enough.
      args << "BLASFLAGS=-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?

      system "make", *args
      bin.install "plink2", "pgen_compress"
    end
  end

  test do
    # Simulate a small cohort, then check the generated genotype file is usable.
    system bin/"plink2", "--dummy", "50", "100", "--out", "dummy"
    assert_path_exists testpath/"dummy.pgen"

    system bin/"plink2", "--pfile", "dummy", "--freq", "--out", "freq"
    freqs = (testpath/"freq.afreq").read
    assert_match "ALT_FREQS", freqs
    assert_equal 101, freqs.lines.count

    system bin/"plink2", "--pfile", "dummy", "--make-bed", "--out", "binary"
    assert_path_exists testpath/"binary.bed"

    # --pca goes through the BLAS/LAPACK backend.
    system bin/"plink2", "--pfile", "dummy", "--pca", "2", "--out", "pca"
    assert_equal 2, (testpath/"pca.eigenval").read.lines.count
  end
end
