class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/4.0.0/tika-app-4.0.0.zip"
  mirror "https://archive.apache.org/dist/tika/4.0.0/tika-app-4.0.0.zip"
  sha256 "56e487cbba0794da5c025a25bf94d92fc5f76a6ba447f96d8238ca2f4687eed7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98a6e680a5ef5d0fac4c8b2b5b09241cee64592599f586806c01887e11fb5b15"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/4.0.0/tika-server-standard-4.0.0.zip"
    mirror "https://archive.apache.org/dist/tika/4.0.0/tika-server-standard-4.0.0.zip"
    sha256 "ebacca686b4855648197414fe1b72638c417955d86659d78146851e7e57ff299"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "update `server` resource" if version != resource("server").version
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  service do
    run [opt_bin/"tika-rest-server"]
    working_dir var/"tika"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = spawn bin/"tika-rest-server", "--port=#{port}"

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
