class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.0.0.tar.gz"
  sha256 "e7489414d2da9fdb4b0aab6b90479c5cea672fbf515221e9fc24124feef3dedc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "c8a59843f6224b2f6a81fc78a801f5d7ec828f5dee3c078388dc778e5b0c3fa7"
    sha256                               arm64_sequoia: "a32a021489ebe6e363d83a6f926fc26c8baa7dd06c15199cc12ca6809afe9344"
    sha256                               arm64_sonoma:  "8967826814b961f022ef568eccc0a7f319baf0a3d873fe12782d860e2dc6cd47"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b46f85bed80d118dc0be58bdc33952c31fcfce0f70a4ba5847f4d44674bd940"
  end

  depends_on "bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "run", "build"

    bin.install "dist/crowdin"
  end

  test do
    (testpath/"crowdin.yml").write <<~YAML
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/t1/**/*",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    YAML

    assert "Failed to collect project info",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml 2>&1", 102)
  end
end
