class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2481.tar.gz"
  sha256 "6a7cf2d2c2053971e90e5c1ff3c8769e718729764e3e923df823a0be5b5d06da"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5a2bbe2d6bd1a072ef7a09f646668cda6198777ec4a17128a0249288fbd8ce61"
    sha256 cellar: :any, arm64_sequoia: "e4728c997732abe3a9f33d4f3f89db5c7b383511d443cce69d7e8dca13d684f3"
    sha256 cellar: :any, arm64_sonoma:  "7699dc6824e601a2beb706651261de1002c6adc45390670d7e0ec180f49cdbcd"
    sha256 cellar: :any, sonoma:        "ea2fd22eed6675c3dcbce84d8eaa0e1249442d2bbbec9ac71c66dc678b1c0357"
    sha256 cellar: :any, arm64_linux:   "430253ba38b03ac6956c462108c805c2b61a40db07bdd1c3ad878d1756fee2e1"
    sha256 cellar: :any, x86_64_linux:  "92beccf772161b55e40f419712396d86af22d2b56eb213ec569269337489aea2"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
