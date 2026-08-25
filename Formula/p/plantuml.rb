class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2026.7/plantuml-1.2026.7.jar"
  sha256 "33aa7ed0ca843e300690230d09268e1f526fdde7e86fecdfa39fb80412cafcde"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15ef2b96e5a758e848700346d54b8383f10de827cf84704a05fc73e8dfed42fe"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~BASH
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{formula_opt_bin("graphviz")}/dot" exec "#{formula_opt_bin("openjdk")}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    BASH
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
