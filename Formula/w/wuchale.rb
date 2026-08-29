class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.26.1.tgz"
  sha256 "4fec4a91f3a994e8e018315f4d4499391ede814046f1cf6bfdfeb4211152b951"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed50cd2da1a419563048356ada1edb0862d4e3a6a25088091f413bd9ce9c1852"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
