class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-5.1.1.zip"
  sha256 "df7ea9f9df529eddd85964ff357973c70c0d6a3509dad3773e944659eb33544b"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52eb299bac3a2f7eb29b1bf15a13b01f69d8dc0136ff2d5f345c14f413ca5653"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm(Dir["bin/*.bat"])

    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
  end

  test do
    system bin/"grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
