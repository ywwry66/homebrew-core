class Gffcompare < Formula
  desc "Compare, merge and annotate GFF/GTF transcript files"
  homepage "https://ccb.jhu.edu/software/stringtie/gffcompare.shtml"
  url "https://github.com/gpertea/gffcompare/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "c708798c873b83b7a3c8e5a779da885b4d24e6039eebc6990d235aa8efe77646"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git", branch: "master"

  def install
    system "make", "release"
    bin.install "gffcompare", "trmap"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    system bin/"gffcompare", "-r", "annotation.gff", "transcripts.gtf"

    tmap = (testpath/"gffcmp.transcripts.gtf.tmap").read
    assert_match "gene55473\trna157470\tm\tSTRG.1\tSTRG.1.1", tmap
    assert_match(/Query mRNAs :\s+5 in\s+5 loci/, (testpath/"gffcmp.stats").read)

    assert_match "STRG.1.1", shell_output("#{bin}/trmap annotation.gff transcripts.gtf")
  end
end
