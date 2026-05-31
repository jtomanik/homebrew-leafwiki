class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.2d6239f"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.2d6239f/leafwiki-0.11.0-dev.2d6239f-darwin-arm64.tar.gz"
    sha256 "2945e38d85bfb969e80d1deee8b5aa912739c536fcfd2b2e727d11cfc6713714"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.2d6239f/leafwiki-0.11.0-dev.2d6239f-darwin-amd64.tar.gz"
    sha256 "b633a67c2c967c2851cf3464ec520dea2f1f26a7d3914e3375396fd90b8d495f"
  end

  def install
    bin.install "leafwiki"
    bin.install "leafwiki-local-mcp"
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    assert_match "leafwiki-mcp-stdio bridges", shell_output("#{bin}/leafwiki-local-mcp --help 2>&1")
  end
end
